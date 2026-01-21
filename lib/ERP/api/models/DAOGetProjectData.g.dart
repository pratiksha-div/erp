// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DAOGetProjectData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DAOGetGetProjectData _$DAOGetGetProjectDataFromJson(
  Map<String, dynamic> json,
) => DAOGetGetProjectData(
  data:
      (json['data'] as List<dynamic>?)
          ?.map((e) => GetProjectData.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$DAOGetGetProjectDataToJson(
  DAOGetGetProjectData instance,
) => <String, dynamic>{'data': instance.data};

GetProjectData _$GetProjectDataFromJson(Map<String, dynamic> json) =>
    GetProjectData(
      project_manager: json['project_manager'] as String?,
      customerName: json['customerName'] as String?,
      Expected_Cost: json['Expected_Cost'] as String?,
      project_end_date: json['project_end_date'] as String?,
      project_name: json['project_name'] as String?,
      ProjectCo_ordinator: json['ProjectCo_ordinator'] as String?,
      project_start_date: json['project_start_date'] as String?,
      project_type: json['project_type'] as String?,
      Status: json['Status'] as String?,
      project_dscription: json['project_dscription'] as String?,
      godownlist: json['godownlist'] as String?,
      CompanyId: json['CompanyId'] as String?,
      project_id: json['project_id'] as String?,
      state: json['state'] as String?,
      Address: json['Address'] as String?,
    );

Map<String, dynamic> _$GetProjectDataToJson(GetProjectData instance) =>
    <String, dynamic>{
      'project_manager': instance.project_manager,
      'customerName': instance.customerName,
      'Expected_Cost': instance.Expected_Cost,
      'project_end_date': instance.project_end_date,
      'project_name': instance.project_name,
      'ProjectCo_ordinator': instance.ProjectCo_ordinator,
      'project_start_date': instance.project_start_date,
      'project_type': instance.project_type,
      'Status': instance.Status,
      'project_dscription': instance.project_dscription,
      'godownlist': instance.godownlist,
      'CompanyId': instance.CompanyId,
      'project_id': instance.project_id,
      'state': instance.state,
      'Address': instance.Address,
    };
