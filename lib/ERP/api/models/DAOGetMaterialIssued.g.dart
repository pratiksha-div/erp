// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DAOGetMaterialIssued.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DAOGetMaterialIssued _$DAOGetMaterialIssuedFromJson(
  Map<String, dynamic> json,
) => DAOGetMaterialIssued(
  data:
      (json['data'] as List<dynamic>?)
          ?.map((e) => MaterialIssuedData.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$DAOGetMaterialIssuedToJson(
  DAOGetMaterialIssued instance,
) => <String, dynamic>{'data': instance.data};

MaterialIssuedData _$MaterialIssuedDataFromJson(Map<String, dynamic> json) =>
    MaterialIssuedData(
      item_id: json['item_id'],
      item: json['item'],
      current_balance: json['current_balance'],
      groupid: json['groupid'],
      subgroupname: json['subgroupname'],
      groupname: json['groupname'],
      subgroupid: json['subgroupid'],
    );

Map<String, dynamic> _$MaterialIssuedDataToJson(MaterialIssuedData instance) =>
    <String, dynamic>{
      'item_id': instance.item_id,
      'item': instance.item,
      'current_balance': instance.current_balance,
      'groupid': instance.groupid,
      'subgroupname': instance.subgroupname,
      'groupname': instance.groupname,
      'subgroupid': instance.subgroupid,
    };
