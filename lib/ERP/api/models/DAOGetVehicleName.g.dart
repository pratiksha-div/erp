// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DAOGetVehicleName.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DAOGetVehicleName _$DAOGetVehicleNameFromJson(Map<String, dynamic> json) =>
    DAOGetVehicleName(
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => VehicleData.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$DAOGetVehicleNameToJson(DAOGetVehicleName instance) =>
    <String, dynamic>{'data': instance.data};

VehicleData _$VehicleDataFromJson(Map<String, dynamic> json) => VehicleData(
  VehicleName: json['VehicleName'] as String?,
  VehicleNo: json['VehicleNo'] as String?,
  VehicleID: json['VehicleID'] as String?,
);

Map<String, dynamic> _$VehicleDataToJson(VehicleData instance) =>
    <String, dynamic>{
      'VehicleName': instance.VehicleName,
      'VehicleNo': instance.VehicleNo,
      'VehicleID': instance.VehicleID,
    };
