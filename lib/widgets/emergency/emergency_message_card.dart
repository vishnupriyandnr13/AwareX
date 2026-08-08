import 'package:flutter/material.dart';

import 'package:awarex/models/emergency/emergency_message.dart';

class EmergencyMessageCard extends StatelessWidget {
  const EmergencyMessageCard({super.key, required this.message});

  final EmergencyMessage message;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: colorScheme.errorContainer,
                  foregroundColor: colorScheme.onErrorContainer,
                  child: const Icon(Icons.sms_outlined),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Emergency Message',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _InfoRow(label: 'Recipient', value: message.recipientName),
            _InfoRow(label: 'Phone', value: message.recipientPhone),
            _InfoRow(
              label: 'Threat',
              value: _formatEnum(message.threatLevel.name),
            ),
            _InfoRow(
              label: 'Safety State',
              value: _formatEnum(message.safetyState.name),
            ),
            const SizedBox(height: 14),
            const Divider(),
            const SizedBox(height: 10),
            Text(
              'Message Preview',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: SelectableText(
                message.message,
                style: const TextStyle(height: 1.45),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  message.hasLocation ? Icons.location_on : Icons.location_off,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    message.hasLocation
                        ? 'GPS location included'
                        : 'GPS location unavailable',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatEnum(String value) {
    final String formatted = value.replaceAll('_', ' ');

    if (formatted.isEmpty) {
      return formatted;
    }

    return formatted[0].toUpperCase() + formatted.substring(1);
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
