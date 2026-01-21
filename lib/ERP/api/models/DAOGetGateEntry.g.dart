// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DAOGetGateEntry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DAOGetGateEntry _$DAOGetGateEntryFromJson(Map<String, dynamic> json) =>
    DAOGetGateEntry(
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => GateEntryData.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$DAOGetGateEntryToJson(DAOGetGateEntry instance) =>
    <String, dynamic>{'data': instance.data};

GateEntryData _$GateEntryDataFromJson(Map<String, dynamic> json) =>
    GateEntryData(
      from_vendor: json['from_vendor'],
      vehicle_no: json['vehicle_no'],
      item_name: json['item_name'],
      to_warehouse: json['to_warehouse'],
      gate_entry_id: json['gate_entry_id'],
      ordered_by: json['ordered_by'],
      bill_no: json['bill_no'],
      challan_no: json['challan_no'],
      selected_po: json['selected_po'],
      gen_no: json['gen_no'],
      quantity: json['quantity'],
    );

Map<String, dynamic> _$GateEntryDataToJson(GateEntryData instance) =>
    <String, dynamic>{
      'from_vendor': instance.from_vendor,
      'vehicle_no': instance.vehicle_no,
      'item_name': instance.item_name,
      'to_warehouse': instance.to_warehouse,
      'gate_entry_id': instance.gate_entry_id,
      'ordered_by': instance.ordered_by,
      'bill_no': instance.bill_no,
      'challan_no': instance.challan_no,
      'selected_po': instance.selected_po,
      'gen_no': instance.gen_no,
      'quantity': instance.quantity,
    };
