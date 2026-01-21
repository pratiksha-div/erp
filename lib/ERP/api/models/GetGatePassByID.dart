// import 'package:json_annotation/json_annotation.dart';
//
// part 'GetGatePassByID.g.dart';
//
// @JsonSerializable()
// class GetGatePassByID {
//   List<GatePassByID>? data;
//
//   GetGatePassByID({
//     this.data
//   });
//
//   factory GetGatePassByID.fromJson(Map<String, dynamic> json) => _$GetGatePassByIDFromJson(json);
//
//   Map<String, dynamic> toJson() => _$GetGatePassByIDToJson(this);
// }
//
// @JsonSerializable()
// class GatePassByID {
//   dynamic issued_to;
//   dynamic to_project_list;
//   dynamic from_warehouse;
//   dynamic date;
//   dynamic vehicle_no;
//   dynamic gate_pass;
//   dynamic out_time;
//   dynamic to_warehouse;
//   dynamic scrap;
//   dynamic current_balance;
//   dynamic issued_material;
//   dynamic transfer_type;
//   dynamic balance;
//   dynamic rate;
//   dynamic used_quantity;
//   dynamic quantity;
//   dynamic gatepass_id;
//   dynamic unit;
//   dynamic from_warehouse_list;
//   dynamic showExtraFields;
//   dynamic description;
//   dynamic issued_by;
//   dynamic amount;
//
//   GatePassByID({
//     this.issued_to,
//     this.to_project_list,
//     this.from_warehouse,
//     this.date,
//     this.vehicle_no,
//     this.gate_pass,
//     this.out_time,
//     this.to_warehouse,
//     this.scrap,
//     this.current_balance,
//     this.issued_material,
//     this.transfer_type,
//     this.balance,
//     this.rate,
//     this.used_quantity,
//     this.quantity,
//     this.gatepass_id,
//     this.unit,
//     this.from_warehouse_list,
//     this.showExtraFields,
//     this.description,
//     this.issued_by,
//     this.amount,
//   });
//
//   factory GatePassByID.fromJson(Map<String, dynamic> json) => _$GatePassByIDFromJson(json);
//
//   Map<String, dynamic> toJson() => _$GatePassByIDToJson(this);
// }

import 'package:json_annotation/json_annotation.dart';

part 'GetGatePassByID.g.dart';

@JsonSerializable()
class GetGatePassByID {
  List<GatePassByID>? data;

  GetGatePassByID({
    this.data
  });

  factory GetGatePassByID.fromJson(Map<String, dynamic> json) => _$GetGatePassByIDFromJson(json);

  Map<String, dynamic> toJson() => _$GetGatePassByIDToJson(this);
}

@JsonSerializable()
class GatePassByID {
  dynamic from_warehouse_name;
  dynamic issued_to;
  dynamic from_warehouse;
  dynamic to_project_name;
  dynamic vehicle_no;
  dynamic out_time;
  dynamic issued_by_name;
  dynamic issued_material;
  dynamic transfer_type;
  dynamic subgroup_names;
  dynamic groupid;
  dynamic group_names;
  dynamic rate;
  dynamic sub_groupid;
  dynamic description;
  dynamic amount;
  dynamic issued_to_name;
  dynamic date;
  dynamic gate_pass;
  dynamic vehicle_name;
  dynamic to_warehouse;
  dynamic scrap;
  dynamic vehicle_number;
  dynamic current_balance;
  dynamic consumed;
  dynamic balance;
  dynamic to_warehouse_name;
  dynamic used_quantity;
  dynamic quantity;
  dynamic gatepass_id;
  dynamic unit;
  dynamic issued_by;
  dynamic to_project;

  GatePassByID({
    this.from_warehouse_name,
    this.issued_to,
    this.from_warehouse,
    this.to_project_name,
    this.vehicle_no,
    this.out_time,
    this.issued_by_name,
    this.issued_material,
    this.transfer_type,
    this.subgroup_names,
    this.groupid,
    this.group_names,
    this.rate,
    this.sub_groupid,
    this.description,
    this.amount,
    this.issued_to_name,
    this.date,
    this.gate_pass,
    this.vehicle_name,
    this.to_warehouse,
    this.scrap,
    this.vehicle_number,
    this.current_balance,
    this.consumed,
    this.balance,
    this.to_warehouse_name,
    this.used_quantity,
    this.quantity,
    this.gatepass_id,
    this.unit,
    this.issued_by,
    this.to_project,
  });

  factory GatePassByID.fromJson(Map<String, dynamic> json) => _$GatePassByIDFromJson(json);

  Map<String, dynamic> toJson() => _$GatePassByIDToJson(this);
}