enum EmergencyAction {
  silentMonitoring,
  periodicCheckIn,
  recommendSaferRoute,
  notifyTrustedContact,
  emergencyEscalation,
  fakeCall,
}

extension EmergencyActionX on EmergencyAction {
  String get label {
    switch (this) {
      case EmergencyAction.silentMonitoring:
        return 'Silent Monitoring';

      case EmergencyAction.periodicCheckIn:
        return 'Periodic Check-in';

      case EmergencyAction.recommendSaferRoute:
        return 'Recommend Safer Route';

      case EmergencyAction.notifyTrustedContact:
        return 'Notify Trusted Contact';

      case EmergencyAction.emergencyEscalation:
        return 'Emergency Escalation';

      case EmergencyAction.fakeCall:
        return 'Fake Call';
    }
  }
}
