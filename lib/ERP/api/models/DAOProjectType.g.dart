// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DAOProjectType.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DAOProjectType _$DAOProjectTypeFromJson(Map<String, dynamic> json) =>
    DAOProjectType(
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => ProjectTypeData.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$DAOProjectTypeToJson(DAOProjectType instance) =>
    <String, dynamic>{'data': instance.data};

ProjectTypeData _$ProjectTypeDataFromJson(Map<String, dynamic> json) =>
    ProjectTypeData(
      LookupValue: json['LookupValue'] as String?,
      LookupDataId: json['LookupDataId'] as String?,
    );

Map<String, dynamic> _$ProjectTypeDataToJson(ProjectTypeData instance) =>
    <String, dynamic>{
      'LookupValue': instance.LookupValue,
      'LookupDataId': instance.LookupDataId,
    };
