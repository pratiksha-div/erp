// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'GetGRNDetailByID.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetGRNDetailByID _$GetGRNDetailByIDFromJson(Map<String, dynamic> json) =>
    GetGRNDetailByID(
      data:
          (json['data'] as List<dynamic>?)
              ?.map(
                (e) => GRNDetailByIDData.fromJson(e as Map<String, dynamic>),
              )
              .toList(),
    );

Map<String, dynamic> _$GetGRNDetailByIDToJson(GetGRNDetailByID instance) =>
    <String, dynamic>{'data': instance.data};

GRNDetailByIDData _$GRNDetailByIDDataFromJson(Map<String, dynamic> json) =>
    GRNDetailByIDData(
      accepted_qty: json['accepted_qty'],
      amount: json['amount'],
      bill_no: json['bill_no'],
      challan_no: json['challan_no'],
      contact: json['contact'],
      discount: json['discount'],
      excess_qty: json['excess_qty'],
      from_vendor: json['from_vendor'],
      gate_entry_no: json['gate_entry_no'],
      gen_id: json['gen_id'],
      gen_no: json['gen_no'],
      grn_date: json['grn_date'],
      grn_id: json['grn_id'],
      grn_no: json['grn_no'],
      item_name: json['item_name'],
      po_balance: json['po_balance'],
      po_no: json['po_no'],
      quantity: json['quantity'],
      rate: json['rate'],
      received_qty: json['received_qty'],
      rejected_qty: json['rejected_qty'],
      requested_by: json['requested_by'],
      short_qty: json['short_qty'],
      to_warehouse: json['to_warehouse'],
      vehicle_no: json['vehicle_no'],
      remarks: json['remarks'] as String?,
    );

Map<String, dynamic> _$GRNDetailByIDDataToJson(GRNDetailByIDData instance) =>
    <String, dynamic>{
      'accepted_qty': instance.accepted_qty,
      'amount': instance.amount,
      'bill_no': instance.bill_no,
      'challan_no': instance.challan_no,
      'contact': instance.contact,
      'discount': instance.discount,
      'excess_qty': instance.excess_qty,
      'from_vendor': instance.from_vendor,
      'gate_entry_no': instance.gate_entry_no,
      'gen_id': instance.gen_id,
      'gen_no': instance.gen_no,
      'grn_date': instance.grn_date,
      'grn_id': instance.grn_id,
      'grn_no': instance.grn_no,
      'item_name': instance.item_name,
      'po_balance': instance.po_balance,
      'po_no': instance.po_no,
      'quantity': instance.quantity,
      'rate': instance.rate,
      'received_qty': instance.received_qty,
      'rejected_qty': instance.rejected_qty,
      'requested_by': instance.requested_by,
      'short_qty': instance.short_qty,
      'to_warehouse': instance.to_warehouse,
      'vehicle_no': instance.vehicle_no,
      'remarks': instance.remarks,
    };
