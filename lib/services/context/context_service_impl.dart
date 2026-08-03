import 'package:awarex/core/enums/movement_state.dart';
import 'package:awarex/core/enums/time_context.dart';

import 'package:awarex/models/context/context_data.dart';

import 'package:awarex/services/context/context_service.dart';
import 'package:awarex/services/sensor/connectivity_service.dart';
import 'package:awarex/services/sensor/device_service.dart';
import 'package:awarex/services/sensor/location_service.dart';
import 'package:awarex/services/sensor/motion_service.dart';
import 'package:awarex/models/sensor/motion_data.dart';

class ContextServiceImpl implements ContextService {
  ContextServiceImpl({
    required LocationService locationService,
    required MotionService motionService,
    required DeviceService deviceService,
    required ConnectivityService connectivityService,
  }) : _locationService = locationService,
       _motionService = motionService,
       _deviceService = deviceService,
       _connectivityService = connectivityService;

  final LocationService _locationService;
  final MotionService _motionService;
  final DeviceService _deviceService;
  final ConnectivityService _connectivityService;

  @override
  Future<ContextData> getCurrentContext() async {
    final location = await _locationService.getCurrentLocation();

    final motion = _motionService.currentMotion;

    final device = await _deviceService.getCurrentDeviceData();

    final connectivity = await _connectivityService.getCurrentConnectivity();

    return ContextData(
      movement: _movementState(motion),
      gpsReliable: location.isAccurate,
      batteryLow: device.isBatteryLow,
      charging: device.isCharging,
      offline: connectivity.isOffline,
      screenOn: device.isScreenOn,
      timeContext: _timeContext(),
    );
  }

  MovementState _movementState(dynamic motion) {
    if (motion.isHighMotion) {
      return MovementState.highMotion;
    }

    if (motion.isMoving) {
      return MovementState.moving;
    }

    return MovementState.stationary;
  }

  TimeContext _timeContext() {
    final hour = DateTime.now().hour;

    if (hour >= 6 && hour < 18) {
      return TimeContext.day;
    }

    if (hour >= 18 && hour < 21) {
      return TimeContext.evening;
    }

    return TimeContext.night;
  }

  @override
  void dispose() {}
}
