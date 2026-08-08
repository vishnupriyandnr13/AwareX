import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:awarex/models/emergency/emergency_message.dart';

import 'package:awarex/providers/contact/contact_provider.dart';
import 'package:awarex/providers/emergency/emergency_provider.dart';
import 'package:awarex/providers/sensor/location_provider.dart';

import 'package:awarex/services/emergency/emergency_message_service.dart';
import 'package:awarex/services/emergency/emergency_message_service_impl.dart';

final emergencyMessageServiceProvider = Provider<EmergencyMessageService>((
  ref,
) {
  final emergencyService = ref.watch(emergencyServiceProvider);

  final locationService = ref.watch(locationServiceProvider);

  final contactService = ref.watch(contactServiceProvider);

  final service = EmergencyMessageServiceImpl(
    emergencyService: emergencyService,
    locationService: locationService,
    contactService: contactService,
  );

  ref.onDispose(service.dispose);

  return service;
});

final emergencyMessageProvider = FutureProvider.autoDispose<EmergencyMessage?>((
  ref,
) async {
  final service = ref.watch(emergencyMessageServiceProvider);

  return service.generateEmergencyMessage();
});

final emergencyMessageStreamProvider =
    StreamProvider.autoDispose<EmergencyMessage>((ref) {
      final service = ref.watch(emergencyMessageServiceProvider);

      return service.getMessageStream();
    });
