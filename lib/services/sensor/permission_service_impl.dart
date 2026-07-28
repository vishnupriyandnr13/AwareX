import 'package:permission_handler/permission_handler.dart';

import 'permission_service.dart';

/// Default implementation of [PermissionService]
/// using the permission_handler package.
class PermissionServiceImpl implements PermissionService {
  const PermissionServiceImpl();

  @override
  Future<bool> hasLocationPermission() async {
    final status = await Permission.location.status;

    return status.isGranted || status.isLimited;
  }

  @override
  Future<bool> requestLocationPermission() async {
    final status = await Permission.location.request();

    return status.isGranted || status.isLimited;
  }

  @override
  Future<bool> ensureLocationPermission() async {
    try {
      if (await hasLocationPermission()) {
        return true;
      }

      return await requestLocationPermission();
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> openSettings() async {
    await openAppSettings();
  }
}