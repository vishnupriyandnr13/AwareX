import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:awarex/providers/sensor/battery_provider.dart';

import 'diagnostic_card.dart';
import 'diagnostic_tile.dart';

class BatteryCard extends ConsumerWidget {
  const BatteryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final batteryService = ref.watch(batteryServiceProvider);

    return FutureBuilder<bool>(
      future: batteryService.isCharging(),
      builder: (context, chargingSnapshot) {
        if (!chargingSnapshot.hasData) {
          return const DiagnosticCard(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        return StreamBuilder<int>(
          stream: batteryService.getBatteryLevelStream(),
          builder: (context, batterySnapshot) {
            if (!batterySnapshot.hasData) {
              return const DiagnosticCard(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                ),
              );
            }

            final level = batterySnapshot.data!;
            final charging = chargingSnapshot.data!;

            return DiagnosticCard(
              child: Column(
                children: [
                  DiagnosticTile(
                    label: 'Battery Level',
                    value: '$level%',
                    valueColor: level > 20 ? Colors.green : Colors.red,
                  ),
                  DiagnosticTile(
                    label: 'Charging',
                    value: charging ? 'Yes' : 'No',
                    valueColor: charging ? Colors.green : Colors.orange,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
