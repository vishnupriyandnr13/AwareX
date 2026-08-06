import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:awarex/models/context/context_data.dart';

import 'package:awarex/providers/sensor/connectivity_provider.dart';
import 'package:awarex/providers/sensor/device_provider.dart';
import 'package:awarex/providers/sensor/location_provider.dart';
import 'package:awarex/providers/sensor/motion_provider.dart';

import 'package:awarex/services/context/context_service.dart';
import 'package:awarex/services/context/context_service_impl.dart';

final contextServiceProvider = Provider<ContextService>((ref) {
  final service = ContextServiceImpl(
    locationService: ref.read(locationServiceProvider),
    motionService: ref.read(motionServiceProvider),
    deviceService: ref.read(deviceServiceProvider),
    connectivityService: ref.read(connectivityServiceProvider),
  );

  ref.onDispose(service.dispose);

  return service;
});

final contextProvider = StreamProvider.autoDispose<ContextData>((ref) {
  final contextService = ref.watch(contextServiceProvider);

  return contextService.getContextStream();
});
