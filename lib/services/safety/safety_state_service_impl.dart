import 'dart:async';

import 'package:awarex/core/enums/safety_state.dart';
import 'package:awarex/core/enums/threat_level.dart';

import 'package:awarex/models/safety/safety_state_data.dart';
import 'package:awarex/models/threat/threat_assessment.dart';

import 'package:awarex/services/safety/safety_state_service.dart';
import 'package:awarex/services/threat/threat_service.dart';

class SafetyStateServiceImpl implements SafetyStateService {
  SafetyStateServiceImpl({required ThreatService threatService})
    : _threatService = threatService;

  final ThreatService _threatService;

  final StreamController<SafetyStateData> _controller =
      StreamController.broadcast();

  StreamSubscription<ThreatAssessment>? _threatSubscription;

  ThreatAssessment? _latestThreat;

  SafetyStateData? _lastState;

  bool _started = false;
  bool _disposed = false;

  Timer? _downgradeTimer;

  static const Duration _downgradeDelay = Duration(seconds: 10);

  @override
  Future<SafetyStateData> getCurrentState() async {
    final threat = await _threatService.getCurrentThreat();

    return _stateFromThreat(threat);
  }

  @override
  Stream<SafetyStateData> getSafetyStateStream() {
    if (!_started) {
      _started = true;

      _threatSubscription = _threatService.getThreatStream().listen((threat) {
        _latestThreat = threat;
        _processThreat();
      });
    }

    return _controller.stream;
  }

  void _processThreat() {
    if (_disposed) return;

    final threat = _latestThreat;

    if (threat == null) return;

    final next = _stateFromThreat(threat);

    //------------------------------------------
    // First state
    //------------------------------------------

    if (_lastState == null) {
      _emit(next);
      return;
    }

    final current = _lastState!;

    //------------------------------------------
    // Same state
    //------------------------------------------

    if (current.state == next.state) {
      _cancelDowngrade();

      if (current.threatLevel != next.threatLevel) {
        _emit(next);
      }

      return;
    }

    //------------------------------------------
    // Escalation
    //------------------------------------------

    if (next.state.isHigherThan(current.state)) {
      _cancelDowngrade();

      _emit(next);

      return;
    }

    //------------------------------------------
    // Downgrade
    //------------------------------------------

    _scheduleDowngrade(next);
  }

  void _scheduleDowngrade(SafetyStateData target) {
    _cancelDowngrade();

    _downgradeTimer = Timer(_downgradeDelay, () {
      if (_disposed) return;

      final latest = _latestThreat;

      if (latest == null) return;

      final latestState = _stateFromThreat(latest);

      if (latestState.state == target.state) {
        _emit(latestState);
      }
    });
  }

  void _cancelDowngrade() {
    _downgradeTimer?.cancel();
    _downgradeTimer = null;
  }

  void _emit(SafetyStateData state) {
    if (_disposed) return;

    if (_lastState == state) {
      return;
    }

    _lastState = state;

    if (!_controller.isClosed) {
      _controller.add(state);
    }
  }

  SafetyStateData _stateFromThreat(ThreatAssessment threat) {
    return SafetyStateData(
      state: _mapThreat(threat.level),
      threatLevel: threat.level,
      timestamp: DateTime.now(),
    );
  }

  SafetyState _mapThreat(ThreatLevel level) {
    switch (level) {
      case ThreatLevel.safe:
        return SafetyState.safe;

      case ThreatLevel.low:
        return SafetyState.aware;

      case ThreatLevel.medium:
        return SafetyState.alert;

      case ThreatLevel.high:
        return SafetyState.danger;

      case ThreatLevel.critical:
        return SafetyState.emergency;
    }
  }

  @override
  void dispose() {
    if (_disposed) return;

    _disposed = true;

    _cancelDowngrade();

    _threatSubscription?.cancel();

    _controller.close();
  }
}
