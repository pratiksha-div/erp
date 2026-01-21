import 'package:json_annotation/json_annotation.dart';

part 'DAOGetGRN.g.dart';

@JsonSerializable()
class DAOGetGRN {

  List<GRNData>? data;

  DAOGetGRN({
    this.data
  });

  factory DAOGetGRN.fromJson(Map<String, dynamic> json) => _$DAOGetGRNFromJson(json);

  Map<String, dynamic> toJson() => _$DAOGetGRNToJson(this);
}

@JsonSerializable()
class GRNData {
  dynamic from_vendor;
  dynamic vehicle_no;
  dynamic item_name;
  dynamic gate_entry_no;
  dynamic grn_no;
  dynamic grn_date;
  dynamic grn_id;
  dynamic gen_no;
  dynamic accepted_qty;
  dynamic requested_by;
  dynamic po_no;

  GRNData({
    this.from_vendor,
    this.vehicle_no,
    this.item_name,
    this.gate_entry_no,
    this.grn_no,
    this.grn_date,
    this.grn_id,
    this.gen_no,
    this.accepted_qty,
    this.requested_by,
    this.po_no,
  });

  factory GRNData.fromJson(Map<String, dynamic> json) => _$GRNDataFromJson(json);

  Map<String, dynamic> toJson() => _$GRNDataToJson(this);
}