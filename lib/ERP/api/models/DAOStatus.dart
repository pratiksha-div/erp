import 'package:json_annotation/json_annotation.dart';

part 'DAOStatus.g.dart';

@JsonSerializable()
class DAOStatus {
  List<StatusData>? data;

  DAOStatus({
    this.data
  });

  factory DAOStatus.fromJson(Map<String, dynamic> json) => _$DAOStatusFromJson(json);

  Map<String, dynamic> toJson() => _$DAOStatusToJson(this);
}

@JsonSerializable()
class StatusData {
  String? LookupValue;
  String? LookupDataId;

  StatusData({
    this.LookupValue,
    this.LookupDataId,
  });

  factory StatusData.fromJson(Map<String, dynamic> json) => _$StatusDataFromJson(json);

  Map<String, dynamic> toJson() => _$StatusDataToJson(this);
}