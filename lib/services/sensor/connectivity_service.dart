import 'package:awarex/models/sensor/connectivity_data.dart';

abstract interface class ConnectivityService {
  Future<ConnectivityData> getCurrentConnectivity();

  Stream<ConnectivityData> getConnectivityStream();

  void dispose();
}
