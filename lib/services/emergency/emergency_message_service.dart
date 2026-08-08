import 'package:awarex/models/emergency/emergency_message.dart';

abstract interface class EmergencyMessageService {
  /// Generates the latest emergency message.
  ///
  /// Returns null when there is no trusted contact available.
  Future<EmergencyMessage?> generateEmergencyMessage();

  /// Returns the latest generated message.
  EmergencyMessage? getLatestMessage();

  /// Continuous stream of generated emergency messages.
  Stream<EmergencyMessage> getMessageStream();

  /// Clears the currently generated message.
  void clear();

  void dispose();
}
