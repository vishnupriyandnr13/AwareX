import 'package:flutter/material.dart';

import 'package:awarex/core/enums/threat_level.dart';
import 'package:awarex/models/threat/threat_assessment.dart';
import 'package:awarex/core/enums/threat_reason.dart';

import 'diagnostic_card.dart';
import 'diagnostic_tile.dart';

class ThreatCard extends StatelessWidget {
  final ThreatAssessment threat;

  const ThreatCard({super.key, required this.threat});

  Color _levelColor() {
    switch (threat.level) {
      case ThreatLevel.safe:
        return Colors.green;

      case ThreatLevel.low:
        return Colors.lightGreen;

      case ThreatLevel.medium:
        return Colors.orange;

      case ThreatLevel.high:
        return Colors.deepOrange;

      case ThreatLevel.critical:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DiagnosticCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DiagnosticTile(
            label: "Threat Level",
            value: threat.level.label,
            valueColor: _levelColor(),
          ),

          DiagnosticTile(
            label: "Threat Score",
            value: threat.score.toStringAsFixed(0),
          ),

          const SizedBox(height: 12),

          const Text("Reasons", style: TextStyle(fontWeight: FontWeight.bold)),

          const SizedBox(height: 8),

          ...threat.reasons.map(
            (reason) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text("• ${reason.label}"),
            ),
          ),
        ],
      ),
    );
  }
}
