import 'dart:async';

import 'package:awarex/models/sensor/motion_data.dart';
import 'package:awarex/services/sensor/motion_service.dart';
import 'package:sensors_plus/sensors_plus.dart';

class MotionServiceImpl implements MotionService {
  MotionServiceImpl() {
    _startListening();
  }

  MotionData _currentMotion = MotionData(
    timestamp: DateTime.now().toUtc(),
    accelerometerX: 0,
    accelerometerY: 0,
    accelerometerZ: 0,
    gyroscopeX: 0,
    gyroscopeY: 0,
    gyroscopeZ: 0,
  );

  final StreamController<MotionData> _controller =
      StreamController<MotionData>.broadcast();

  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  StreamSubscription<GyroscopeEvent>? _gyroscopeSubscription;

  Timer? _publishTimer;

  void _startListening() {
    // Keep latest accelerometer values.
    _accelerometerSubscription = accelerometerEventStream().listen((event) {
      _currentMotion = _currentMotion.copyWith(
        timestamp: DateTime.now().toUtc(),
        accelerometerX: event.x,
        accelerometerY: event.y,
        accelerometerZ: event.z,
      );
    });

    // Keep latest gyroscope values.
    _gyroscopeSubscription = gyroscopeEventStream().listen((event) {
      _currentMotion = _currentMotion.copyWith(
        timestamp: DateTime.now().toUtc(),
        gyroscopeX: event.x,
        gyroscopeY: event.y,
        gyroscopeZ: event.z,
      );
    });

    // Publish at 5 Hz (every 200 ms).
    _publishTimer = Timer.periodic(const Duration(milliseconds: 200), (_) {
      if (!_controller.isClosed) {
        _controller.add(_currentMotion);
      }
    });
  }

  @override
  MotionData get currentMotion => _currentMotion;

  @override
  Stream<MotionData> get motionStream => _controller.stream;

  @override
  void dispose() {
    _publishTimer?.cancel();

    _accelerometerSubscription?.cancel();
    _gyroscopeSubscription?.cancel();

    _controller.close();
  }
}
