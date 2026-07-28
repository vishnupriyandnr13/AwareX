// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceData _$DeviceDataFromJson(Map<String, dynamic> json) => DeviceData(
  batteryLevel: (json['batteryLevel'] as num).toInt(),
  isCharging: json['isCharging'] as bool,
  isScreenOn: json['isScreenOn'] as bool,
);

Map<String, dynamic> _$DeviceDataToJson(DeviceData instance) =>
    <String, dynamic>{
      'batteryLevel': instance.batteryLevel,
      'isCharging': instance.isCharging,
      'isScreenOn': instance.isScreenOn,
    };
