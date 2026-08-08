import 'package:flutter/material.dart';

import 'package:awarex/models/contact/trusted_contact.dart';

class ContactForm extends StatefulWidget {
  const ContactForm({super.key, this.contact, required this.onSave});

  final TrustedContact? contact;

  final Future<void> Function({
    required String name,
    required String phoneNumber,
    required String relationship,
    required bool isPrimary,
  })
  onSave;

  @override
  State<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _relationshipController;

  late bool _isPrimary;

  bool _saving = false;

  @override
  void initState() {
    super.initState();

    final contact = widget.contact;

    _nameController = TextEditingController(text: contact?.name ?? '');

    _phoneController = TextEditingController(text: contact?.phoneNumber ?? '');

    _relationshipController = TextEditingController(
      text: contact?.relationship == 'Trusted Contact'
          ? ''
          : contact?.relationship ?? '',
    );

    _isPrimary = contact?.isPrimary ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _relationshipController.dispose();

    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate() || _saving) {
      return;
    }

    setState(() {
      _saving = true;
    });

    try {
      await widget.onSave(
        name: _nameController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        relationship: _relationshipController.text.trim(),
        isPrimary: _isPrimary,
      );

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _saving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString().replaceFirst('Bad state: ', '')),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.contact != null;

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          20,
          8,
          20,
          MediaQuery.viewInsetsOf(context).bottom + 20,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      editing ? 'Edit Trusted Contact' : 'Trusted Contact',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    onPressed: _saving ? null : () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              TextFormField(
                controller: _nameController,
                enabled: !_saving,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter a name';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _phoneController,
                enabled: !_saving,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone number',
                  prefixIcon: Icon(Icons.phone_outlined),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final number = value?.trim() ?? '';
                  final digits = number.replaceAll(RegExp(r'\D'), '');

                  if (digits.length < 10) {
                    return 'Enter a valid phone number';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _relationshipController,
                enabled: !_saving,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Relationship',
                  hintText: 'Mother, Father, Friend, etc.',
                  prefixIcon: Icon(Icons.people_outline),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter the relationship';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: _isPrimary,
                onChanged: _saving
                    ? null
                    : (value) {
                        setState(() {
                          _isPrimary = value;
                        });
                      },
                title: const Text('Primary trusted contact'),
                subtitle: const Text(
                  'This contact is prioritized during an emergency.',
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _saving ? null : _save,
                  icon: _saving
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.check),
                  label: Text(_saving ? 'Saving...' : 'Save Trusted Contact'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
