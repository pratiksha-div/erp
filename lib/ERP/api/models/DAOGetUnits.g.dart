// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DAOGetUnits.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DAOGetUnits _$DAOGetUnitsFromJson(Map<String, dynamic> json) => DAOGetUnits(
  data:
      (json['data'] as List<dynamic>?)
          ?.map((e) => UnitsData.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$DAOGetUnitsToJson(DAOGetUnits instance) =>
    <String, dynamic>{'data': instance.data};

UnitsData _$UnitsDataFromJson(Map<String, dynamic> json) => UnitsData(
  unit_name: json['unit_name'] as String?,
  hsncode: json['hsncode'] as String?,
);

Map<String, dynamic> _$UnitsDataToJson(UnitsData instance) => <String, dynamic>{
  'unit_name': instance.unit_name,
  'hsncode': instance.hsncode,
};
