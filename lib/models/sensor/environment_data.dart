import 'package:json_annotation/json_annotation.dart';

part 'environment_data.g.dart';

@JsonSerializable()
class EnvironmentData {
  final double ambientLight;

  const EnvironmentData({required this.ambientLight});

  bool get isDark => ambientLight < 10;

  EnvironmentData copyWith({double? ambientLight}) {
    return EnvironmentData(ambientLight: ambientLight ?? this.ambientLight);
  }

  factory EnvironmentData.fromJson(Map<String, dynamic> json) =>
      _$EnvironmentDataFromJson(json);

  Map<String, dynamic> toJson() => _$EnvironmentDataToJson(this);

  @override
  String toString() => 'Light: $ambientLight lux';
}
