// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DAOGetVehicleNo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DAOGetVehicleNo _$DAOGetVehicleNoFromJson(Map<String, dynamic> json) =>
    DAOGetVehicleNo(
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => VehicleNoData.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$DAOGetVehicleNoToJson(DAOGetVehicleNo instance) =>
    <String, dynamic>{'data': instance.data};

VehicleNoData _$VehicleNoDataFromJson(Map<String, dynamic> json) =>
    VehicleNoData(
      vehiclename: json['vehiclename'] as String?,
      vehicleno: json['vehicleno'] as String?,
      vehicleid: json['vehicleid'] as String?,
    );

Map<String, dynamic> _$VehicleNoDataToJson(VehicleNoData instance) =>
    <String, dynamic>{
      'vehiclename': instance.vehiclename,
      'vehicleno': instance.vehicleno,
      'vehicleid': instance.vehicleid,
    };
