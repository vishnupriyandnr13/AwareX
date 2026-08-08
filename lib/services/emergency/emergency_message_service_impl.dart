import 'dart:async';

import 'package:awarex/models/contact/trusted_contact.dart';
import 'package:awarex/models/emergency/emergency_message.dart';
import 'package:awarex/models/emergency/emergency_state.dart';
import 'package:awarex/models/sensor/location_data.dart';

import 'package:awarex/services/contact/contact_service.dart';
import 'package:awarex/services/emergency/emergency_message_service.dart';
import 'package:awarex/services/emergency/emergency_service.dart';
import 'package:awarex/services/sensor/location_service.dart';

class EmergencyMessageServiceImpl implements EmergencyMessageService {
  EmergencyMessageServiceImpl({
    required EmergencyService emergencyService,
    required LocationService locationService,
    required ContactService contactService,
  }) : _emergencyService = emergencyService,
       _locationService = locationService,
       _contactService = contactService;

  final EmergencyService _emergencyService;
  final LocationService _locationService;
  final ContactService _contactService;

  final StreamController<EmergencyMessage> _controller =
      StreamController<EmergencyMessage>.broadcast();

  EmergencyMessage? _latestMessage;
  bool _disposed = false;

  @override
  Future<EmergencyMessage?> generateEmergencyMessage() async {
    final EmergencyState emergency = await _emergencyService
        .getCurrentEmergency();

    final TrustedContact? contact = await _getPrimaryContact();

    if (contact == null) {
      return null;
    }

    LocationData? location;

    try {
      location = await _locationService.getCurrentLocation();
    } catch (_) {
      location = null;
    }

    final timestamp = DateTime.now();

    final double? latitude = location?.latitude;
    final double? longitude = location?.longitude;

    final String? mapsUrl = latitude != null && longitude != null
        ? 'https://maps.google.com/?q=$latitude,$longitude'
        : null;

    final String message = _buildMessage(
      emergency: emergency,
      timestamp: timestamp,
      mapsUrl: mapsUrl,
    );

    final EmergencyMessage result = EmergencyMessage(
      recipientName: contact.name,
      recipientPhone: contact.phoneNumber,
      message: message,
      threatLevel: emergency.threatLevel,
      safetyState: emergency.safetyState,
      action: emergency.action,
      timestamp: timestamp,
      latitude: latitude,
      longitude: longitude,
      mapsUrl: mapsUrl,
    );

    _latestMessage = result;

    if (!_disposed && !_controller.isClosed) {
      _controller.add(result);
    }

    return result;
  }

  Future<TrustedContact?> _getPrimaryContact() async {
    final List<TrustedContact> contacts = await _contactService.getContacts();

    if (contacts.isEmpty) {
      return null;
    }

    for (final TrustedContact contact in contacts) {
      if (contact.isPrimary) {
        return contact;
      }
    }

    return contacts.first;
  }

  String _buildMessage({
    required EmergencyState emergency,
    required DateTime timestamp,
    required String? mapsUrl,
  }) {
    final StringBuffer buffer = StringBuffer();

    buffer.writeln('AWAREX EMERGENCY ALERT');
    buffer.writeln();
    buffer.writeln('I may need help.');
    buffer.writeln();

    buffer.writeln(
      'Threat Level: '
      '${_formatEnum(emergency.threatLevel.name)}',
    );

    buffer.writeln(
      'Safety State: '
      '${_formatEnum(emergency.safetyState.name)}',
    );

    buffer.writeln(
      'Emergency Action: '
      '${_formatEnum(emergency.action.name)}',
    );

    buffer.writeln('Time: ${_formatDateTime(timestamp)}');

    buffer.writeln();

    if (mapsUrl != null) {
      buffer.writeln('My current location:');
      buffer.writeln(mapsUrl);
    } else {
      buffer.writeln('My current location is unavailable.');
    }

    buffer.writeln();
    buffer.writeln('Please contact me or check on my safety.');

    return buffer.toString().trim();
  }

  String _formatEnum(String value) {
    final String formatted = value.replaceAll('_', ' ');

    if (formatted.isEmpty) {
      return formatted;
    }

    return formatted[0].toUpperCase() + formatted.substring(1);
  }

  String _formatDateTime(DateTime dateTime) {
    final DateTime local = dateTime.toLocal();

    final String day = local.day.toString().padLeft(2, '0');

    final String month = local.month.toString().padLeft(2, '0');

    final String year = local.year.toString();

    final String hour = local.hour.toString().padLeft(2, '0');

    final String minute = local.minute.toString().padLeft(2, '0');

    return '$day/$month/$year $hour:$minute';
  }

  @override
  EmergencyMessage? getLatestMessage() {
    return _latestMessage;
  }

  @override
  Stream<EmergencyMessage> getMessageStream() {
    return _controller.stream;
  }

  @override
  void clear() {
    _latestMessage = null;
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
