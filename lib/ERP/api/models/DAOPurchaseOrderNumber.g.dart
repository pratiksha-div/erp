// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DAOPurchaseOrderNumber.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DAOPurchaseOrderNumber _$DAOPurchaseOrderNumberFromJson(
  Map<String, dynamic> json,
) => DAOPurchaseOrderNumber(
  code: json['code'] as String?,
  data:
      (json['data'] as List<dynamic>?)
          ?.map(
            (e) => PurchaseOrderNumberData.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
);

Map<String, dynamic> _$DAOPurchaseOrderNumberToJson(
  DAOPurchaseOrderNumber instance,
) => <String, dynamic>{'code': instance.code, 'data': instance.data};

PurchaseOrderNumberData _$PurchaseOrderNumberDataFromJson(
  Map<String, dynamic> json,
) => PurchaseOrderNumberData(
  purchase_order_number: json['purchase_order_number'] as String?,
);

Map<String, dynamic> _$PurchaseOrderNumberDataToJson(
  PurchaseOrderNumberData instance,
) => <String, dynamic>{'purchase_order_number': instance.purchase_order_number};
