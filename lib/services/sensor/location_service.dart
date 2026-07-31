import 'package:flutter/foundation.dart';

import 'package:awarex/models/sensor/location_data.dart';

/// Contract for retrieving device location information.
///
/// This service owns GPS interaction only.
/// Runtime permission handling must be delegated to [PermissionService].
@immutable
abstract interface class LocationService {
  /// Returns true when the device location service is enabled.
  Future<bool> isLocationServiceEnabled();

  /// Returns the current device location.
  Future<LocationData> getCurrentLocation();

  /// Returns a continuous stream of location updates.
  Stream<LocationData> getLocationStream();
}
