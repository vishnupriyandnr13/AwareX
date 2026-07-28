import 'package:json_annotation/json_annotation.dart';

part 'device_data.g.dart';

@JsonSerializable()
class DeviceData {
  final int batteryLevel;
  final bool isCharging;
  final bool isScreenOn;

  const DeviceData({
    required this.batteryLevel,
    required this.isCharging,
    required this.isScreenOn,
  });

  bool get isBatteryLow => batteryLevel <= 20;

  DeviceData copyWith({int? batteryLevel, bool? isCharging, bool? isScreenOn}) {
    return DeviceData(
      batteryLevel: batteryLevel ?? this.batteryLevel,
      isCharging: isCharging ?? this.isCharging,
      isScreenOn: isScreenOn ?? this.isScreenOn,
    );
  }

  factory DeviceData.fromJson(Map<String, dynamic> json) =>
      _$DeviceDataFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceDataToJson(this);

  @override
  String toString() => 'Battery: $batteryLevel%';
}
