// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DAOMaterialConsumptionList.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DAOMaterialConsumptionList _$DAOMaterialConsumptionListFromJson(
  Map<String, dynamic> json,
) => DAOMaterialConsumptionList(
  data:
      (json['data'] as List<dynamic>?)
          ?.map(
            (e) => MaterialConsumptionList.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
);

Map<String, dynamic> _$DAOMaterialConsumptionListToJson(
  DAOMaterialConsumptionList instance,
) => <String, dynamic>{'data': instance.data};

MaterialConsumptionList _$MaterialConsumptionListFromJson(
  Map<String, dynamic> json,
) => MaterialConsumptionList(
  item: json['item'],
  date: json['date'],
  material_id: json['material_id'],
  scrap: json['scrap'],
  project_id: json['project_id'],
  gatePass: json['gatePass'],
  rate: json['rate'],
  used_quantity: json['used_quantity'],
  unit: json['unit'],
  consumption_id: json['consumption_id'],
  total_amount: json['total_amount'],
  balance_quantity: json['balance_quantity'],
  project_name: json['project_name'],
  user_id: json['user_id'],
);

Map<String, dynamic> _$MaterialConsumptionListToJson(
  MaterialConsumptionList instance,
) => <String, dynamic>{
  'item': instance.item,
  'date': instance.date,
  'material_id': instance.material_id,
  'scrap': instance.scrap,
  'project_id': instance.project_id,
  'gatePass': instance.gatePass,
  'rate': instance.rate,
  'used_quantity': instance.used_quantity,
  'unit': instance.unit,
  'consumption_id': instance.consumption_id,
  'total_amount': instance.total_amount,
  'balance_quantity': instance.balance_quantity,
  'project_name': instance.project_name,
  'user_id': instance.user_id,
};
