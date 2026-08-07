import 'package:json_annotation/json_annotation.dart';

import 'package:awarex/core/enums/emergency_action.dart';
import 'package:awarex/core/enums/safety_state.dart';
import 'package:awarex/core/enums/threat_level.dart';

part 'emergency_state.g.dart';

@JsonSerializable()
class EmergencyState {
  final EmergencyAction action;

  final SafetyState safetyState;

  final ThreatLevel threatLevel;

  final bool requiresAttention;

  final bool placeholderAction;

  final List<String> recommendations;

  final DateTime timestamp;

  const EmergencyState({
    required this.action,
    required this.safetyState,
    required this.threatLevel,
    required this.requiresAttention,
    required this.placeholderAction,
    required this.recommendations,
    required this.timestamp,
  });

  factory EmergencyState.initial() {
    return EmergencyState(
      action: EmergencyAction.silentMonitoring,
      safetyState: SafetyState.safe,
      threatLevel: ThreatLevel.safe,
      requiresAttention: false,
      placeholderAction: false,
      recommendations: const [],
      timestamp: DateTime.now(),
    );
  }

  factory EmergencyState.fromJson(Map<String, dynamic> json) =>
      _$EmergencyStateFromJson(json);

  Map<String, dynamic> toJson() => _$EmergencyStateToJson(this);

  @override
  bool operator ==(Object other) {
    return other is EmergencyState &&
        action == other.action &&
        safetyState == other.safetyState &&
        threatLevel == other.threatLevel &&
        requiresAttention == other.requiresAttention;
  }

  @override
  int get hashCode =>
      Object.hash(action, safetyState, threatLevel, requiresAttention);
}
