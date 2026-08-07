import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:awarex/providers/context/context_provider.dart';
import 'package:awarex/providers/emergency/emergency_provider.dart';
import 'package:awarex/providers/safety/safety_provider.dart';
import 'package:awarex/providers/threat/threat_provider.dart';

import 'package:awarex/screens/developer/developer_diagnostics_screen.dart';

import 'package:awarex/widgets/home/quick_action_grid.dart';
import 'package:awarex/widgets/home/recommendation_card.dart';
import 'package:awarex/widgets/home/safety_banner.dart';
import 'package:awarex/widgets/home/status_summary_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contextAsync = ref.watch(contextProvider);
    final threatAsync = ref.watch(threatProvider);
    final safetyAsync = ref.watch(safetyStateProvider);
    final emergencyAsync = ref.watch(emergencyProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("AwareX"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.developer_mode),
            tooltip: "Developer Diagnostics",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const DeveloperDiagnosticsScreen(),
                ),
              );
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
                title: "Threat Level",
                value:
                    "${threat.level.name.toUpperCase()} (${threat.score.toStringAsFixed(0)})",
                icon: Icons.warning_amber,
                color: Colors.orange,
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => _ErrorCard(message: e.toString()),
            ),

            const SizedBox(height: 20),

            emergencyAsync.when(
              data: (emergency) => StatusSummaryCard(
                title: "Emergency Action",
                value: _formatEnum(emergency.action.name),
                icon: Icons.emergency,
                color: Colors.red,
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => _ErrorCard(message: e.toString()),
            ),

            const SizedBox(height: 24),

            const Text(
              "Current Context",
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
                          "Movement",
                          _formatEnum(contextData.movement.name),
                        ),
                        _row("Time", _formatEnum(contextData.timeContext.name)),
                        _row(
                          "GPS Reliable",
                          contextData.gpsReliable ? "Yes" : "No",
                        ),
                        _row(
                          "Battery Low",
                          contextData.batteryLow ? "Yes" : "No",
                        ),
                        _row("Offline", contextData.offline ? "Yes" : "No"),
                        _row("Screen On", contextData.screenOn ? "Yes" : "No"),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const DeveloperDiagnosticsScreen(),
                  ),
                );
              },
              onFakeCall: () {
                _showInfoDialog(
                  context,
                  "Fake Call",
                  "Prototype placeholder.\n\nFake Call will be implemented later.",
                );
              },
              onNotifyContact: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Trusted Contact notification (Prototype)"),
                  ),
                );
              },
              onSaferRoute: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Safer Route recommendation (Prototype)"),
                  ),
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
    return value
        .replaceAllMapped(RegExp(r'([A-Z])'), (m) => ' ${m.group(0)}')
        .trim();
  }

  static void _showInfoDialog(BuildContext context, String title, String body) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
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
