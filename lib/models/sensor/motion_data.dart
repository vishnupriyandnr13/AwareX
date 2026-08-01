import 'dart:math' as math;

import 'package:json_annotation/json_annotation.dart';

part 'motion_data.g.dart';

@JsonSerializable()
class MotionData {
  /// UTC timestamp when this motion sample was captured.
  final DateTime timestamp;

  final double accelerometerX;
  final double accelerometerY;
  final double accelerometerZ;

  final double gyroscopeX;
  final double gyroscopeY;
  final double gyroscopeZ;

  const MotionData({
    required this.timestamp,
    required this.accelerometerX,
    required this.accelerometerY,
    required this.accelerometerZ,
    required this.gyroscopeX,
    required this.gyroscopeY,
    required this.gyroscopeZ,
  });

  /// Magnitude of the acceleration vector.
  double get accelerationMagnitude => math.sqrt(
    accelerometerX * accelerometerX +
        accelerometerY * accelerometerY +
        accelerometerZ * accelerometerZ,
  );

  /// Magnitude of the rotation vector.
  double get rotationMagnitude => math.sqrt(
    gyroscopeX * gyroscopeX + gyroscopeY * gyroscopeY + gyroscopeZ * gyroscopeZ,
  );

  /// Indicates noticeable device movement.
  ///
  /// Thresholds will be calibrated using real-world data.
  bool get isMoving => accelerationMagnitude > 1.5;

  /// Indicates the device is essentially stationary.
  bool get isStationary => !isMoving;

  /// Indicates sudden or vigorous movement.
  ///
  /// Useful for:
  /// - Running
  /// - Phone shaking
  /// - Potential struggle detection
  bool get isHighMotion => accelerationMagnitude > 15.0;

  MotionData copyWith({
    DateTime? timestamp,
    double? accelerometerX,
    double? accelerometerY,
    double? accelerometerZ,
    double? gyroscopeX,
    double? gyroscopeY,
    double? gyroscopeZ,
  }) {
    return MotionData(
      timestamp: timestamp ?? this.timestamp,
      accelerometerX: accelerometerX ?? this.accelerometerX,
      accelerometerY: accelerometerY ?? this.accelerometerY,
      accelerometerZ: accelerometerZ ?? this.accelerometerZ,
      gyroscopeX: gyroscopeX ?? this.gyroscopeX,
      gyroscopeY: gyroscopeY ?? this.gyroscopeY,
      gyroscopeZ: gyroscopeZ ?? this.gyroscopeZ,
    );
  }

  factory MotionData.fromJson(Map<String, dynamic> json) =>
      _$MotionDataFromJson(json);

  Map<String, dynamic> toJson() => _$MotionDataToJson(this);

  @override
  String toString() {
    return 'MotionData('
        'timestamp: $timestamp, '
        'accel=(${accelerometerX.toStringAsFixed(2)}, '
        '${accelerometerY.toStringAsFixed(2)}, '
        '${accelerometerZ.toStringAsFixed(2)}), '
        'gyro=(${gyroscopeX.toStringAsFixed(2)}, '
        '${gyroscopeY.toStringAsFixed(2)}, '
        '${gyroscopeZ.toStringAsFixed(2)}))';
  }
}
