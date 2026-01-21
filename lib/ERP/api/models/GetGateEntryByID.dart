import 'package:json_annotation/json_annotation.dart';

part 'GetGateEntryByID.g.dart';

@JsonSerializable()
class GetGateEntryByID {
  List<GateEntryByID>? data;

  GetGateEntryByID({
    this.data
  });

  factory GetGateEntryByID.fromJson(Map<String, dynamic> json) => _$GetGateEntryByIDFromJson(json);

  Map<String, dynamic> toJson() => _$GetGateEntryByIDToJson(this);
}

@JsonSerializable()
class GateEntryByID {
  dynamic item_id;
  dynamic company_name;
  dynamic from_vendor;
  dynamic group_id;
  dynamic vehicle_no;
  dynamic bill_date;
  dynamic item_name;
  dynamic to_warehouse;
  dynamic gate_entry_id;
  dynamic to_warehouse_id;
  dynamic bill_no;
  dynamic challan_no;
  dynamic selected_po;
  dynamic gate_entry_date;
  dynamic gen_no;
  dynamic project_id;
  dynamic sub_group_id;
  dynamic quantity;

  GateEntryByID({
    this.item_id,
    this.company_name,
    this.from_vendor,
    this.group_id,
    this.vehicle_no,
    this.bill_date,
    this.item_name,
    this.to_warehouse,
    this.gate_entry_id,
    this.to_warehouse_id,
    this.bill_no,
    this.challan_no,
    this.selected_po,
    this.gate_entry_date,
    this.gen_no,
    this.project_id,
    this.sub_group_id,
    this.quantity,
  });

  factory GateEntryByID.fromJson(Map<String, dynamic> json) => _$GateEntryByIDFromJson(json);

  Map<String, dynamic> toJson() => _$GateEntryByIDToJson(this);
}