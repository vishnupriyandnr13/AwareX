import 'dart:async';

import 'package:awarex/core/enums/movement_state.dart';
import 'package:awarex/core/enums/threat_level.dart';
import 'package:awarex/core/enums/threat_reason.dart';
import 'package:awarex/core/enums/time_context.dart';

import 'package:awarex/models/context/context_data.dart';
import 'package:awarex/models/threat/threat_assessment.dart';

import 'package:awarex/services/context/context_service.dart';
import 'package:awarex/services/threat/threat_service.dart';

class ThreatServiceImpl implements ThreatService {
  ThreatServiceImpl({required ContextService contextService})
    : _contextService = contextService;

  final ContextService _contextService;

  final StreamController<ThreatAssessment> _controller =
      StreamController.broadcast();

  StreamSubscription<ContextData>? _contextSubscription;

  ThreatAssessment? _lastThreat;

  bool _started = false;
  bool _disposed = false;

  ContextData? _latestContext;

  @override
  Future<ThreatAssessment> getCurrentThreat() async {
    final context = await _contextService.getCurrentContext();
    return _calculateThreat(context);
  }

  @override
  Stream<ThreatAssessment> getThreatStream() {
    if (!_started) {
      _started = true;

      _contextSubscription = _contextService.getContextStream().listen((
        context,
      ) {
        _latestContext = context;
        _emitThreat();
      });
    }

    return _controller.stream;
  }

  void _emitThreat() {
    if (_disposed) return;

    final context = _latestContext;

    if (context == null) return;

    final threat = _calculateThreat(context);

    if (_lastThreat == threat) {
      return;
    }

    _lastThreat = threat;

    if (!_controller.isClosed) {
      _controller.add(threat);
    }
  }

  ThreatAssessment _calculateThreat(ContextData context) {
    double score = 0;

    final reasons = <ThreatReason>[];

    //------------------------------------------------------------
    // Time
    //------------------------------------------------------------

    if (context.timeContext == TimeContext.night) {
      score += 15;
      reasons.add(ThreatReason.nightTime);
    }

    //------------------------------------------------------------
    // GPS
    //------------------------------------------------------------

    if (!context.gpsReliable) {
      score += 20;
      reasons.add(ThreatReason.gpsUnavailable);
    }

    //------------------------------------------------------------
    // Battery
    //------------------------------------------------------------

    if (context.batteryLow) {
      score += 15;
      reasons.add(ThreatReason.batteryLow);
    }

    //------------------------------------------------------------
    // Offline
    //------------------------------------------------------------

    if (context.offline) {
      score += 20;
      reasons.add(ThreatReason.offline);
    }

    //------------------------------------------------------------
    // Screen
    //------------------------------------------------------------

    if (!context.screenOn) {
      score += 5;
      reasons.add(ThreatReason.screenOff);
    }

    //------------------------------------------------------------
    // Movement
    //------------------------------------------------------------

    switch (context.movement) {
      case MovementState.stationary:
        reasons.add(ThreatReason.stationary);
        break;

      case MovementState.moving:
        score += 10;
        reasons.add(ThreatReason.walking);
        break;

      case MovementState.highMotion:
        score += 25;
        reasons.add(ThreatReason.rapidMovement);
        break;
    }

    //------------------------------------------------------------
    // Multiple risk factors bonus
    //------------------------------------------------------------

    if (reasons.length >= 3) {
      score += 10;
      reasons.add(ThreatReason.multipleRiskFactors);
    }

    if (reasons.isEmpty) {
      reasons.add(ThreatReason.none);
    }

    final level = _levelFromScore(score);

    return ThreatAssessment(
      level: level,
      score: score,
      reasons: reasons,
      timestamp: DateTime.now(),
    );
  }

  ThreatLevel _levelFromScore(double score) {
    if (score >= 80) {
      return ThreatLevel.critical;
    }

    if (score >= 60) {
      return ThreatLevel.high;
    }

    if (score >= 40) {
      return ThreatLevel.medium;
    }

    if (score >= 20) {
      return ThreatLevel.low;
    }

    return ThreatLevel.safe;
  }

  @override
  void dispose() {
    if (_disposed) return;

    _disposed = true;

    _contextSubscription?.cancel();

    _controller.close();
  }
}
