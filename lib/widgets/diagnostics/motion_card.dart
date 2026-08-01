import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:awarex/models/sensor/motion_data.dart';
import 'package:awarex/providers/sensor/motion_provider.dart';

import 'diagnostic_card.dart';
import 'diagnostic_tile.dart';

class MotionCard extends ConsumerWidget {
  const MotionCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final motionService = ref.watch(motionServiceProvider);

    return StreamBuilder<MotionData>(
      stream: motionService.motionStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return DiagnosticCard(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                snapshot.error.toString(),
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        }

        if (!snapshot.hasData) {
          return const DiagnosticCard(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        final motion = snapshot.requireData;

        return DiagnosticCard(
          child: Column(
            children: [
              DiagnosticTile(
                label: 'Moving',
                value: motion.isMoving ? 'Yes' : 'No',
                valueColor: motion.isMoving ? Colors.orange : Colors.green,
              ),

              DiagnosticTile(
                label: 'High Motion',
                value: motion.isHighMotion ? 'Yes' : 'No',
                valueColor: motion.isHighMotion ? Colors.red : Colors.green,
              ),

              DiagnosticTile(
                label: 'Acceleration',
                value: motion.accelerationMagnitude.toStringAsFixed(2),
              ),

              DiagnosticTile(
                label: 'Rotation',
                value: motion.rotationMagnitude.toStringAsFixed(2),
              ),

              DiagnosticTile(
                label: 'Accel X',
                value: motion.accelerometerX.toStringAsFixed(2),
              ),

              DiagnosticTile(
                label: 'Accel Y',
                value: motion.accelerometerY.toStringAsFixed(2),
              ),

              DiagnosticTile(
                label: 'Accel Z',
                value: motion.accelerometerZ.toStringAsFixed(2),
              ),

              DiagnosticTile(
                label: 'Gyro X',
                value: motion.gyroscopeX.toStringAsFixed(2),
              ),

              DiagnosticTile(
                label: 'Gyro Y',
                value: motion.gyroscopeY.toStringAsFixed(2),
              ),

              DiagnosticTile(
                label: 'Gyro Z',
                value: motion.gyroscopeZ.toStringAsFixed(2),
              ),
            ],
          ),
        );
      },
    );
  }
}
