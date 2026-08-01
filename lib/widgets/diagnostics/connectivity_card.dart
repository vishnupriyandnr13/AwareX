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

    return StreamBuilder<ConnectivityData>(
      stream: service.getConnectivityStream(),
      future: service.getCurrentConnectivity(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const DiagnosticCard(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        final data = snapshot.data!;

        return DiagnosticCard(
          child: DiagnosticTile(
            label: 'Connection',
            value: data.connectionType.name.toUpperCase(),
          ),
        );
      },
    );
  }
}
