import 'package:awarex/models/sensor/location_data.dart';
import 'package:awarex/services/sensor/location_service.dart';
import 'package:awarex/services/sensor/permission_service.dart';
import 'package:geolocator/geolocator.dart';

/// Default implementation of [LocationService]
/// using the geolocator package.
class LocationServiceImpl implements LocationService {
  LocationServiceImpl({required PermissionService permissionService})
    : _permissionService = permissionService;

  final PermissionService _permissionService;

  static const LocationSettings _locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 10,
  );

  @override
  Future<bool> isLocationServiceEnabled() {
    return Geolocator.isLocationServiceEnabled();
  }

  @override
  Future<LocationData> getCurrentLocation() async {
    if (!await isLocationServiceEnabled()) {
      throw Exception('Location service is disabled.');
    }

    if (!await _permissionService.ensureLocationPermission()) {
      throw Exception('Location permission denied.');
    }

    final position = await Geolocator.getCurrentPosition(
      locationSettings: _locationSettings,
    );

    return _toLocationData(position);
  }

  @override
  Stream<LocationData> getLocationStream() async* {
    if (!await isLocationServiceEnabled()) {
      throw Exception('Location service is disabled.');
    }

    if (!await _permissionService.ensureLocationPermission()) {
      throw Exception('Location permission denied.');
    }

    yield* Geolocator.getPositionStream(
      locationSettings: _locationSettings,
    ).map(_toLocationData);
  }

  /// Converts a Geolocator [Position] into the application's
  /// immutable [LocationData] model.
  LocationData _toLocationData(Position position) {
    return LocationData(
      latitude: position.latitude,
      longitude: position.longitude,
      altitude: position.altitude,
      speed: position.speed,
      heading: position.heading,
      accuracy: position.accuracy,
    );
  }
}
