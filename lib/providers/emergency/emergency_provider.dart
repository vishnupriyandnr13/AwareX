import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:awarex/models/emergency/emergency_state.dart';

import 'package:awarex/providers/safety/safety_provider.dart';

import 'package:awarex/services/emergency/emergency_service.dart';
import 'package:awarex/services/emergency/emergency_service_impl.dart';

final emergencyServiceProvider = Provider<EmergencyService>((ref) {
  final service = EmergencyServiceImpl(
    safetyService: ref.read(safetyStateServiceProvider),
  );

  ref.onDispose(service.dispose);

  return service;
});

final emergencyProvider = StreamProvider.autoDispose<EmergencyState>((ref) {
  final service = ref.watch(emergencyServiceProvider);

  return service.getEmergencyStream();
});
