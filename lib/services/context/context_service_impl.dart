import 'dart:async';

import 'package:awarex/core/enums/movement_state.dart';
import 'package:awarex/core/enums/time_context.dart';

import 'package:awarex/models/context/context_data.dart';
import 'package:awarex/models/sensor/connectivity_data.dart';
import 'package:awarex/models/sensor/device_data.dart';
import 'package:awarex/models/sensor/location_data.dart';
import 'package:awarex/models/sensor/motion_data.dart';

import 'package:awarex/services/context/context_service.dart';
import 'package:awarex/services/sensor/connectivity_service.dart';
import 'package:awarex/services/sensor/device_service.dart';
import 'package:awarex/services/sensor/location_service.dart';
import 'package:awarex/services/sensor/motion_service.dart';

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

  final StreamController<ContextData> _controller =
      StreamController<ContextData>.broadcast();

  StreamSubscription<LocationData>? _locationSubscription;
  StreamSubscription<MotionData>? _motionSubscription;
  StreamSubscription<DeviceData>? _deviceSubscription;
  StreamSubscription<ConnectivityData>? _connectivitySubscription;

  LocationData? _location;
  MotionData? _motion;
  DeviceData? _device;
  ConnectivityData? _connectivity;

  ContextData? _lastContext;

  bool _started = false;
  bool _disposed = false;

  @override
  Future<ContextData> getCurrentContext() async {
    await _loadCurrentValues();

    return _buildContext();
  }

  @override
  Stream<ContextData> getContextStream() {
    if (!_started) {
      _started = true;

      _listenLocation();
      _listenMotion();
      _listenDevice();
      _listenConnectivity();

      _loadCurrentValues();
    }

    return _controller.stream;
  }

  Future<void> _loadCurrentValues() async {
    // Location (optional)
    try {
      _location = await _locationService.getCurrentLocation();
    } catch (_) {
      _location = null;
    }

    // Motion (always available)
    _motion = _motionService.currentMotion;

    // Device
    try {
      _device = await _deviceService.getCurrentDeviceData();
    } catch (_) {}

    // Connectivity
    try {
      _connectivity = await _connectivityService.getCurrentConnectivity();
    } catch (_) {}

    _emitContext();
  }

  void _listenLocation() {
    _locationSubscription = _locationService.getLocationStream().listen(
      (location) {
        _location = location;
        _emitContext();
      },
      onError: (_) {
        _location = null;
        _emitContext();
      },
    );
  }

  void _listenMotion() {
    _motionSubscription = _motionService.motionStream.listen((motion) {
      _motion = motion;
      _emitContext();
    });
  }

  void _listenDevice() {
    _deviceSubscription = _deviceService.getDeviceDataStream().listen((device) {
      _device = device;
      _emitContext();
    });
  }

  void _listenConnectivity() {
    _connectivitySubscription = _connectivityService
        .getConnectivityStream()
        .listen((connectivity) {
          _connectivity = connectivity;
          _emitContext();
        });
  }

  void _emitContext() {
    if (_disposed) {
      return;
    }

    // Motion, device and connectivity are required.
    if (_motion == null || _device == null || _connectivity == null) {
      return;
    }

    final context = _buildContext();

    // Avoid rebuilding UI with identical values.
    if (_lastContext?.toString() == context.toString()) {
      return;
    }

    _lastContext = context;

    if (!_controller.isClosed) {
      _controller.add(context);
    }
  }

  ContextData _buildContext() {
    final motion = _motion!;
    final device = _device!;
    final connectivity = _connectivity!;

    return ContextData(
      movement: _movementState(motion),
      gpsReliable: _location?.isAccurate ?? false,
      batteryLow: device.isBatteryLow,
      charging: device.isCharging,
      offline: connectivity.isOffline,
      screenOn: device.isScreenOn,
      timeContext: _timeContext(),
    );
  }

  MovementState _movementState(MotionData motion) {
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
  void dispose() {
    if (_disposed) {
      return;
    }

    _disposed = true;

    _locationSubscription?.cancel();
    _motionSubscription?.cancel();
    _deviceSubscription?.cancel();
    _connectivitySubscription?.cancel();

    _controller.close();
  }
}
