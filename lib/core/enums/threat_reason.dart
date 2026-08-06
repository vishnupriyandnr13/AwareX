enum ThreatReason {
  none,

  nightTime,

  batteryLow,

  offline,

  gpsUnavailable,

  screenOff,

  stationary,

  walking,

  running,

  rapidMovement,

  multipleRiskFactors,
}

extension ThreatReasonX on ThreatReason {
  String get label {
    switch (this) {
      case ThreatReason.none:
        return 'None';

      case ThreatReason.nightTime:
        return 'Night Time';

      case ThreatReason.batteryLow:
        return 'Battery Low';

      case ThreatReason.offline:
        return 'Offline';

      case ThreatReason.gpsUnavailable:
        return 'GPS Unavailable';

      case ThreatReason.screenOff:
        return 'Screen Off';

      case ThreatReason.stationary:
        return 'Stationary';

      case ThreatReason.walking:
        return 'Walking';

      case ThreatReason.running:
        return 'Running';

      case ThreatReason.rapidMovement:
        return 'Rapid Movement';

      case ThreatReason.multipleRiskFactors:
        return 'Multiple Risk Factors';
    }
  }
}
