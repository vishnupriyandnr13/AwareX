import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:awarex/services/sensor/connectivity_service.dart';
import 'package:awarex/services/sensor/connectivity_service_impl.dart';

final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  final service = ConnectivityServiceImpl();

  ref.onDispose(service.dispose);

  return service;
});
