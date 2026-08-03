import 'package:json_annotation/json_annotation.dart';

import '../../core/enums/movement_state.dart';
import '../../core/enums/time_context.dart';

part 'context_data.g.dart';

@JsonSerializable()
class ContextData {
  final MovementState movement;

  final bool gpsReliable;

  final bool batteryLow;

  final bool charging;

  final bool offline;

  final bool screenOn;

  final TimeContext timeContext;

  const ContextData({
    required this.movement,
    required this.gpsReliable,
    required this.batteryLow,
    required this.charging,
    required this.offline,
    required this.screenOn,
    required this.timeContext,
  });

  ContextData copyWith({
    MovementState? movement,
    bool? gpsReliable,
    bool? batteryLow,
    bool? charging,
    bool? offline,
    bool? screenOn,
    TimeContext? timeContext,
  }) {
    return ContextData(
      movement: movement ?? this.movement,
      gpsReliable: gpsReliable ?? this.gpsReliable,
      batteryLow: batteryLow ?? this.batteryLow,
      charging: charging ?? this.charging,
      offline: offline ?? this.offline,
      screenOn: screenOn ?? this.screenOn,
      timeContext: timeContext ?? this.timeContext,
    );
  }

  factory ContextData.fromJson(Map<String, dynamic> json) =>
      _$ContextDataFromJson(json);

  Map<String, dynamic> toJson() => _$ContextDataToJson(this);

  @override
  String toString() {
    return 'ContextData('
        'movement: ${movement.name}, '
        'gpsReliable: $gpsReliable, '
        'batteryLow: $batteryLow, '
        'charging: $charging, '
        'offline: $offline, '
        'screenOn: $screenOn, '
        'timeContext: ${timeContext.name}'
        ')';
  }
}
