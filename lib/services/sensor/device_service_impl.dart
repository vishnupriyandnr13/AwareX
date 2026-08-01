import 'dart:async';

import 'package:flutter/widgets.dart';

import 'package:awarex/models/sensor/device_data.dart';
import 'package:awarex/services/sensor/battery_service.dart';
import 'package:awarex/services/sensor/device_service.dart';

class DeviceServiceImpl with WidgetsBindingObserver implements DeviceService {
  DeviceServiceImpl({required BatteryService batteryService})
    : _batteryService = batteryService {
    WidgetsBinding.instance.addObserver(this);
    _initialize();
  }

  final BatteryService _batteryService;

  final StreamController<DeviceData> _controller =
      StreamController<DeviceData>.broadcast();

  StreamSubscription<int>? _batterySubscription;

  bool _isScreenOn = true;
  bool _disposed = false;

  void _initialize() {
    _batterySubscription = _batteryService.getBatteryLevelStream().listen(
      (_) => _publishCurrentData(),
      onError: _controller.addError,
    );

    _publishCurrentData();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final isActive = switch (state) {
      AppLifecycleState.resumed => true,
      AppLifecycleState.inactive => false,
      AppLifecycleState.paused => false,
      AppLifecycleState.detached => false,
      AppLifecycleState.hidden => false,
    };

    if (_isScreenOn != isActive) {
      _isScreenOn = isActive;
      _publishCurrentData();
    }
  }

  Future<void> _publishCurrentData() async {
    if (_disposed || _controller.isClosed) {
      return;
    }

    try {
      final batteryLevel = await _batteryService.getBatteryLevel();
      final isCharging = await _batteryService.isCharging();

      final deviceData = DeviceData(
        batteryLevel: batteryLevel,
        isCharging: isCharging,
        isScreenOn: _isScreenOn,
      );

      _controller.add(deviceData);
    } catch (error, stackTrace) {
      if (!_controller.isClosed) {
        _controller.addError(error, stackTrace);
      }
    }
  }

  @override
  Future<DeviceData> getCurrentDeviceData() async {
    final batteryLevel = await _batteryService.getBatteryLevel();
    final isCharging = await _batteryService.isCharging();

    return DeviceData(
      batteryLevel: batteryLevel,
      isCharging: isCharging,
      isScreenOn: _isScreenOn,
    );
  }

  @override
  Stream<DeviceData> getDeviceDataStream() {
    return _controller.stream;
  }

  @override
  void dispose() {
    if (_disposed) {
      return;
    }

    _disposed = true;

    WidgetsBinding.instance.removeObserver(this);

    _batterySubscription?.cancel();
    _batterySubscription = null;

    _controller.close();
  }
}
