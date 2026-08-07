import 'package:awarex/core/enums/threat_level.dart';
import 'package:flutter/material.dart';

import 'package:awarex/core/enums/safety_state.dart';
import 'package:awarex/models/safety/safety_state_data.dart';

import 'package:awarex/widgets/diagnostics/diagnostic_card.dart';
import 'package:awarex/widgets/diagnostics/diagnostic_tile.dart';

class SafetyStateCard extends StatelessWidget {
  final SafetyStateData safety;

  const SafetyStateCard({super.key, required this.safety});

  @override
  Widget build(BuildContext context) {
    return DiagnosticCard(
      child: Column(
        children: [
          DiagnosticTile(
            label: 'Safety State',
            value: safety.state.label,
            valueColor: _color(safety.state),
          ),

          DiagnosticTile(
            label: 'Threat Level',
            value: safety.threatLevel.label,
          ),

          DiagnosticTile(
            label: 'Severity',
            value: safety.state.severity.toString(),
          ),

          DiagnosticTile(
            label: 'Last Updated',
            value: _formatTime(safety.timestamp),
          ),
        ],
      ),
    );
  }

  Color _color(SafetyState state) {
    switch (state) {
      case SafetyState.safe:
        return Colors.green;

      case SafetyState.aware:
        return Colors.blue;

      case SafetyState.alert:
        return Colors.orange;

      case SafetyState.danger:
        return Colors.deepOrange;

      case SafetyState.emergency:
        return Colors.red;
    }
  }

  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    final second = time.second.toString().padLeft(2, '0');

    return '$hour:$minute:$second';
  }
}
