import 'package:awarex/models/sensor/motion_data.dart';

abstract interface class MotionService {
  /// Returns the latest available motion sample.
  MotionData get currentMotion;

  /// Continuous stream of motion updates.
  Stream<MotionData> get motionStream;

  /// Releases sensor subscriptions.
  void dispose();
}
