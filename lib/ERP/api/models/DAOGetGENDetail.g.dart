// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DAOGetGENDetail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DAOGetGENDetail _$DAOGetGENDetailFromJson(Map<String, dynamic> json) =>
    DAOGetGENDetail(
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => GENData.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$DAOGetGENDetailToJson(DAOGetGENDetail instance) =>
    <String, dynamic>{'data': instance.data};

GENData _$GENDataFromJson(Map<String, dynamic> json) => GENData(
  contact: json['contact'],
  item_id: json['item_id'],
  company_name: json['company_name'],
  from_vendor: json['from_vendor'],
  group_id: json['group_id'],
  vehicle_no: json['vehicle_no'],
  item_name: json['item_name'],
  to_warehouse: json['to_warehouse'],
  ordered_by: json['ordered_by'],
  to_warehouse_id: json['to_warehouse_id'],
  bill_no: json['bill_no'],
  challan_no: json['challan_no'],
  selected_po: json['selected_po'],
  sub_group_id: json['sub_group_id'],
  quantity: json['quantity'],
  unit: json['unit'],
  requested_by_name: json['requested_by_name'],
  rate: json['rate'],
  grand_total: json['grand_total'],
  item_description: json['item_description'],
);

Map<String, dynamic> _$GENDataToJson(GENData instance) => <String, dynamic>{
  'contact': instance.contact,
  'item_id': instance.item_id,
  'company_name': instance.company_name,
  'from_vendor': instance.from_vendor,
  'group_id': instance.group_id,
  'vehicle_no': instance.vehicle_no,
  'item_name': instance.item_name,
  'to_warehouse': instance.to_warehouse,
  'ordered_by': instance.ordered_by,
  'to_warehouse_id': instance.to_warehouse_id,
  'bill_no': instance.bill_no,
  'challan_no': instance.challan_no,
  'selected_po': instance.selected_po,
  'sub_group_id': instance.sub_group_id,
  'quantity': instance.quantity,
  'unit': instance.unit,
  'requested_by_name': instance.requested_by_name,
  'rate': instance.rate,
  'grand_total': instance.grand_total,
  'item_description': instance.item_description,
};
