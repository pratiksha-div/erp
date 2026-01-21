// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DAOGetWarehouse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DAOGetWarehouse _$DAOGetWarehouseFromJson(Map<String, dynamic> json) =>
    DAOGetWarehouse(
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => WarehouseData.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$DAOGetWarehouseToJson(DAOGetWarehouse instance) =>
    <String, dynamic>{'data': instance.data};

WarehouseData _$WarehouseDataFromJson(Map<String, dynamic> json) =>
    WarehouseData(
      godown_name: json['godown_name'] as String?,
      godown_id: json['godown_id'] as String?,
    );

Map<String, dynamic> _$WarehouseDataToJson(WarehouseData instance) =>
    <String, dynamic>{
      'godown_name': instance.godown_name,
      'godown_id': instance.godown_id,
    };
