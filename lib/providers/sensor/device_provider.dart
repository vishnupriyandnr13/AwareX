import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:awarex/providers/sensor/battery_provider.dart';
import 'package:awarex/services/sensor/device_service.dart';
import 'package:awarex/services/sensor/device_service_impl.dart';

final deviceServiceProvider = Provider<DeviceService>((ref) {
  final service = DeviceServiceImpl(
    batteryService: ref.read(batteryServiceProvider),
  );

  ref.onDispose(service.dispose);

  return service;
});
