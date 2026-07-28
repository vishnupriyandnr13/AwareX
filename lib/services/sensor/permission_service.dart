import 'package:flutter/foundation.dart';

/// Contract for requesting and validating runtime permissions
/// required by the Sensor Manager.
///
/// This service is intentionally limited to permission handling
/// and must never contain sensor access logic.
@immutable
abstract interface class PermissionService {
  /// Returns true if location permission is already granted.
  Future<bool> hasLocationPermission();

  /// Requests location permission from the user.
  ///
  /// Returns true when permission is granted.
  Future<bool> requestLocationPermission();

  /// Ensures that location permission is available.
  ///
  /// If permission is already granted, no dialog is shown.
  /// Otherwise, permission is requested.
  Future<bool> ensureLocationPermission();

  /// Opens the application's settings page.
  Future<void> openSettings();
}
