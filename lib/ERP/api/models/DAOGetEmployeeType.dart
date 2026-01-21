import 'package:json_annotation/json_annotation.dart';

part 'DAOGetEmployeeType.g.dart';

@JsonSerializable()
class DAOGetEmployeeType {

  List<EmployeeTypeData>? data;

  DAOGetEmployeeType({
    this.data
  });

  factory DAOGetEmployeeType.fromJson(Map<String, dynamic> json) => _$DAOGetEmployeeTypeFromJson(json);

  Map<String, dynamic> toJson() => _$DAOGetEmployeeTypeToJson(this);
}

@JsonSerializable()
class EmployeeTypeData {
  String? LookupValue;
  String? LookupDataId;

  EmployeeTypeData({
    this.LookupValue,
    this.LookupDataId

  });

  factory EmployeeTypeData.fromJson(Map<String, dynamic> json) => _$EmployeeTypeDataFromJson(json);

  Map<String, dynamic> toJson() => _$EmployeeTypeDataToJson(this);
}