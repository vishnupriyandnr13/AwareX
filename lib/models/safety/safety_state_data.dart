import 'package:json_annotation/json_annotation.dart';

import 'package:awarex/core/enums/safety_state.dart';
import 'package:awarex/core/enums/threat_level.dart';

part 'safety_state_data.g.dart';

@JsonSerializable()
class SafetyStateData {
  final SafetyState state;

  final ThreatLevel threatLevel;

  final DateTime timestamp;

  const SafetyStateData({
    required this.state,
    required this.threatLevel,
    required this.timestamp,
  });

  factory SafetyStateData.initial() {
    return SafetyStateData(
      state: SafetyState.safe,
      threatLevel: ThreatLevel.safe,
      timestamp: DateTime.now(),
    );
  }

  factory SafetyStateData.fromJson(Map<String, dynamic> json) =>
      _$SafetyStateDataFromJson(json);

  Map<String, dynamic> toJson() => _$SafetyStateDataToJson(this);

  SafetyStateData copyWith({
    SafetyState? state,
    ThreatLevel? threatLevel,
    DateTime? timestamp,
  }) {
    return SafetyStateData(
      state: state ?? this.state,
      threatLevel: threatLevel ?? this.threatLevel,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SafetyStateData &&
        state == other.state &&
        threatLevel == other.threatLevel;
  }

  @override
  int get hashCode => Object.hash(state, threatLevel);

  @override
  String toString() {
    return 'SafetyStateData('
        'state: ${state.label}, '
        'threat: ${threatLevel.label}'
        ')';
  }
}
