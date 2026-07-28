import 'package:json_annotation/json_annotation.dart';

import 'connectivity_data.dart';
import 'device_data.dart';
import 'environment_data.dart';
import 'location_data.dart';
import 'motion_data.dart';

part 'sensor_data.g.dart';

@JsonSerializable(explicitToJson: true)
class SensorData {
  final LocationData location;
  final MotionData motion;
  final DeviceData device;
  final EnvironmentData environment;
  final ConnectivityData connectivity;

  final DateTime timestamp;

  const SensorData({
    required this.location,
    required this.motion,
    required this.device,
    required this.environment,
    required this.connectivity,
    required this.timestamp,
  });

  SensorData copyWith({
    LocationData? location,
    MotionData? motion,
    DeviceData? device,
    EnvironmentData? environment,
    ConnectivityData? connectivity,
    DateTime? timestamp,
  }) {
    return SensorData(
      location: location ?? this.location,
      motion: motion ?? this.motion,
      device: device ?? this.device,
      environment: environment ?? this.environment,
      connectivity: connectivity ?? this.connectivity,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  factory SensorData.fromJson(Map<String, dynamic> json) =>
      _$SensorDataFromJson(json);

  Map<String, dynamic> toJson() => _$SensorDataToJson(this);

  @override
  String toString() {
    return '''
SensorData(
  location: $location,
  motion: $motion,
  device: $device,
  environment: $environment,
  connectivity: $connectivity,
  timestamp: $timestamp
)
''';
  }
}
