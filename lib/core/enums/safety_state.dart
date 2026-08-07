enum SafetyState {
  safe(label: 'Safe', severity: 0),

  aware(label: 'Aware', severity: 1),

  alert(label: 'Alert', severity: 2),

  danger(label: 'Danger', severity: 3),

  emergency(label: 'Emergency', severity: 4);

  final String label;
  final int severity;

  const SafetyState({required this.label, required this.severity});

  bool get isSafe => this == SafetyState.safe;

  bool get isEmergency => this == SafetyState.emergency;

  bool isHigherThan(SafetyState other) => severity > other.severity;

  bool isLowerThan(SafetyState other) => severity < other.severity;
}
