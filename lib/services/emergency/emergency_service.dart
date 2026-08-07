import 'package:awarex/models/emergency/emergency_state.dart';

abstract interface class EmergencyService {
  /// Returns the latest emergency state.
  Future<EmergencyState> getCurrentEmergency();

  /// Continuous emergency stream.
  Stream<EmergencyState> getEmergencyStream();

  /// Releases resources.
  void dispose();
}
