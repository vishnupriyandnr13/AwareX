import 'dart:async';

import 'package:awarex/core/enums/connection_type.dart';
import 'package:awarex/models/sensor/connectivity_data.dart';
import 'package:awarex/services/sensor/connectivity_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityServiceImpl implements ConnectivityService {
  ConnectivityServiceImpl() {
    _initialize();
  }

  final Connectivity _connectivity = Connectivity();

  final StreamController<ConnectivityData> _controller =
      StreamController<ConnectivityData>.broadcast();

  StreamSubscription<List<ConnectivityResult>>? _subscription;

  ConnectivityData? _latest;

  void _initialize() {
    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      final result = results.isNotEmpty
          ? results.first
          : ConnectivityResult.none;

      _latest = _map(result);

      _controller.add(_latest!);
    });
  }

  ConnectivityData _map(ConnectivityResult result) {
    return ConnectivityData(
      connectionType: switch (result) {
        ConnectivityResult.wifi => ConnectionType.wifi,
        ConnectivityResult.mobile => ConnectionType.mobile,
        ConnectivityResult.ethernet => ConnectionType.ethernet,
        ConnectivityResult.bluetooth => ConnectionType.bluetooth,
        ConnectivityResult.vpn => ConnectionType.vpn,
        _ => ConnectionType.none,
      },
    );
  }

  @override
  Future<ConnectivityData> getCurrentConnectivity() async {
    final results = await _connectivity.checkConnectivity();

    return _map(results.isNotEmpty ? results.first : ConnectivityResult.none);
  }

  @override
  Stream<ConnectivityData> getConnectivityStream() {
    return _controller.stream;
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _controller.close();
  }
}
