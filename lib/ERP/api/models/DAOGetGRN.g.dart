// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DAOGetGRN.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DAOGetGRN _$DAOGetGRNFromJson(Map<String, dynamic> json) => DAOGetGRN(
  data:
      (json['data'] as List<dynamic>?)
          ?.map((e) => GRNData.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$DAOGetGRNToJson(DAOGetGRN instance) => <String, dynamic>{
  'data': instance.data,
};

GRNData _$GRNDataFromJson(Map<String, dynamic> json) => GRNData(
  from_vendor: json['from_vendor'],
  vehicle_no: json['vehicle_no'],
  item_name: json['item_name'],
  gate_entry_no: json['gate_entry_no'],
  grn_no: json['grn_no'],
  grn_date: json['grn_date'],
  grn_id: json['grn_id'],
  gen_no: json['gen_no'],
  accepted_qty: json['accepted_qty'],
  requested_by: json['requested_by'],
  po_no: json['po_no'],
);

Map<String, dynamic> _$GRNDataToJson(GRNData instance) => <String, dynamic>{
  'from_vendor': instance.from_vendor,
  'vehicle_no': instance.vehicle_no,
  'item_name': instance.item_name,
  'gate_entry_no': instance.gate_entry_no,
  'grn_no': instance.grn_no,
  'grn_date': instance.grn_date,
  'grn_id': instance.grn_id,
  'gen_no': instance.gen_no,
  'accepted_qty': instance.accepted_qty,
  'requested_by': instance.requested_by,
  'po_no': instance.po_no,
};
