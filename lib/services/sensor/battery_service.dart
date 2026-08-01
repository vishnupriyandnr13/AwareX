abstract interface class BatteryService {
  Future<int> getBatteryLevel();

  Future<bool> isCharging();

  Stream<int> getBatteryLevelStream();

  void dispose();
}
