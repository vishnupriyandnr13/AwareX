import 'package:json_annotation/json_annotation.dart';

import '../../core/enums/connection_type.dart';

part 'connectivity_data.g.dart';

@JsonSerializable()
class ConnectivityData {
  final ConnectionType connectionType;

  const ConnectivityData({required this.connectionType});

  bool get isOffline => connectionType == ConnectionType.none;

  ConnectivityData copyWith({ConnectionType? connectionType}) {
    return ConnectivityData(
      connectionType: connectionType ?? this.connectionType,
    );
  }

  factory ConnectivityData.fromJson(Map<String, dynamic> json) =>
      _$ConnectivityDataFromJson(json);

  Map<String, dynamic> toJson() => _$ConnectivityDataToJson(this);

  @override
  String toString() => connectionType.name;
}
