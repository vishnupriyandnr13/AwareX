import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:awarex/models/contact/trusted_contact.dart';
import 'package:awarex/providers/contact/contact_provider.dart';
import 'package:awarex/widgets/contact/contact_form.dart';
import 'package:awarex/widgets/contact/trusted_contact_card.dart';

class TrustedContactsScreen extends ConsumerWidget {
  const TrustedContactsScreen({super.key});

  Future<void> _selectPhoneContact(BuildContext context, WidgetRef ref) async {
    final service = ref.read(contactServiceProvider);

    try {
      final picked = await service.pickPhoneContact();

      if (picked == null) {
        return;
      }

      if (!context.mounted) {
        return;
      }

      await _showImportedContactForm(context, ref, picked);
    } catch (error) {
      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to select contact: $error')),
      );
    }
  }

  Future<void> _showImportedContactForm(
    BuildContext context,
    WidgetRef ref,
    TrustedContact contact,
  ) async {
    final service = ref.read(contactServiceProvider);

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) {
        return ContactForm(
          contact: contact,
          onSave:
              ({
                required name,
                required phoneNumber,
                required relationship,
                required isPrimary,
              }) async {
                await service.addContact(
                  name: name,
                  phoneNumber: phoneNumber,
                  relationship: relationship,
                  isPrimary: isPrimary,
                  sourceContactId: contact.sourceContactId,
                );
              },
        );
      },
    );
  }

  Future<void> _showManualForm(BuildContext context, WidgetRef ref) async {
    final service = ref.read(contactServiceProvider);

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) {
        return ContactForm(
          onSave:
              ({
                required name,
                required phoneNumber,
                required relationship,
                required isPrimary,
              }) async {
                await service.addContact(
                  name: name,
                  phoneNumber: phoneNumber,
                  relationship: relationship,
                  isPrimary: isPrimary,
                );
              },
        );
      },
    );
  }

  Future<void> _editContact(
    BuildContext context,
    WidgetRef ref,
    TrustedContact contact,
  ) async {
    final service = ref.read(contactServiceProvider);

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) {
        return ContactForm(
          contact: contact,
          onSave:
              ({
                required name,
                required phoneNumber,
                required relationship,
                required isPrimary,
              }) async {
                await service.updateContact(
                  contact.copyWith(
                    name: name,
                    phoneNumber: phoneNumber,
                    relationship: relationship,
                    isPrimary: isPrimary,
                  ),
                );
              },
        );
      },
    );
  }

  Future<void> _deleteContact(
    BuildContext context,
    WidgetRef ref,
    TrustedContact contact,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Remove trusted contact?'),
          content: Text(
            '${contact.name} will no longer be used '
            'as an AwareX trusted contact.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    await ref.read(contactServiceProvider).deleteContact(contact.id);

    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('${contact.name} removed.')));
  }

  Future<void> _setPrimary(
    BuildContext context,
    WidgetRef ref,
    TrustedContact contact,
  ) async {
    await ref.read(contactServiceProvider).setPrimaryContact(contact.id);

    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${contact.name} is now the primary contact.')),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contactsAsync = ref.watch(trustedContactsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Trusted Contacts')),
      body: contactsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Unable to load trusted contacts.\n\n$error',
              textAlign: TextAlign.center,
            ),
          ),
        ),
        data: (contacts) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.shield_outlined,
                        size: 34,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Your safety network',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'AwareX can prioritize these people '
                              'when an emergency response is needed.',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),
              _AddContactButton(
                icon: Icons.contacts_outlined,
                title: 'Select from Phone Contacts',
                subtitle: 'Choose someone already saved on your phone',
                onTap: () => _selectPhoneContact(context, ref),
              ),
              const SizedBox(height: 10),
              _AddContactButton(
                icon: Icons.person_add_alt_1_outlined,
                title: 'Add Manually',
                subtitle: 'Enter a name and phone number yourself',
                onTap: () => _showManualForm(context, ref),
              ),
              const SizedBox(height: 24),
              if (contacts.isNotEmpty) ...[
                Text(
                  'Saved Trusted Contacts',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ...contacts.map(
                  (contact) => TrustedContactCard(
                    contact: contact,
                    onEdit: () => _editContact(context, ref, contact),
                    onDelete: () => _deleteContact(context, ref, contact),
                    onSetPrimary: () => _setPrimary(context, ref, contact),
                  ),
                ),
              ] else ...[
                const SizedBox(height: 24),
                const _EmptyState(),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _AddContactButton extends StatelessWidget {
  const _AddContactButton({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(radius: 25, child: Icon(icon)),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(subtitle),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          Icons.people_outline,
          size: 60,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const SizedBox(height: 12),
        const Text(
          'No trusted contacts yet',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 6),
        const Text(
          'Add someone AwareX can contact during '
          'an emergency.',
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
