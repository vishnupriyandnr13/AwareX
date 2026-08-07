// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emergency_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmergencyState _$EmergencyStateFromJson(Map<String, dynamic> json) =>
    EmergencyState(
      action: $enumDecode(_$EmergencyActionEnumMap, json['action']),
      safetyState: $enumDecode(_$SafetyStateEnumMap, json['safetyState']),
      threatLevel: $enumDecode(_$ThreatLevelEnumMap, json['threatLevel']),
      requiresAttention: json['requiresAttention'] as bool,
      placeholderAction: json['placeholderAction'] as bool,
      recommendations: (json['recommendations'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$EmergencyStateToJson(EmergencyState instance) =>
    <String, dynamic>{
      'action': _$EmergencyActionEnumMap[instance.action]!,
      'safetyState': _$SafetyStateEnumMap[instance.safetyState]!,
      'threatLevel': _$ThreatLevelEnumMap[instance.threatLevel]!,
      'requiresAttention': instance.requiresAttention,
      'placeholderAction': instance.placeholderAction,
      'recommendations': instance.recommendations,
      'timestamp': instance.timestamp.toIso8601String(),
    };

const _$EmergencyActionEnumMap = {
  EmergencyAction.silentMonitoring: 'silentMonitoring',
  EmergencyAction.periodicCheckIn: 'periodicCheckIn',
  EmergencyAction.recommendSaferRoute: 'recommendSaferRoute',
  EmergencyAction.notifyTrustedContact: 'notifyTrustedContact',
  EmergencyAction.emergencyEscalation: 'emergencyEscalation',
  EmergencyAction.fakeCall: 'fakeCall',
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
