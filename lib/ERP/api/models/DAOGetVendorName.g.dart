// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DAOGetVendorName.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DAOGetVendorName _$DAOGetVendorNameFromJson(Map<String, dynamic> json) =>
    DAOGetVendorName(
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => VendorData.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$DAOGetVendorNameToJson(DAOGetVendorName instance) =>
    <String, dynamic>{'data': instance.data};

VendorData _$VendorDataFromJson(Map<String, dynamic> json) => VendorData(
  contractorId: json['contractorId'] as String?,
  contractorName: json['contractorName'] as String?,
);

Map<String, dynamic> _$VendorDataToJson(VendorData instance) =>
    <String, dynamic>{
      'contractorId': instance.contractorId,
      'contractorName': instance.contractorName,
    };
