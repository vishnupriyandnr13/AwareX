import 'package:flutter/material.dart';

import 'package:awarex/models/emergency/emergency_state.dart';
import 'package:awarex/core/enums/emergency_action.dart';

import 'package:awarex/widgets/diagnostics/diagnostic_card.dart';
import 'package:awarex/widgets/diagnostics/diagnostic_tile.dart';

class EmergencyCard extends StatelessWidget {
  final EmergencyState emergency;

  const EmergencyCard({super.key, required this.emergency});

  @override
  Widget build(BuildContext context) {
    return DiagnosticCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DiagnosticTile(
            label: 'Emergency Action',
            value: emergency.action.label,
            valueColor: _color(emergency.action),
          ),

          DiagnosticTile(
            label: 'Safety State',
            value: emergency.safetyState.label,
          ),

          DiagnosticTile(
            label: 'Threat Level',
            value: emergency.threatLevel.name.toUpperCase(),
          ),

          DiagnosticTile(
            label: 'Requires Attention',
            value: emergency.requiresAttention ? 'YES' : 'NO',
            valueColor: emergency.requiresAttention ? Colors.red : Colors.green,
          ),

          DiagnosticTile(
            label: 'Placeholder',
            value: emergency.placeholderAction ? 'YES' : 'NO',
          ),

          const SizedBox(height: 16),

          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Recommendations',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 8),

          ...emergency.recommendations.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("• "),
                  Expanded(child: Text(e)),
                ],
              ),
            ),
          ),

          DiagnosticTile(label: 'Updated', value: _time(emergency.timestamp)),
        ],
      ),
    );
  }

  Color _color(EmergencyAction action) {
    switch (action) {
      case EmergencyAction.silentMonitoring:
        return Colors.green;

      case EmergencyAction.periodicCheckIn:
        return Colors.blue;

      case EmergencyAction.recommendSaferRoute:
        return Colors.orange;

      case EmergencyAction.notifyTrustedContact:
        return Colors.deepOrange;

      case EmergencyAction.emergencyEscalation:
        return Colors.red;

      case EmergencyAction.fakeCall:
        return Colors.purple;
    }
  }

  String _time(DateTime t) {
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    final s = t.second.toString().padLeft(2, '0');

    return '$h:$m:$s';
  }
}
