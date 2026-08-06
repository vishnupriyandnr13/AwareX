import 'package:json_annotation/json_annotation.dart';

import 'package:awarex/core/enums/threat_level.dart';
import 'package:awarex/core/enums/threat_reason.dart';

part 'threat_assessment.g.dart';

@JsonSerializable()
class ThreatAssessment {
  final ThreatLevel level;

  /// Overall threat score (0–100+)
  final double score;

  /// Reasons contributing to the threat level.
  final List<ThreatReason> reasons;

  final DateTime timestamp;

  const ThreatAssessment({
    required this.level,
    required this.score,
    required this.reasons,
    required this.timestamp,
  });

  factory ThreatAssessment.initial() {
    return ThreatAssessment(
      level: ThreatLevel.safe,
      score: 0,
      reasons: const [ThreatReason.none],
      timestamp: DateTime.now(),
    );
  }

  bool get isSafe => level == ThreatLevel.safe;

  bool get isDanger =>
      level == ThreatLevel.high || level == ThreatLevel.critical;

  bool get hasReasons =>
      reasons.isNotEmpty && reasons.first != ThreatReason.none;

  ThreatAssessment copyWith({
    ThreatLevel? level,
    double? score,
    List<ThreatReason>? reasons,
    DateTime? timestamp,
  }) {
    return ThreatAssessment(
      level: level ?? this.level,
      score: score ?? this.score,
      reasons: reasons ?? this.reasons,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  factory ThreatAssessment.fromJson(Map<String, dynamic> json) =>
      _$ThreatAssessmentFromJson(json);

  Map<String, dynamic> toJson() => _$ThreatAssessmentToJson(this);

  @override
  String toString() {
    return 'ThreatAssessment('
        'level: ${level.label}, '
        'score: $score, '
        'reasons: ${reasons.map((e) => e.label).join(", ")}, '
        'timestamp: $timestamp'
        ')';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ThreatAssessment &&
        level == other.level &&
        score == other.score &&
        _listEquals(reasons, other.reasons);
  }

  @override
  int get hashCode => Object.hash(level, score, Object.hashAll(reasons));

  static bool _listEquals(List<ThreatReason> a, List<ThreatReason> b) {
    if (a.length != b.length) return false;

    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) {
        return false;
      }
    }

    return true;
  }
}
