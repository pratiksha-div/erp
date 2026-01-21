// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DAOGetProjectCoordinator.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DAOGetProjectCoordinator _$DAOGetProjectCoordinatorFromJson(
  Map<String, dynamic> json,
) => DAOGetProjectCoordinator(
  data:
      (json['data'] as List<dynamic>?)
          ?.map(
            (e) => ProjectCoordinateData.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
);

Map<String, dynamic> _$DAOGetProjectCoordinatorToJson(
  DAOGetProjectCoordinator instance,
) => <String, dynamic>{'data': instance.data};

ProjectCoordinateData _$ProjectCoordinateDataFromJson(
  Map<String, dynamic> json,
) => ProjectCoordinateData(
  EmployeeId: json['EmployeeId'] as String?,
  EmployeeName: json['EmployeeName'] as String?,
);

Map<String, dynamic> _$ProjectCoordinateDataToJson(
  ProjectCoordinateData instance,
) => <String, dynamic>{
  'EmployeeId': instance.EmployeeId,
  'EmployeeName': instance.EmployeeName,
};
