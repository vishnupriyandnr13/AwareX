import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:awarex/services/sensor/location_service.dart';
import 'package:awarex/services/sensor/location_service_impl.dart';

import 'permission_provider.dart';

final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationServiceImpl(
    permissionService: ref.read(permissionServiceProvider),
  );
});
