import 'package:flutter/material.dart';

import 'diagnostic_card.dart';

class DeviceCard extends StatelessWidget {
  const DeviceCard({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return DiagnosticCard(child: child ?? const Text('Device details'));
  }
}
