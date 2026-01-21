import 'package:json_annotation/json_annotation.dart';

part 'DAOGetProjectList.g.dart';

@JsonSerializable()
class DAOGetProjectList {
  List<ProjectListData>? data;

  DAOGetProjectList({
    this.data
  });

  factory DAOGetProjectList.fromJson(Map<String, dynamic> json) => _$DAOGetProjectListFromJson(json);

  Map<String, dynamic> toJson() => _$DAOGetProjectListToJson(this);
}

@JsonSerializable()
class ProjectListData {
  String? project_name;
  String? project_id;

  ProjectListData({
    this.project_name,
    this.project_id,
  });

  factory ProjectListData.fromJson(Map<String, dynamic> json) => _$ProjectListDataFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectListDataToJson(this);
}