import 'package:awarex/models/sensor/environment_data.dart';

abstract interface class EnvironmentService {
  /// Returns the current environmental data.
  Future<EnvironmentData> getCurrentEnvironment();

  /// Continuous stream of environment updates.
  Stream<EnvironmentData> getEnvironmentStream();

  /// Releases any resources.
  void dispose();
}
