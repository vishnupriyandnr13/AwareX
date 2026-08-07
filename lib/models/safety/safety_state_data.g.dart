// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'safety_state_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SafetyStateData _$SafetyStateDataFromJson(Map<String, dynamic> json) =>
    SafetyStateData(
      state: $enumDecode(_$SafetyStateEnumMap, json['state']),
      threatLevel: $enumDecode(_$ThreatLevelEnumMap, json['threatLevel']),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$SafetyStateDataToJson(SafetyStateData instance) =>
    <String, dynamic>{
      'state': _$SafetyStateEnumMap[instance.state]!,
      'threatLevel': _$ThreatLevelEnumMap[instance.threatLevel]!,
      'timestamp': instance.timestamp.toIso8601String(),
    };

const _$SafetyStateEnumMap = {
  SafetyState.safe: 'safe',
  SafetyState.aware: 'aware',
  SafetyState.alert: 'alert',
  SafetyState.danger: 'danger',
  SafetyState.emergency: 'emergency',
};

const _$ThreatLevelEnumMap = {
  ThreatLevel.safe: 'safe',
  ThreatLevel.low: 'low',
  ThreatLevel.medium: 'medium',
  ThreatLevel.high: 'high',
  ThreatLevel.critical: 'critical',
};
