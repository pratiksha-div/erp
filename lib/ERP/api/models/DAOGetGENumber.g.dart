// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DAOGetGENumber.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DAOGetGENumber _$DAOGetGENumberFromJson(Map<String, dynamic> json) =>
    DAOGetGENumber(
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => GENumberData.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$DAOGetGENumberToJson(DAOGetGENumber instance) =>
    <String, dynamic>{'data': instance.data};

GENumberData _$GENumberDataFromJson(Map<String, dynamic> json) => GENumberData(
  gen_no: json['gen_no'] as String?,
  gen_id: json['gen_id'] as String?,
);

Map<String, dynamic> _$GENumberDataToJson(GENumberData instance) =>
    <String, dynamic>{'gen_no': instance.gen_no, 'gen_id': instance.gen_id};
