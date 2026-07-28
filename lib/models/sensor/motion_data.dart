import 'package:json_annotation/json_annotation.dart';
import 'dart:math' as math;

part 'motion_data.g.dart';

@JsonSerializable()
class MotionData {
  final double accelerometerX;
  final double accelerometerY;
  final double accelerometerZ;

  final double gyroscopeX;
  final double gyroscopeY;
  final double gyroscopeZ;

  const MotionData({
    required this.accelerometerX,
    required this.accelerometerY,
    required this.accelerometerZ,
    required this.gyroscopeX,
    required this.gyroscopeY,
    required this.gyroscopeZ,
  });

  double get accelerationMagnitude => math.sqrt(
    accelerometerX * accelerometerX +
        accelerometerY * accelerometerY +
        accelerometerZ * accelerometerZ,
  );

  MotionData copyWith({
    double? accelerometerX,
    double? accelerometerY,
    double? accelerometerZ,
    double? gyroscopeX,
    double? gyroscopeY,
    double? gyroscopeZ,
  }) {
    return MotionData(
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
  String toString() => 'MotionData(accelX: $accelerometerX)';
}
