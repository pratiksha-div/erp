import 'package:json_annotation/json_annotation.dart';

part 'DAOGetProjectData.g.dart';

@JsonSerializable()
class DAOGetGetProjectData {
  List<GetProjectData>? data;

  DAOGetGetProjectData({
    this.data
  });

  factory DAOGetGetProjectData.fromJson(Map<String, dynamic> json) => _$DAOGetGetProjectDataFromJson(json);

  Map<String, dynamic> toJson() => _$DAOGetGetProjectDataToJson(this);
}

@JsonSerializable()
class GetProjectData {
  String? project_manager;
  String? customerName;
  String? Expected_Cost;
  String? project_end_date;
  String? project_name;
  String? ProjectCo_ordinator;
  String? project_start_date;
  String? project_type;
  String? Status;
  String? project_dscription;
  String? godownlist;
  String? CompanyId;
  String? project_id;
  String? state;
  String? Address;

  GetProjectData({
    this.project_manager,
    this.customerName,
    this.Expected_Cost,
    this.project_end_date,
    this.project_name,
    this.ProjectCo_ordinator,
    this.project_start_date,
    this.project_type,
    this.Status,
    this.project_dscription,
    this.godownlist,
    this.CompanyId,
    this.project_id,
    this.state,
    this.Address
  });

  factory GetProjectData.fromJson(Map<String, dynamic> json) => _$GetProjectDataFromJson(json);

  Map<String, dynamic> toJson() => _$GetProjectDataToJson(this);
}