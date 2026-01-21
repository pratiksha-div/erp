import 'package:json_annotation/json_annotation.dart';

part 'DAOGetGateEntry.g.dart';

@JsonSerializable()
class DAOGetGateEntry {
  List<GateEntryData>? data;

  DAOGetGateEntry({
    this.data
  });

  factory DAOGetGateEntry.fromJson(Map<String, dynamic> json) => _$DAOGetGateEntryFromJson(json);

  Map<String, dynamic> toJson() => _$DAOGetGateEntryToJson(this);
}

@JsonSerializable()
class GateEntryData {
  dynamic from_vendor;
  dynamic vehicle_no;
  dynamic item_name;
  dynamic to_warehouse;
  dynamic gate_entry_id;
  dynamic ordered_by;
  dynamic bill_no;
  dynamic challan_no;
  dynamic selected_po;
  dynamic gen_no;
  dynamic quantity;

  GateEntryData({
    this.from_vendor,
    this.vehicle_no,
    this.item_name,
    this.to_warehouse,
    this.gate_entry_id,
    this.ordered_by,
    this.bill_no,
    this.challan_no,
    this.selected_po,
    this.gen_no,
    this.quantity,
  });

  factory GateEntryData.fromJson(Map<String, dynamic> json) => _$GateEntryDataFromJson(json);

  Map<String, dynamic> toJson() => _$GateEntryDataToJson(this);
}