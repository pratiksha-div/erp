// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DAOGetPurchaseOrderDetail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DAOGetPurchaseOrderDetail _$DAOGetPurchaseOrderDetailFromJson(
  Map<String, dynamic> json,
) => DAOGetPurchaseOrderDetail(
  data:
      (json['data'] as List<dynamic>?)
          ?.map((e) => PurchaseDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$DAOGetPurchaseOrderDetailToJson(
  DAOGetPurchaseOrderDetail instance,
) => <String, dynamic>{'data': instance.data};

PurchaseDetail _$PurchaseDetailFromJson(Map<String, dynamic> json) =>
    PurchaseDetail(
      vendor_name: json['vendor_name'] as String?,
      item_name: json['item_name'] as String?,
      to_warehouse: json['to_warehouse'] as String?,
      ordered_by: json['ordered_by'] as String?,
      quantity: json['quantity'] as String?,
      item_id: json['item_id'] as String?,
      group_id: json['group_id'] as String?,
      sub_group_id: json['sub_group_id'] as String?,
      company_name: json['company_name'] as String?,
      unit: json['unit'] as String?,
      to_warehouse_id: json['to_warehouse_id'] as String?,
      po_balance: json['po_balance'] as String?,
      project_id: json['project_id'] as String?,
      grand_total: json['grand_total'] as String?,
      item_description: json['item_description'] as String?,
    )..rate = json['rate'] as String?;

Map<String, dynamic> _$PurchaseDetailToJson(PurchaseDetail instance) =>
    <String, dynamic>{
      'vendor_name': instance.vendor_name,
      'item_name': instance.item_name,
      'to_warehouse': instance.to_warehouse,
      'ordered_by': instance.ordered_by,
      'quantity': instance.quantity,
      'item_id': instance.item_id,
      'group_id': instance.group_id,
      'sub_group_id': instance.sub_group_id,
      'company_name': instance.company_name,
      'unit': instance.unit,
      'to_warehouse_id': instance.to_warehouse_id,
      'po_balance': instance.po_balance,
      'project_id': instance.project_id,
      'rate': instance.rate,
      'grand_total': instance.grand_total,
      'item_description': instance.item_description,
    };
