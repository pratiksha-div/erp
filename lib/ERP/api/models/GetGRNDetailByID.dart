import 'package:json_annotation/json_annotation.dart';
part 'GetGRNDetailByID.g.dart';

@JsonSerializable()
class GetGRNDetailByID {
  List<GRNDetailByIDData>? data;

  GetGRNDetailByID({
    this.data
  });

  factory GetGRNDetailByID.fromJson(Map<String, dynamic> json) => _$GetGRNDetailByIDFromJson(json);

  Map<String, dynamic> toJson() => _$GetGRNDetailByIDToJson(this);
}

@JsonSerializable()
class GRNDetailByIDData {
  dynamic accepted_qty;
  dynamic amount;
  dynamic bill_no;
  dynamic challan_no;
  dynamic contact;
  dynamic discount;
  dynamic excess_qty;
  dynamic from_vendor;
  dynamic gate_entry_no;
  dynamic gen_id;
  dynamic gen_no;
  dynamic grn_date;
  dynamic grn_id;
  dynamic grn_no;
  dynamic item_name;
  dynamic po_balance;
  dynamic po_no;
  dynamic quantity;
  dynamic rate;
  dynamic received_qty;
  dynamic rejected_qty;
  dynamic requested_by;
  dynamic short_qty;
  dynamic to_warehouse;
  dynamic vehicle_no;

  GRNDetailByIDData({
      this.accepted_qty,
      this.amount,
      this.bill_no,
      this.challan_no,
      this.contact,
      this.discount,
      this.excess_qty,
      this.from_vendor,
      this.gate_entry_no,
      this.gen_id,
      this.gen_no,
      this.grn_date,
      this.grn_id,
      this.grn_no,
      this.item_name,
      this.po_balance,
      this.po_no,
      this.quantity,
      this.rate,
      this.received_qty,
      this.rejected_qty,
      this.requested_by,
      this.short_qty,
      this.to_warehouse,
      this.vehicle_no,
  });

  factory GRNDetailByIDData.fromJson(Map<String, dynamic> json) => _$GRNDetailByIDDataFromJson(json);

  Map<String, dynamic> toJson() => _$GRNDetailByIDDataToJson(this);
}