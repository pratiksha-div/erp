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
  basic_unit_name: json['basic_unit_name'] as String?,
  basic_value: json['basic_value'] as String?,
  alt_unit_name: json['alt_unit_name'] as String?,
  alt_value: json['alt_value'] as String?,
);

Map<String, dynamic> _$UnitsDataToJson(UnitsData instance) => <String, dynamic>{
  'unit_name': instance.unit_name,
  'hsncode': instance.hsncode,
  'basic_unit_name': instance.basic_unit_name,
  'basic_value': instance.basic_value,
  'alt_unit_name': instance.alt_unit_name,
  'alt_value': instance.alt_value,
};
