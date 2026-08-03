// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'context_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContextData _$ContextDataFromJson(Map<String, dynamic> json) => ContextData(
  movement: $enumDecode(_$MovementStateEnumMap, json['movement']),
  gpsReliable: json['gpsReliable'] as bool,
  batteryLow: json['batteryLow'] as bool,
  charging: json['charging'] as bool,
  offline: json['offline'] as bool,
  screenOn: json['screenOn'] as bool,
  timeContext: $enumDecode(_$TimeContextEnumMap, json['timeContext']),
);

Map<String, dynamic> _$ContextDataToJson(ContextData instance) =>
    <String, dynamic>{
      'movement': _$MovementStateEnumMap[instance.movement]!,
      'gpsReliable': instance.gpsReliable,
      'batteryLow': instance.batteryLow,
      'charging': instance.charging,
      'offline': instance.offline,
      'screenOn': instance.screenOn,
      'timeContext': _$TimeContextEnumMap[instance.timeContext]!,
    };

const _$MovementStateEnumMap = {
  MovementState.stationary: 'stationary',
  MovementState.moving: 'moving',
  MovementState.highMotion: 'highMotion',
};

const _$TimeContextEnumMap = {
  TimeContext.day: 'day',
  TimeContext.evening: 'evening',
  TimeContext.night: 'night',
};
