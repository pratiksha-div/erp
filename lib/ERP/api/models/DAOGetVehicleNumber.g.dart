// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DAOGetVehicleNumber.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DAOGetVehicleNumber _$DAOGetVehicleNumberFromJson(Map<String, dynamic> json) =>
    DAOGetVehicleNumber(
      data:
          (json['data'] as List<dynamic>?)
              ?.map(
                (e) => VehicleNumberData.fromJson(e as Map<String, dynamic>),
              )
              .toList(),
    );

Map<String, dynamic> _$DAOGetVehicleNumberToJson(
  DAOGetVehicleNumber instance,
) => <String, dynamic>{'data': instance.data};

VehicleNumberData _$VehicleNumberDataFromJson(Map<String, dynamic> json) =>
    VehicleNumberData(
      VehicleName: json['VehicleName'] as String?,
      VehicleNo: json['VehicleNo'] as String?,
      VehicleID: json['VehicleID'] as String?,
    );

Map<String, dynamic> _$VehicleNumberDataToJson(VehicleNumberData instance) =>
    <String, dynamic>{
      'VehicleName': instance.VehicleName,
      'VehicleNo': instance.VehicleNo,
      'VehicleID': instance.VehicleID,
    };
