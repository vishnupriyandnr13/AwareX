import 'package:flutter/material.dart';

import 'diagnostic_card.dart';

class PermissionCard extends StatelessWidget {
  const PermissionCard({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return DiagnosticCard(child: child ?? const Text('Permission details'));
  }
}
