import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:awarex/models/sensor/connectivity_data.dart';
import 'package:awarex/providers/sensor/connectivity_provider.dart';

import 'diagnostic_card.dart';
import 'diagnostic_tile.dart';

class ConnectivityCard extends ConsumerWidget {
  const ConnectivityCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final service = ref.watch(connectivityServiceProvider);

    return FutureBuilder<ConnectivityData>(
      future: service.getCurrentConnectivity(),
      builder: (context, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          return const DiagnosticCard(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        if (futureSnapshot.hasError) {
          return DiagnosticCard(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                futureSnapshot.error.toString(),
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        }

        return StreamBuilder<ConnectivityData>(
          stream: service.getConnectivityStream(),
          initialData: futureSnapshot.data,
          builder: (context, snapshot) {
            final data = snapshot.data;

            if (data == null) {
              return const DiagnosticCard(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('No connectivity information'),
                ),
              );
            }

            return DiagnosticCard(
              child: DiagnosticTile(
                label: 'Connection',
                value: data.connectionType.name.toUpperCase(),
              ),
            );
          },
        );
      },
    );
  }
}
