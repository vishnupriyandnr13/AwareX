import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:awarex/models/contact/trusted_contact.dart';
import 'package:awarex/services/contact/contact_service.dart';
import 'package:awarex/services/contact/contact_service_impl.dart';

final contactServiceProvider = Provider<ContactService>((ref) {
  final service = ContactServiceImpl();

  ref.onDispose(service.dispose);

  return service;
});

final trustedContactsProvider =
    StreamProvider.autoDispose<List<TrustedContact>>((ref) {
      final service = ref.watch(contactServiceProvider);

      return service.getContactsStream();
    });

final primaryTrustedContactProvider = Provider.autoDispose<TrustedContact?>((
  ref,
) {
  final contactsAsync = ref.watch(trustedContactsProvider);

  return contactsAsync.maybeWhen(
    data: (contacts) {
      for (final contact in contacts) {
        if (contact.isPrimary) {
          return contact;
        }
      }

      return contacts.isNotEmpty ? contacts.first : null;
    },
    orElse: () => null,
  );
});
