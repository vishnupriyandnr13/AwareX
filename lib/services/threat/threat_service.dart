import 'package:awarex/models/threat/threat_assessment.dart';

abstract interface class ThreatService {
  /// Returns the latest calculated threat.
  Future<ThreatAssessment> getCurrentThreat();

  /// Continuous threat stream.
  Stream<ThreatAssessment> getThreatStream();

  /// Releases resources.
  void dispose();
}
