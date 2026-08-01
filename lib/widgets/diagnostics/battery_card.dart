import 'package:flutter/material.dart';

import 'diagnostic_card.dart';

class BatteryCard extends StatelessWidget {
  const BatteryCard({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return DiagnosticCard(child: child ?? const Text('Battery details'));
  }
}
