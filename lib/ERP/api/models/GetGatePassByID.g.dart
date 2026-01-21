// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'GetGatePassByID.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetGatePassByID _$GetGatePassByIDFromJson(Map<String, dynamic> json) =>
    GetGatePassByID(
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => GatePassByID.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$GetGatePassByIDToJson(GetGatePassByID instance) =>
    <String, dynamic>{'data': instance.data};

GatePassByID _$GatePassByIDFromJson(Map<String, dynamic> json) => GatePassByID(
  from_warehouse_name: json['from_warehouse_name'],
  issued_to: json['issued_to'],
  from_warehouse: json['from_warehouse'],
  to_project_name: json['to_project_name'],
  vehicle_no: json['vehicle_no'],
  out_time: json['out_time'],
  issued_by_name: json['issued_by_name'],
  issued_material: json['issued_material'],
  transfer_type: json['transfer_type'],
  subgroup_names: json['subgroup_names'],
  groupid: json['groupid'],
  group_names: json['group_names'],
  rate: json['rate'],
  sub_groupid: json['sub_groupid'],
  description: json['description'],
  amount: json['amount'],
  issued_to_name: json['issued_to_name'],
  date: json['date'],
  gate_pass: json['gate_pass'],
  vehicle_name: json['vehicle_name'],
  to_warehouse: json['to_warehouse'],
  scrap: json['scrap'],
  vehicle_number: json['vehicle_number'],
  current_balance: json['current_balance'],
  consumed: json['consumed'],
  balance: json['balance'],
  to_warehouse_name: json['to_warehouse_name'],
  used_quantity: json['used_quantity'],
  quantity: json['quantity'],
  gatepass_id: json['gatepass_id'],
  unit: json['unit'],
  issued_by: json['issued_by'],
  to_project: json['to_project'],
);

Map<String, dynamic> _$GatePassByIDToJson(GatePassByID instance) =>
    <String, dynamic>{
      'from_warehouse_name': instance.from_warehouse_name,
      'issued_to': instance.issued_to,
      'from_warehouse': instance.from_warehouse,
      'to_project_name': instance.to_project_name,
      'vehicle_no': instance.vehicle_no,
      'out_time': instance.out_time,
      'issued_by_name': instance.issued_by_name,
      'issued_material': instance.issued_material,
      'transfer_type': instance.transfer_type,
      'subgroup_names': instance.subgroup_names,
      'groupid': instance.groupid,
      'group_names': instance.group_names,
      'rate': instance.rate,
      'sub_groupid': instance.sub_groupid,
      'description': instance.description,
      'amount': instance.amount,
      'issued_to_name': instance.issued_to_name,
      'date': instance.date,
      'gate_pass': instance.gate_pass,
      'vehicle_name': instance.vehicle_name,
      'to_warehouse': instance.to_warehouse,
      'scrap': instance.scrap,
      'vehicle_number': instance.vehicle_number,
      'current_balance': instance.current_balance,
      'consumed': instance.consumed,
      'balance': instance.balance,
      'to_warehouse_name': instance.to_warehouse_name,
      'used_quantity': instance.used_quantity,
      'quantity': instance.quantity,
      'gatepass_id': instance.gatepass_id,
      'unit': instance.unit,
      'issued_by': instance.issued_by,
      'to_project': instance.to_project,
    };
