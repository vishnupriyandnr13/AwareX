import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:awarex/models/safety/safety_state_data.dart';

import 'package:awarex/providers/threat/threat_provider.dart';

import 'package:awarex/services/safety/safety_state_service.dart';
import 'package:awarex/services/safety/safety_state_service_impl.dart';

final safetyStateServiceProvider = Provider<SafetyStateService>((ref) {
  final service = SafetyStateServiceImpl(
    threatService: ref.read(threatServiceProvider),
  );

  ref.onDispose(service.dispose);

  return service;
});

final safetyStateProvider = StreamProvider.autoDispose<SafetyStateData>((ref) {
  final safetyService = ref.watch(safetyStateServiceProvider);

  return safetyService.getSafetyStateStream();
});
