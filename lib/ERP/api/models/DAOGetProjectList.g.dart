// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DAOGetProjectList.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DAOGetProjectList _$DAOGetProjectListFromJson(Map<String, dynamic> json) =>
    DAOGetProjectList(
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => ProjectListData.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$DAOGetProjectListToJson(DAOGetProjectList instance) =>
    <String, dynamic>{'data': instance.data};

ProjectListData _$ProjectListDataFromJson(Map<String, dynamic> json) =>
    ProjectListData(
      project_name: json['project_name'] as String?,
      project_id: json['project_id'] as String?,
    );

Map<String, dynamic> _$ProjectListDataToJson(ProjectListData instance) =>
    <String, dynamic>{
      'project_name': instance.project_name,
      'project_id': instance.project_id,
    };
