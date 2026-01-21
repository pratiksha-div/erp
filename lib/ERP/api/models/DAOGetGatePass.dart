import 'package:json_annotation/json_annotation.dart';

part 'DAOGetGatePass.g.dart';

@JsonSerializable()
class DAOGetGatePass {
  List<GatePassData>? data;

  DAOGetGatePass({this.data});

  factory DAOGetGatePass.fromJson(Map<String, dynamic> json) =>
      _$DAOGetGatePassFromJson(json);

  Map<String, dynamic> toJson() => _$DAOGetGatePassToJson(this);
}

@JsonSerializable()
class GatePassData {
  dynamic from_warehouse_name;
  dynamic issued_to;
  dynamic date;
  dynamic to_project_name;
  dynamic vehicle_no;
  dynamic gate_pass;
  dynamic out_time;
  dynamic vehicle_name;
  dynamic consumed;
  dynamic to_project_id;
  dynamic to_warehouse_id;
  dynamic issued_material;
  dynamic transfer_type;
  dynamic subgroup_names;
  dynamic group_names;
  dynamic to_warehouse_name;
  dynamic quantity;
  dynamic gatepass_id;
  dynamic unit;
  dynamic issued_by;
  dynamic description;
  dynamic from_warehouse_id;

  GatePassData(
      {
           this.from_warehouse_name,
           this.issued_to,
           this.date,
           this.to_project_name,
           this.vehicle_no,
           this.gate_pass,
           this.out_time,
           this.vehicle_name,
           this.consumed,
           this.to_project_id,
           this.to_warehouse_id,
           this.issued_material,
           this.transfer_type,
           this.subgroup_names,
           this.group_names,
           this.to_warehouse_name,
           this.quantity,
           this.gatepass_id,
           this.unit,
           this.issued_by,
           this.description,
           this.from_warehouse_id,
      });

  factory GatePassData.fromJson(Map<String, dynamic> json) =>
      _$GatePassDataFromJson(json);

  Map<String, dynamic> toJson() => _$GatePassDataToJson(this);
}
