import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:awarex/services/sensor/motion_service.dart';
import 'package:awarex/services/sensor/motion_service_impl.dart';

final motionServiceProvider = Provider<MotionService>((ref) {
  final service = MotionServiceImpl();

  ref.onDispose(service.dispose);

  return service;
});
