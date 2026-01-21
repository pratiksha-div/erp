import 'package:json_annotation/json_annotation.dart';

part 'DAOGetEmployee.g.dart';

@JsonSerializable()
class DAOGetEmployee {
 List<EmployeeData>? data;

  DAOGetEmployee({
    this.data
  });

  factory DAOGetEmployee.fromJson(Map<String, dynamic> json) => _$DAOGetEmployeeFromJson(json);

  Map<String, dynamic> toJson() => _$DAOGetEmployeeToJson(this);
}

@JsonSerializable()
class EmployeeData {
 String? EmployeeId;
 String? EmployeeName;

 EmployeeData({
    this.EmployeeId,
    this.EmployeeName,
  });

  factory EmployeeData.fromJson(Map<String, dynamic> json) => _$EmployeeDataFromJson(json);

  Map<String, dynamic> toJson() => _$EmployeeDataToJson(this);
}