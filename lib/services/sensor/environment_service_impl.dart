import 'dart:async';

import 'package:awarex/models/sensor/environment_data.dart';
import 'package:awarex/services/sensor/environment_service.dart';

class EnvironmentServiceImpl implements EnvironmentService {
  EnvironmentServiceImpl() {
    _publishCurrentEnvironment();
  }

  final StreamController<EnvironmentData> _controller =
      StreamController<EnvironmentData>.broadcast();

  EnvironmentData _current = const EnvironmentData(ambientLight: 0);

  void _publishCurrentEnvironment() {
    _controller.add(_current);
  }

  @override
  Future<EnvironmentData> getCurrentEnvironment() async {
    return _current;
  }

  @override
  Stream<EnvironmentData> getEnvironmentStream() {
    return _controller.stream;
  }

  @override
  void dispose() {
    _controller.close();
  }
}
