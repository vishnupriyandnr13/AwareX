import 'package:awarex/core/enums/emergency_action.dart';
import 'package:awarex/core/enums/safety_state.dart';
import 'package:awarex/core/enums/threat_level.dart';

class EmergencyMessage {
  const EmergencyMessage({
    required this.recipientName,
    required this.recipientPhone,
    required this.message,
    required this.threatLevel,
    required this.safetyState,
    required this.action,
    required this.timestamp,
    this.latitude,
    this.longitude,
    this.mapsUrl,
  });

  final String recipientName;
  final String recipientPhone;
  final String message;

  final ThreatLevel threatLevel;
  final SafetyState safetyState;
  final EmergencyAction action;

  final DateTime timestamp;

  final double? latitude;
  final double? longitude;
  final String? mapsUrl;

  bool get hasLocation =>
      latitude != null && longitude != null && mapsUrl != null;

  Map<String, dynamic> toJson() {
    return {
      'recipientName': recipientName,
      'recipientPhone': recipientPhone,
      'message': message,
      'threatLevel': threatLevel.name,
      'safetyState': safetyState.name,
      'action': action.name,
      'timestamp': timestamp.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
      'mapsUrl': mapsUrl,
    };
  }
}
