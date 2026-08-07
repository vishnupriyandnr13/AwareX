import 'dart:async';

import 'package:awarex/core/enums/emergency_action.dart';
import 'package:awarex/core/enums/safety_state.dart';

import 'package:awarex/models/emergency/emergency_state.dart';
import 'package:awarex/models/safety/safety_state_data.dart';

import 'package:awarex/services/emergency/emergency_service.dart';
import 'package:awarex/services/safety/safety_state_service.dart';

class EmergencyServiceImpl implements EmergencyService {
  EmergencyServiceImpl({required SafetyStateService safetyService})
    : _safetyService = safetyService;

  final SafetyStateService _safetyService;

  final StreamController<EmergencyState> _controller =
      StreamController<EmergencyState>.broadcast();

  StreamSubscription<SafetyStateData>? _subscription;

  SafetyStateData? _latestSafety;

  EmergencyState? _lastEmergency;

  bool _started = false;
  bool _disposed = false;

  @override
  Future<EmergencyState> getCurrentEmergency() async {
    final safety = await _safetyService.getCurrentState();
    return _buildEmergencyState(safety);
  }

  @override
  Stream<EmergencyState> getEmergencyStream() {
    if (!_started) {
      _started = true;

      _subscription = _safetyService.getSafetyStateStream().listen((safety) {
        _latestSafety = safety;
        _emitEmergency();
      });
    }

    return _controller.stream;
  }

  void _emitEmergency() {
    if (_disposed) return;

    final safety = _latestSafety;

    if (safety == null) return;

    final emergency = _buildEmergencyState(safety);

    if (_lastEmergency == emergency) {
      return;
    }

    _lastEmergency = emergency;

    if (!_controller.isClosed) {
      _controller.add(emergency);
    }
  }

  EmergencyState _buildEmergencyState(SafetyStateData safety) {
    final action = _mapAction(safety.state);

    final recommendations = _recommendations(safety.state);

    return EmergencyState(
      action: action,
      safetyState: safety.state,
      threatLevel: safety.threatLevel,
      requiresAttention: safety.state != SafetyState.safe,
      placeholderAction: action != EmergencyAction.silentMonitoring,
      recommendations: recommendations,
      timestamp: DateTime.now(),
    );
  }

  EmergencyAction _mapAction(SafetyState state) {
    switch (state) {
      case SafetyState.safe:
        return EmergencyAction.silentMonitoring;

      case SafetyState.aware:
        return EmergencyAction.periodicCheckIn;

      case SafetyState.alert:
        return EmergencyAction.recommendSaferRoute;

      case SafetyState.danger:
        return EmergencyAction.notifyTrustedContact;

      case SafetyState.emergency:
        return EmergencyAction.emergencyEscalation;
    }
  }

  List<String> _recommendations(SafetyState state) {
    switch (state) {
      case SafetyState.safe:
        return const ['Continue normal monitoring.'];

      case SafetyState.aware:
        return const [
          'Stay aware of your surroundings.',
          'Keep your phone accessible.',
        ];

      case SafetyState.alert:
        return const [
          'Move towards a populated area.',
          'Prefer well-lit roads.',
          'Avoid isolated routes.',
        ];

      case SafetyState.danger:
        return const [
          'Prepare to notify a trusted contact.',
          'Stay in public view.',
          'Avoid stopping in isolated places.',
        ];

      case SafetyState.emergency:
        return const [
          'Emergency escalation recommended.',
          'Trigger fake call if required.',
          'Notify trusted contact (placeholder).',
        ];
    }
  }

  @override
  void dispose() {
    if (_disposed) return;

    _disposed = true;

    _subscription?.cancel();

    _controller.close();
  }
}
