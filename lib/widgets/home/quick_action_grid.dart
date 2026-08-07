import 'package:flutter/material.dart';

class QuickActionGrid extends StatelessWidget {
  const QuickActionGrid({
    super.key,
    required this.onDiagnostics,
    required this.onFakeCall,
    required this.onNotifyContact,
    required this.onSaferRoute,
  });

  final VoidCallback onDiagnostics;
  final VoidCallback onFakeCall;
  final VoidCallback onNotifyContact;
  final VoidCallback onSaferRoute;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),

        const SizedBox(height: 16),

        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 1.6,
          children: [
            _ActionButton(
              icon: Icons.developer_mode,
              title: 'Diagnostics',
              color: Colors.blue,
              onTap: onDiagnostics,
            ),
            _ActionButton(
              icon: Icons.call,
              title: 'Fake Call',
              color: Colors.orange,
              onTap: onFakeCall,
            ),
            _ActionButton(
              icon: Icons.contacts,
              title: 'Notify Contact',
              color: Colors.red,
              onTap: onNotifyContact,
            ),
            _ActionButton(
              icon: Icons.route,
              title: 'Safer Route',
              color: Colors.green,
              onTap: onSaferRoute,
            ),
          ],
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 30, color: color),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
