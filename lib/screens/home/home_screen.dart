import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:awarex/providers/context/context_provider.dart';
import 'package:awarex/providers/emergency/emergency_message_provider.dart';
import 'package:awarex/providers/emergency/emergency_provider.dart';
import 'package:awarex/providers/safety/safety_provider.dart';
import 'package:awarex/providers/threat/threat_provider.dart';

import 'package:awarex/screens/contact/trusted_contacts_screen.dart';
import 'package:awarex/screens/developer/developer_diagnostics_screen.dart';

import 'package:awarex/widgets/emergency/emergency_message_card.dart';
import 'package:awarex/widgets/home/quick_action_grid.dart';
import 'package:awarex/widgets/home/recommendation_card.dart';
import 'package:awarex/widgets/home/safety_banner.dart';
import 'package:awarex/widgets/home/status_summary_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void _openTrustedContacts(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const TrustedContactsScreen()),
    );
  }

  void _openDiagnostics(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const DeveloperDiagnosticsScreen()),
    );
  }

  Future<void> _generateEmergencyMessage(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final messenger = ScaffoldMessenger.of(context);

    try {
      final message = await ref
          .read(emergencyMessageServiceProvider)
          .generateEmergencyMessage();

      if (!context.mounted) {
        return;
      }

      if (message == null) {
        messenger.showSnackBar(
          const SnackBar(
            content: Text(
              'No trusted contact found. Add a trusted contact first.',
            ),
          ),
        );

        return;
      }

      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        showDragHandle: true,
        builder: (sheetContext) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: EmergencyMessageCard(message: message),
            ),
          );
        },
      );
    } catch (error) {
      if (!context.mounted) {
        return;
      }

      messenger.showSnackBar(
        SnackBar(content: Text('Unable to generate emergency message: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contextAsync = ref.watch(contextProvider);
    final threatAsync = ref.watch(threatProvider);
    final safetyAsync = ref.watch(safetyStateProvider);
    final emergencyAsync = ref.watch(emergencyProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AwareX'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.contacts_outlined),
            tooltip: 'Trusted Contacts',
            onPressed: () {
              _openTrustedContacts(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.developer_mode),
            tooltip: 'Developer Diagnostics',
            onPressed: () {
              _openDiagnostics(context);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(contextProvider);
          ref.invalidate(threatProvider);
          ref.invalidate(safetyStateProvider);
          ref.invalidate(emergencyProvider);
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            safetyAsync.when(
              data: (safety) => SafetyBanner(safety: safety),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => _ErrorCard(message: e.toString()),
            ),
            const SizedBox(height: 20),
            threatAsync.when(
              data: (threat) => StatusSummaryCard(
                title: 'Threat Level',
                value:
                    '${threat.level.name.toUpperCase()} '
                    '(${threat.score.toStringAsFixed(0)})',
                icon: Icons.warning_amber,
                color: Colors.orange,
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => _ErrorCard(message: e.toString()),
            ),
            const SizedBox(height: 20),
            emergencyAsync.when(
              data: (emergency) => StatusSummaryCard(
                title: 'Emergency Action',
                value: _formatEnum(emergency.action.name),
                icon: Icons.emergency,
                color: Colors.red,
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => _ErrorCard(message: e.toString()),
            ),
            const SizedBox(height: 24),
            const Text(
              'Current Context',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            contextAsync.when(
              data: (contextData) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      children: [
                        _row(
                          'Movement',
                          _formatEnum(contextData.movement.name),
                        ),
                        _row('Time', _formatEnum(contextData.timeContext.name)),
                        _row(
                          'GPS Reliable',
                          contextData.gpsReliable ? 'Yes' : 'No',
                        ),
                        _row(
                          'Battery Low',
                          contextData.batteryLow ? 'Yes' : 'No',
                        ),
                        _row('Offline', contextData.offline ? 'Yes' : 'No'),
                        _row('Screen On', contextData.screenOn ? 'Yes' : 'No'),
                      ],
                    ),
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => _ErrorCard(message: e.toString()),
            ),
            const SizedBox(height: 20),
            emergencyAsync.when(
              data: (emergency) => RecommendationCard(
                recommendations: emergency.recommendations,
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => _ErrorCard(message: e.toString()),
            ),
            const SizedBox(height: 20),
            QuickActionGrid(
              onDiagnostics: () {
                _openDiagnostics(context);
              },
              onFakeCall: () {
                _showInfoDialog(
                  context,
                  'Fake Call',
                  'Fake Call assistance will be connected '
                      'in the next bundle.',
                );
              },
              onNotifyContact: () {
                _generateEmergencyMessage(context, ref);
              },
              onSaferRoute: () {
                _showInfoDialog(
                  context,
                  'Safer Route',
                  'Safe Route Intelligence will be connected '
                      'in the next bundle.',
                );
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  static Widget _row(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Text(value),
        ],
      ),
    );
  }

  static String _formatEnum(String value) {
    final formatted = value.replaceAll('_', ' ');

    if (formatted.isEmpty) {
      return formatted;
    }

    return formatted[0].toUpperCase() + formatted.substring(1);
  }

  static void _showInfoDialog(BuildContext context, String title, String body) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  const _ErrorCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Text(message, style: const TextStyle(color: Colors.red)),
      ),
    );
  }
}
