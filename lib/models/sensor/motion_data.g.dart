// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'motion_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MotionData _$MotionDataFromJson(Map<String, dynamic> json) => MotionData(
  timestamp: DateTime.parse(json['timestamp'] as String),
  accelerometerX: (json['accelerometerX'] as num).toDouble(),
  accelerometerY: (json['accelerometerY'] as num).toDouble(),
  accelerometerZ: (json['accelerometerZ'] as num).toDouble(),
  gyroscopeX: (json['gyroscopeX'] as num).toDouble(),
  gyroscopeY: (json['gyroscopeY'] as num).toDouble(),
  gyroscopeZ: (json['gyroscopeZ'] as num).toDouble(),
);

Map<String, dynamic> _$MotionDataToJson(MotionData instance) =>
    <String, dynamic>{
      'timestamp': instance.timestamp.toIso8601String(),
      'accelerometerX': instance.accelerometerX,
      'accelerometerY': instance.accelerometerY,
      'accelerometerZ': instance.accelerometerZ,
      'gyroscopeX': instance.gyroscopeX,
      'gyroscopeY': instance.gyroscopeY,
      'gyroscopeZ': instance.gyroscopeZ,
    };
