import 'package:json_annotation/json_annotation.dart';

part 'DAOGetGENDetail.g.dart';

@JsonSerializable()
class DAOGetGENDetail {
  List<GENData>? data;

  DAOGetGENDetail({this.data});

  factory DAOGetGENDetail.fromJson(Map<String, dynamic> json) =>
      _$DAOGetGENDetailFromJson(json);

  Map<String, dynamic> toJson() => _$DAOGetGENDetailToJson(this);
}

@JsonSerializable()
class GENData {
  dynamic contact;
  dynamic item_id;
  dynamic company_name;
  dynamic from_vendor;
  dynamic group_id;
  dynamic vehicle_no;
  dynamic item_name;
  dynamic to_warehouse;
  dynamic ordered_by;
  dynamic to_warehouse_id;
  dynamic bill_no;
  dynamic challan_no;
  dynamic selected_po;
  dynamic sub_group_id;
  dynamic quantity;
  dynamic unit;
  dynamic requested_by_name;
  dynamic rate;
  dynamic grand_total;
  dynamic item_description;

  GENData(
      {
         this.contact,
         this.item_id,
         this.company_name,
         this.from_vendor,
         this.group_id,
         this.vehicle_no,
         this.item_name,
         this.to_warehouse,
         this.ordered_by,
         this.to_warehouse_id,
         this.bill_no,
         this.challan_no,
         this.selected_po,
         this.sub_group_id,
         this.quantity,
         this.unit,
         this.requested_by_name,
         this.rate,
         this.grand_total,
         this.item_description
      });

  factory GENData.fromJson(Map<String, dynamic> json) =>
      _$GENDataFromJson(json);

  Map<String, dynamic> toJson() => _$GENDataToJson(this);
}
