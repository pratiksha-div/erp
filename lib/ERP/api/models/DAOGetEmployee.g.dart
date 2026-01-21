// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DAOGetEmployee.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DAOGetEmployee _$DAOGetEmployeeFromJson(Map<String, dynamic> json) =>
    DAOGetEmployee(
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => EmployeeData.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$DAOGetEmployeeToJson(DAOGetEmployee instance) =>
    <String, dynamic>{'data': instance.data};

EmployeeData _$EmployeeDataFromJson(Map<String, dynamic> json) => EmployeeData(
  EmployeeId: json['EmployeeId'] as String?,
  EmployeeName: json['EmployeeName'] as String?,
);

Map<String, dynamic> _$EmployeeDataToJson(EmployeeData instance) =>
    <String, dynamic>{
      'EmployeeId': instance.EmployeeId,
      'EmployeeName': instance.EmployeeName,
    };
