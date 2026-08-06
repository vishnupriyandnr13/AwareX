enum ThreatLevel { safe, low, medium, high, critical }

extension ThreatLevelX on ThreatLevel {
  String get label {
    switch (this) {
      case ThreatLevel.safe:
        return 'SAFE';
      case ThreatLevel.low:
        return 'LOW';
      case ThreatLevel.medium:
        return 'MEDIUM';
      case ThreatLevel.high:
        return 'HIGH';
      case ThreatLevel.critical:
        return 'CRITICAL';
    }
  }

  int get priority {
    switch (this) {
      case ThreatLevel.safe:
        return 0;
      case ThreatLevel.low:
        return 1;
      case ThreatLevel.medium:
        return 2;
      case ThreatLevel.high:
        return 3;
      case ThreatLevel.critical:
        return 4;
    }
  }

  bool get isEmergency => this == ThreatLevel.critical;
}
