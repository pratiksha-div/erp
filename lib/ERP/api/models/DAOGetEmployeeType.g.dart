// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DAOGetEmployeeType.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DAOGetEmployeeType _$DAOGetEmployeeTypeFromJson(Map<String, dynamic> json) =>
    DAOGetEmployeeType(
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => EmployeeTypeData.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$DAOGetEmployeeTypeToJson(DAOGetEmployeeType instance) =>
    <String, dynamic>{'data': instance.data};

EmployeeTypeData _$EmployeeTypeDataFromJson(Map<String, dynamic> json) =>
    EmployeeTypeData(
      LookupValue: json['LookupValue'] as String?,
      LookupDataId: json['LookupDataId'] as String?,
    );

Map<String, dynamic> _$EmployeeTypeDataToJson(EmployeeTypeData instance) =>
    <String, dynamic>{
      'LookupValue': instance.LookupValue,
      'LookupDataId': instance.LookupDataId,
    };
