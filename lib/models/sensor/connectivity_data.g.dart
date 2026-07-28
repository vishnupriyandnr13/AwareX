// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connectivity_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConnectivityData _$ConnectivityDataFromJson(Map<String, dynamic> json) =>
    ConnectivityData(
      connectionType: $enumDecode(
        _$ConnectionTypeEnumMap,
        json['connectionType'],
      ),
    );

Map<String, dynamic> _$ConnectivityDataToJson(ConnectivityData instance) =>
    <String, dynamic>{
      'connectionType': _$ConnectionTypeEnumMap[instance.connectionType]!,
    };

const _$ConnectionTypeEnumMap = {
  ConnectionType.wifi: 'wifi',
  ConnectionType.mobile: 'mobile',
  ConnectionType.bluetooth: 'bluetooth',
  ConnectionType.ethernet: 'ethernet',
  ConnectionType.none: 'none',
};
