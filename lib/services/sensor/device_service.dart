import 'package:awarex/models/sensor/device_data.dart';

abstract interface class DeviceService {
  Future<DeviceData> getCurrentDeviceData();

  Stream<DeviceData> getDeviceDataStream();

  void dispose();
}
