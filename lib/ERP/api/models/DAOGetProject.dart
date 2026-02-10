import 'package:json_annotation/json_annotation.dart';

part 'DAOGetProject.g.dart';

@JsonSerializable()
class DAOGetProject {
  List<ProjectData>? data;
  String? iTotalDisplayRecords;
  String? recordsTotal;

  DAOGetProject({
    this.data,
    this.iTotalDisplayRecords,
    this.recordsTotal
  });

  factory DAOGetProject.fromJson(Map<String, dynamic> json) => _$DAOGetProjectFromJson(json);

  Map<String, dynamic> toJson() => _$DAOGetProjectToJson(this);
}

@JsonSerializable()
class ProjectData {
  String? project_manager;
  String? customerName;
  String? project_name;
  String? project_start_date;
  String? project_type;
  String? project_dscription;
  String? status;
  String? project_id;
  String? user_id;

  ProjectData({
    this.project_manager,
    this.customerName,
    this.project_name,
    this.project_start_date,
    this.project_type,
    this.project_dscription,
    this.status,
    this.project_id,
    this.user_id

  });

  factory ProjectData.fromJson(Map<String, dynamic> json) => _$ProjectDataFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectDataToJson(this);
}