// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'GetMaterialConsumptionByID.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetMaterialConsumptionByID _$GetMaterialConsumptionByIDFromJson(
  Map<String, dynamic> json,
) => GetMaterialConsumptionByID(
  data:
      (json['data'] as List<dynamic>?)
          ?.map(
            (e) => MaterialConsumptionByID.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
);

Map<String, dynamic> _$GetMaterialConsumptionByIDToJson(
  GetMaterialConsumptionByID instance,
) => <String, dynamic>{'data': instance.data};

MaterialConsumptionByID _$MaterialConsumptionByIDFromJson(
  Map<String, dynamic> json,
) => MaterialConsumptionByID(
  item: json['item'],
  date: json['date'],
  material_id: json['material_id'],
  used_qauntity: json['used_qauntity'],
  updated_by: json['updated_by'],
  scrap: json['scrap'],
  updated_dt: json['updated_dt'],
  gatePass: json['gatePass'],
  rate: json['rate'],
  unit: json['unit'],
  consumption_id: json['consumption_id'],
  total_amount: json['total_amount'],
  balance_quantity: json['balance_quantity'],
  project_id: json['project_id'],
);

Map<String, dynamic> _$MaterialConsumptionByIDToJson(
  MaterialConsumptionByID instance,
) => <String, dynamic>{
  'item': instance.item,
  'date': instance.date,
  'material_id': instance.material_id,
  'used_qauntity': instance.used_qauntity,
  'updated_by': instance.updated_by,
  'scrap': instance.scrap,
  'updated_dt': instance.updated_dt,
  'gatePass': instance.gatePass,
  'rate': instance.rate,
  'unit': instance.unit,
  'consumption_id': instance.consumption_id,
  'total_amount': instance.total_amount,
  'balance_quantity': instance.balance_quantity,
  'project_id': instance.project_id,
};
