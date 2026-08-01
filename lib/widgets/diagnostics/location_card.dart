import 'package:flutter/material.dart';

import 'diagnostic_card.dart';

class LocationCard extends StatelessWidget {
  const LocationCard({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return DiagnosticCard(child: child ?? const Text('Location details'));
  }
}
