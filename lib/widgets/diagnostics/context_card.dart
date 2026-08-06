import 'package:flutter/material.dart';

import 'package:awarex/models/context/context_data.dart';

import 'diagnostic_card.dart';
import 'diagnostic_tile.dart';

class ContextCard extends StatelessWidget {
  final ContextData context;

  const ContextCard({super.key, required this.context});

  @override
  Widget build(BuildContext contextWidget) {
    return DiagnosticCard(
      child: Column(
        children: [
          DiagnosticTile(
            label: 'Movement',
            value: context.movement.name.toUpperCase(),
          ),
          DiagnosticTile(
            label: 'GPS Reliable',
            value: context.gpsReliable ? 'Yes' : 'No',
            valueColor: context.gpsReliable ? Colors.green : Colors.orange,
          ),
          DiagnosticTile(
            label: 'Battery Low',
            value: context.batteryLow ? 'Yes' : 'No',
            valueColor: context.batteryLow ? Colors.red : Colors.green,
          ),
          DiagnosticTile(
            label: 'Charging',
            value: context.charging ? 'Yes' : 'No',
            valueColor: context.charging ? Colors.green : null,
          ),
          DiagnosticTile(
            label: 'Offline',
            value: context.offline ? 'Yes' : 'No',
            valueColor: context.offline ? Colors.orange : Colors.green,
          ),
          DiagnosticTile(
            label: 'Screen On',
            value: context.screenOn ? 'Yes' : 'No',
          ),
          DiagnosticTile(
            label: 'Time Context',
            value: context.timeContext.name.toUpperCase(),
          ),
        ],
      ),
    );
  }
}
