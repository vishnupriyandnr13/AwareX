import 'package:awarex/models/contact/trusted_contact.dart';

abstract interface class ContactService {
  Future<List<TrustedContact>> getContacts();

  Future<TrustedContact> addContact({
    required String name,
    required String phoneNumber,
    required String relationship,
    bool isPrimary,
    String? sourceContactId,
  });
  Future<TrustedContact?> pickPhoneContact();

  Future<void> updateContact(TrustedContact contact);

  Future<void> deleteContact(String id);

  Future<void> setPrimaryContact(String id);

  Stream<List<TrustedContact>> getContactsStream();

  void dispose();
}
