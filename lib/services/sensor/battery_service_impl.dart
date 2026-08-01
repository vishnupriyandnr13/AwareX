import 'dart:async';

import 'package:battery_plus/battery_plus.dart';

import 'battery_service.dart';

class BatteryServiceImpl implements BatteryService {
  BatteryServiceImpl() {
    _batteryStateSubscription = _battery.onBatteryStateChanged.listen((
      _,
    ) async {
      _controller.add(await getBatteryLevel());
    });
  }

  final Battery _battery = Battery();

  final StreamController<int> _controller = StreamController<int>.broadcast();

  StreamSubscription<BatteryState>? _batteryStateSubscription;

  @override
  Future<int> getBatteryLevel() {
    return _battery.batteryLevel;
  }

  @override
  Future<bool> isCharging() async {
    final state = await _battery.batteryState;

    return state == BatteryState.charging;
  }

  @override
  Stream<int> getBatteryLevelStream() async* {
    yield await getBatteryLevel();

    yield* _controller.stream;
  }

  @override
  void dispose() {
    _batteryStateSubscription?.cancel();
    _controller.close();
  }
}
