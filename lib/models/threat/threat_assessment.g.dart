// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'threat_assessment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ThreatAssessment _$ThreatAssessmentFromJson(Map<String, dynamic> json) =>
    ThreatAssessment(
      level: $enumDecode(_$ThreatLevelEnumMap, json['level']),
      score: (json['score'] as num).toDouble(),
      reasons: (json['reasons'] as List<dynamic>)
          .map((e) => $enumDecode(_$ThreatReasonEnumMap, e))
          .toList(),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$ThreatAssessmentToJson(
  ThreatAssessment instance,
) => <String, dynamic>{
  'level': _$ThreatLevelEnumMap[instance.level]!,
  'score': instance.score,
  'reasons': instance.reasons.map((e) => _$ThreatReasonEnumMap[e]!).toList(),
  'timestamp': instance.timestamp.toIso8601String(),
};

const _$ThreatLevelEnumMap = {
  ThreatLevel.safe: 'safe',
  ThreatLevel.low: 'low',
  ThreatLevel.medium: 'medium',
  ThreatLevel.high: 'high',
  ThreatLevel.critical: 'critical',
};

const _$ThreatReasonEnumMap = {
  ThreatReason.none: 'none',
  ThreatReason.nightTime: 'nightTime',
  ThreatReason.batteryLow: 'batteryLow',
  ThreatReason.offline: 'offline',
  ThreatReason.gpsUnavailable: 'gpsUnavailable',
  ThreatReason.screenOff: 'screenOff',
  ThreatReason.stationary: 'stationary',
  ThreatReason.walking: 'walking',
  ThreatReason.running: 'running',
  ThreatReason.rapidMovement: 'rapidMovement',
  ThreatReason.multipleRiskFactors: 'multipleRiskFactors',
};
