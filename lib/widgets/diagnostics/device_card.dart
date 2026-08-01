import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:awarex/providers/sensor/device_provider.dart';
import 'package:awarex/widgets/diagnostics/diagnostic_card.dart';
import 'package:awarex/widgets/diagnostics/diagnostic_tile.dart';

class DeviceCard extends ConsumerWidget {
  const DeviceCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deviceService = ref.watch(deviceServiceProvider);

    return DiagnosticCard(
      child: StreamBuilder(
        stream: deviceService.getDeviceDataStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const DiagnosticTile(
              label: 'Device',
              value: 'Error',
              valueColor: Colors.red,
            );
          }

          if (!snapshot.hasData) {
            return const Padding(
              padding: EdgeInsets.all(20),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final deviceData = snapshot.data!;

          return Column(
            children: [
              DiagnosticTile(
                label: 'Battery',
                value: '${deviceData.batteryLevel}%',
                valueColor: deviceData.isBatteryLow ? Colors.red : Colors.green,
              ),
              DiagnosticTile(
                label: 'Charging',
                value: deviceData.isCharging ? 'Yes' : 'No',
                valueColor: deviceData.isCharging ? Colors.green : Colors.grey,
              ),
              DiagnosticTile(
                label: 'App Active',
                value: deviceData.isScreenOn ? 'Yes' : 'No',
                valueColor: deviceData.isScreenOn ? Colors.green : Colors.red,
              ),
            ],
          );
        },
      ),
    );
  }
}
