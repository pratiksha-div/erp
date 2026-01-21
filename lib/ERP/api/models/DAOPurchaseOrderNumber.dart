import 'package:json_annotation/json_annotation.dart';

part 'DAOPurchaseOrderNumber.g.dart';

@JsonSerializable()
class DAOPurchaseOrderNumber {
  String? code;
  List<PurchaseOrderNumberData>? data;

  DAOPurchaseOrderNumber({
    this.code,
    this.data,
  });

  factory DAOPurchaseOrderNumber.fromJson(Map<String, dynamic> json) => _$DAOPurchaseOrderNumberFromJson(json);

  Map<String, dynamic> toJson() => _$DAOPurchaseOrderNumberToJson(this);
}

@JsonSerializable()
class PurchaseOrderNumberData {
  String? purchase_order_number;

  PurchaseOrderNumberData({
    this.purchase_order_number,
  });

  factory PurchaseOrderNumberData.fromJson(Map<String, dynamic> json) => _$PurchaseOrderNumberDataFromJson(json);

  Map<String, dynamic> toJson() => _$PurchaseOrderNumberDataToJson(this);
}