// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'GetGateEntryByID.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetGateEntryByID _$GetGateEntryByIDFromJson(Map<String, dynamic> json) =>
    GetGateEntryByID(
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => GateEntryByID.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$GetGateEntryByIDToJson(GetGateEntryByID instance) =>
    <String, dynamic>{'data': instance.data};

GateEntryByID _$GateEntryByIDFromJson(Map<String, dynamic> json) =>
    GateEntryByID(
      item_id: json['item_id'],
      company_name: json['company_name'],
      from_vendor: json['from_vendor'],
      group_id: json['group_id'],
      vehicle_no: json['vehicle_no'],
      bill_date: json['bill_date'],
      item_name: json['item_name'],
      to_warehouse: json['to_warehouse'],
      gate_entry_id: json['gate_entry_id'],
      to_warehouse_id: json['to_warehouse_id'],
      bill_no: json['bill_no'],
      challan_no: json['challan_no'],
      selected_po: json['selected_po'],
      gate_entry_date: json['gate_entry_date'],
      gen_no: json['gen_no'],
      project_id: json['project_id'],
      sub_group_id: json['sub_group_id'],
      quantity: json['quantity'],
    );

Map<String, dynamic> _$GateEntryByIDToJson(GateEntryByID instance) =>
    <String, dynamic>{
      'item_id': instance.item_id,
      'company_name': instance.company_name,
      'from_vendor': instance.from_vendor,
      'group_id': instance.group_id,
      'vehicle_no': instance.vehicle_no,
      'bill_date': instance.bill_date,
      'item_name': instance.item_name,
      'to_warehouse': instance.to_warehouse,
      'gate_entry_id': instance.gate_entry_id,
      'to_warehouse_id': instance.to_warehouse_id,
      'bill_no': instance.bill_no,
      'challan_no': instance.challan_no,
      'selected_po': instance.selected_po,
      'gate_entry_date': instance.gate_entry_date,
      'gen_no': instance.gen_no,
      'project_id': instance.project_id,
      'sub_group_id': instance.sub_group_id,
      'quantity': instance.quantity,
    };
