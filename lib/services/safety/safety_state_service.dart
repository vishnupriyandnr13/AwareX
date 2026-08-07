import 'package:awarex/models/safety/safety_state_data.dart';

abstract interface class SafetyStateService {
  Future<SafetyStateData> getCurrentState();

  Stream<SafetyStateData> getSafetyStateStream();

  void dispose();
}
