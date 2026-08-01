import 'package:flutter/material.dart';

import 'diagnostic_card.dart';

class ApplicationCard extends StatelessWidget {
  const ApplicationCard({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return DiagnosticCard(child: child ?? const Text('Application details'));
  }
}
