import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:awarex/services/sensor/battery_service.dart';
import 'package:awarex/services/sensor/battery_service_impl.dart';

final batteryServiceProvider = Provider<BatteryService>((ref) {
  final service = BatteryServiceImpl();

  ref.onDispose(service.dispose);

  return service;
});
