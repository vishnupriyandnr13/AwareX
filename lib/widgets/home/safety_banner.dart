import 'package:flutter/material.dart';

import 'package:awarex/core/enums/safety_state.dart';
import 'package:awarex/models/safety/safety_state_data.dart';

class SafetyBanner extends StatelessWidget {
  const SafetyBanner({super.key, required this.safety});

  final SafetyStateData safety;

  @override
  Widget build(BuildContext context) {
    final color = _color(safety.state);

    return Card(
      elevation: 4,
      color: color.withOpacity(0.12),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: color,
              child: Icon(_icon(safety.state), color: Colors.white, size: 30),
            ),

            const SizedBox(width: 20),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Current Safety State",
                    style: TextStyle(fontSize: 15, color: Colors.black54),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    safety.state.label,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "Threat Level: ${safety.threatLevel.name.toUpperCase()}",
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
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

  IconData _icon(SafetyState state) {
    switch (state) {
      case SafetyState.safe:
        return Icons.shield;

      case SafetyState.aware:
        return Icons.visibility;

      case SafetyState.alert:
        return Icons.warning_amber;

      case SafetyState.danger:
        return Icons.priority_high;

      case SafetyState.emergency:
        return Icons.sos;
    }
  }
}
