import 'package:json_annotation/json_annotation.dart';

part 'DAOGetPurchaseOrderDetail.g.dart';

@JsonSerializable()
class DAOGetPurchaseOrderDetail {
  List<PurchaseDetail>? data;

  DAOGetPurchaseOrderDetail({
    this.data
  });

  factory DAOGetPurchaseOrderDetail.fromJson(Map<String, dynamic> json) => _$DAOGetPurchaseOrderDetailFromJson(json);

  Map<String, dynamic> toJson() => _$DAOGetPurchaseOrderDetailToJson(this);
}

@JsonSerializable()
class PurchaseDetail {
  String? vendor_name;
  String? item_name;
  String? to_warehouse;
  String? ordered_by;
  String? quantity;
  String? item_id;
  String? group_id;
  String? sub_group_id;
  String? company_name;
  String? unit;
  String? to_warehouse_id;
  String? po_balance;
  String? project_id;
  String? rate;
  String? grand_total;

  PurchaseDetail({
    this.vendor_name,
    this.item_name,
    this.to_warehouse,
    this.ordered_by,
    this.quantity,
    this.item_id,
    this.group_id,
    this.sub_group_id,
    this.company_name,
    this.unit,
    this.to_warehouse_id,
    this.po_balance,
    this.project_id,
    this.grand_total
  });

  factory PurchaseDetail.fromJson(Map<String, dynamic> json) => _$PurchaseDetailFromJson(json);

  Map<String, dynamic> toJson() => _$PurchaseDetailToJson(this);
}