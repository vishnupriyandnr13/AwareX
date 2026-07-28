// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sensor_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SensorData _$SensorDataFromJson(Map<String, dynamic> json) => SensorData(
  location: LocationData.fromJson(json['location'] as Map<String, dynamic>),
  motion: MotionData.fromJson(json['motion'] as Map<String, dynamic>),
  device: DeviceData.fromJson(json['device'] as Map<String, dynamic>),
  environment: EnvironmentData.fromJson(
    json['environment'] as Map<String, dynamic>,
  ),
  connectivity: ConnectivityData.fromJson(
    json['connectivity'] as Map<String, dynamic>,
  ),
  timestamp: DateTime.parse(json['timestamp'] as String),
);

Map<String, dynamic> _$SensorDataToJson(SensorData instance) =>
    <String, dynamic>{
      'location': instance.location.toJson(),
      'motion': instance.motion.toJson(),
      'device': instance.device.toJson(),
      'environment': instance.environment.toJson(),
      'connectivity': instance.connectivity.toJson(),
      'timestamp': instance.timestamp.toIso8601String(),
    };
