import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:awarex/services/sensor/environment_service.dart';
import 'package:awarex/services/sensor/environment_service_impl.dart';

final environmentServiceProvider = Provider<EnvironmentService>((ref) {
  final service = EnvironmentServiceImpl();

  ref.onDispose(service.dispose);

  return service;
});
