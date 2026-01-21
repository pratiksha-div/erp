// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DAOGetGatePass.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DAOGetGatePass _$DAOGetGatePassFromJson(Map<String, dynamic> json) =>
    DAOGetGatePass(
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => GatePassData.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$DAOGetGatePassToJson(DAOGetGatePass instance) =>
    <String, dynamic>{'data': instance.data};

GatePassData _$GatePassDataFromJson(Map<String, dynamic> json) => GatePassData(
  from_warehouse_name: json['from_warehouse_name'],
  issued_to: json['issued_to'],
  date: json['date'],
  to_project_name: json['to_project_name'],
  vehicle_no: json['vehicle_no'],
  gate_pass: json['gate_pass'],
  out_time: json['out_time'],
  vehicle_name: json['vehicle_name'],
  consumed: json['consumed'],
  to_project_id: json['to_project_id'],
  to_warehouse_id: json['to_warehouse_id'],
  issued_material: json['issued_material'],
  transfer_type: json['transfer_type'],
  subgroup_names: json['subgroup_names'],
  group_names: json['group_names'],
  to_warehouse_name: json['to_warehouse_name'],
  quantity: json['quantity'],
  gatepass_id: json['gatepass_id'],
  unit: json['unit'],
  issued_by: json['issued_by'],
  description: json['description'],
  from_warehouse_id: json['from_warehouse_id'],
);

Map<String, dynamic> _$GatePassDataToJson(GatePassData instance) =>
    <String, dynamic>{
      'from_warehouse_name': instance.from_warehouse_name,
      'issued_to': instance.issued_to,
      'date': instance.date,
      'to_project_name': instance.to_project_name,
      'vehicle_no': instance.vehicle_no,
      'gate_pass': instance.gate_pass,
      'out_time': instance.out_time,
      'vehicle_name': instance.vehicle_name,
      'consumed': instance.consumed,
      'to_project_id': instance.to_project_id,
      'to_warehouse_id': instance.to_warehouse_id,
      'issued_material': instance.issued_material,
      'transfer_type': instance.transfer_type,
      'subgroup_names': instance.subgroup_names,
      'group_names': instance.group_names,
      'to_warehouse_name': instance.to_warehouse_name,
      'quantity': instance.quantity,
      'gatepass_id': instance.gatepass_id,
      'unit': instance.unit,
      'issued_by': instance.issued_by,
      'description': instance.description,
      'from_warehouse_id': instance.from_warehouse_id,
    };
