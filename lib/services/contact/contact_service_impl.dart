import 'dart:async';
import 'dart:convert';

import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:awarex/models/contact/trusted_contact.dart';
import 'package:awarex/services/contact/contact_service.dart';

class ContactServiceImpl implements ContactService {
  ContactServiceImpl();

  static const String _storageKey = 'awarex_trusted_contacts';

  final StreamController<List<TrustedContact>> _controller =
      StreamController<List<TrustedContact>>.broadcast();

  List<TrustedContact> _contacts = <TrustedContact>[];

  bool _initialized = false;
  bool _disposed = false;

  Future<void> _ensureInitialized() async {
    if (_initialized) {
      return;
    }

    final preferences = await SharedPreferences.getInstance();

    final raw = preferences.getString(_storageKey);

    if (raw != null && raw.isNotEmpty) {
      try {
        final decoded = jsonDecode(raw);

        if (decoded is List) {
          _contacts = decoded
              .whereType<Map>()
              .map(
                (item) =>
                    TrustedContact.fromJson(Map<String, dynamic>.from(item)),
              )
              .where(
                (contact) =>
                    contact.name.isNotEmpty && contact.phoneNumber.isNotEmpty,
              )
              .toList();
        }
      } catch (_) {
        _contacts = <TrustedContact>[];
      }
    }

    _initialized = true;
  }

  Future<void> _persist() async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.setString(
      _storageKey,
      jsonEncode(_contacts.map((contact) => contact.toJson()).toList()),
    );
  }

  void _emit() {
    if (_disposed || _controller.isClosed) {
      return;
    }

    _controller.add(List<TrustedContact>.unmodifiable(_contacts));
  }

  @override
  Future<List<TrustedContact>> getContacts() async {
    await _ensureInitialized();

    return List<TrustedContact>.unmodifiable(_contacts);
  }

  @override
  Stream<List<TrustedContact>> getContactsStream() async* {
    await _ensureInitialized();

    yield List<TrustedContact>.unmodifiable(_contacts);

    yield* _controller.stream;
  }

  @override
  Future<TrustedContact?> pickPhoneContact() async {
    final contact = await FlutterContacts.native.showPicker(
      properties: <ContactProperty>{ContactProperty.phone},
    );

    if (contact == null) {
      return null;
    }

    if (contact.phones.isEmpty) {
      return null;
    }

    final phone = _selectBestPhone(contact.phones);

    if (phone == null || phone.number.trim().isEmpty) {
      return null;
    }

    return TrustedContact(
      id: 'phone_${contact.id ?? DateTime.now().microsecondsSinceEpoch}',
      name: (contact.displayName ?? '').trim().isEmpty
          ? 'Trusted Contact'
          : contact.displayName!.trim(),
      phoneNumber: phone.number.trim(),
      relationship: 'Trusted Contact',
      isPrimary: _contacts.isEmpty,
      createdAt: DateTime.now(),
      sourceContactId: contact.id,
    );
  }

  Phone? _selectBestPhone(List<Phone> phones) {
    if (phones.isEmpty) {
      return null;
    }

    for (final phone in phones) {
      if (phone.isPrimary == true) {
        return phone;
      }
    }

    return phones.first;
  }

  @override
  Future<TrustedContact> addContact({
    required String name,
    required String phoneNumber,
    required String relationship,
    bool isPrimary = false,
    String? sourceContactId,
  }) async {
    await _ensureInitialized();

    final normalizedNumber = _normalizePhoneNumber(phoneNumber);

    final duplicateIndex = _contacts.indexWhere(
      (contact) =>
          _normalizePhoneNumber(contact.phoneNumber) == normalizedNumber,
    );

    if (duplicateIndex != -1) {
      throw StateError('This phone number is already a trusted contact.');
    }

    final shouldBePrimary = isPrimary || _contacts.isEmpty;

    if (shouldBePrimary) {
      _contacts = _contacts
          .map((contact) => contact.copyWith(isPrimary: false))
          .toList();
    }

    final contact = TrustedContact(
      id: 'awarex_${DateTime.now().microsecondsSinceEpoch}',
      name: name.trim(),
      phoneNumber: phoneNumber.trim(),
      relationship: relationship.trim(),
      isPrimary: shouldBePrimary,
      createdAt: DateTime.now(),
      sourceContactId: sourceContactId,
    );

    _contacts = <TrustedContact>[..._contacts, contact];

    await _persist();
    _emit();

    return contact;
  }

  @override
  Future<void> updateContact(TrustedContact contact) async {
    await _ensureInitialized();

    final index = _contacts.indexWhere((existing) => existing.id == contact.id);

    if (index == -1) {
      throw StateError('Trusted contact not found.');
    }

    final normalizedNumber = _normalizePhoneNumber(contact.phoneNumber);

    final duplicate = _contacts.any(
      (existing) =>
          existing.id != contact.id &&
          _normalizePhoneNumber(existing.phoneNumber) == normalizedNumber,
    );

    if (duplicate) {
      throw StateError(
        'Another trusted contact already uses this phone number.',
      );
    }

    var updated = List<TrustedContact>.from(_contacts);

    if (contact.isPrimary) {
      updated = updated
          .map((existing) => existing.copyWith(isPrimary: false))
          .toList();
    }

    updated[index] = contact;

    if (!updated.any((existing) => existing.isPrimary)) {
      updated[index] = updated[index].copyWith(isPrimary: true);
    }

    _contacts = updated;

    await _persist();
    _emit();
  }

  @override
  Future<void> deleteContact(String id) async {
    await _ensureInitialized();

    final removed = _contacts.where((contact) => contact.id == id);

    if (removed.isEmpty) {
      return;
    }

    final wasPrimary = removed.first.isPrimary;

    var updated = _contacts.where((contact) => contact.id != id).toList();

    if (wasPrimary && updated.isNotEmpty) {
      updated = [
        for (var i = 0; i < updated.length; i++)
          updated[i].copyWith(isPrimary: i == 0),
      ];
    }

    _contacts = updated;

    await _persist();
    _emit();
  }

  @override
  Future<void> setPrimaryContact(String id) async {
    await _ensureInitialized();

    if (!_contacts.any((contact) => contact.id == id)) {
      throw StateError('Trusted contact not found.');
    }

    _contacts = _contacts
        .map((contact) => contact.copyWith(isPrimary: contact.id == id))
        .toList();

    await _persist();
    _emit();
  }

  String _normalizePhoneNumber(String value) {
    return value.replaceAll(RegExp(r'[^\d+]'), '');
  }

  @override
  void dispose() {
    if (_disposed) {
      return;
    }

    _disposed = true;
    _controller.close();
  }
}
