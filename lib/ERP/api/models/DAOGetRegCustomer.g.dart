// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DAOGetRegCustomer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DAOGetRegCustomer _$DAOGetRegCustomerFromJson(Map<String, dynamic> json) =>
    DAOGetRegCustomer(
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => RegCustomerData.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$DAOGetRegCustomerToJson(DAOGetRegCustomer instance) =>
    <String, dynamic>{'data': instance.data};

RegCustomerData _$RegCustomerDataFromJson(Map<String, dynamic> json) =>
    RegCustomerData(
      persons_id: json['persons_id'] as String?,
      ProductCode: json['ProductCode'] as String?,
      cust_name: json['cust_name'] as String?,
    );

Map<String, dynamic> _$RegCustomerDataToJson(RegCustomerData instance) =>
    <String, dynamic>{
      'persons_id': instance.persons_id,
      'ProductCode': instance.ProductCode,
      'cust_name': instance.cust_name,
    };
