// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DAOGetProject.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DAOGetProject _$DAOGetProjectFromJson(Map<String, dynamic> json) =>
    DAOGetProject(
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => ProjectData.fromJson(e as Map<String, dynamic>))
              .toList(),
      iTotalDisplayRecords: json['iTotalDisplayRecords'] as String?,
      recordsTotal: json['recordsTotal'] as String?,
    );

Map<String, dynamic> _$DAOGetProjectToJson(DAOGetProject instance) =>
    <String, dynamic>{
      'data': instance.data,
      'iTotalDisplayRecords': instance.iTotalDisplayRecords,
      'recordsTotal': instance.recordsTotal,
    };

ProjectData _$ProjectDataFromJson(Map<String, dynamic> json) => ProjectData(
  project_manager: json['project_manager'] as String?,
  customerName: json['customerName'] as String?,
  project_name: json['project_name'] as String?,
  project_start_date: json['project_start_date'] as String?,
  project_type: json['project_type'] as String?,
  project_dscription: json['project_dscription'] as String?,
  status: json['status'] as String?,
  project_id: json['project_id'] as String?,
  user_id: json['user_id'] as String?,
);

Map<String, dynamic> _$ProjectDataToJson(ProjectData instance) =>
    <String, dynamic>{
      'project_manager': instance.project_manager,
      'customerName': instance.customerName,
      'project_name': instance.project_name,
      'project_start_date': instance.project_start_date,
      'project_type': instance.project_type,
      'project_dscription': instance.project_dscription,
      'status': instance.status,
      'project_id': instance.project_id,
      'user_id': instance.user_id,
    };
