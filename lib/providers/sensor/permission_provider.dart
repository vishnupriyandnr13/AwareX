import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:awarex/services/sensor/permission_service.dart';
import 'package:awarex/services/sensor/permission_service_impl.dart';

final permissionServiceProvider = Provider<PermissionService>((ref) {
  return const PermissionServiceImpl();
});
