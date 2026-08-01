import 'package:flutter/material.dart';

class DiagnosticCard extends StatelessWidget {
  final Widget child;

  const DiagnosticCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(padding: const EdgeInsets.all(16), child: child),
    );
  }
}
