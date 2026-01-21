import 'package:json_annotation/json_annotation.dart';

part 'DAOGetProjectCoordinator.g.dart';

@JsonSerializable()
class DAOGetProjectCoordinator {
  List<ProjectCoordinateData>? data;

  DAOGetProjectCoordinator({
    this.data
  });

  factory DAOGetProjectCoordinator.fromJson(Map<String, dynamic> json) => _$DAOGetProjectCoordinatorFromJson(json);

  Map<String, dynamic> toJson() => _$DAOGetProjectCoordinatorToJson(this);
}

@JsonSerializable()
class ProjectCoordinateData {
  String? EmployeeId;
  String? EmployeeName;

  ProjectCoordinateData({
    this.EmployeeId,
    this.EmployeeName,
  });

  factory ProjectCoordinateData.fromJson(Map<String, dynamic> json) => _$ProjectCoordinateDataFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectCoordinateDataToJson(this);
}