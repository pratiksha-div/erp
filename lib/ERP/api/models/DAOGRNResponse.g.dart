// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DAOGRNResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DAOGRNResponse _$DAOGRNResponseFromJson(Map<String, dynamic> json) =>
    DAOGRNResponse(
      message: json['message'] as String?,
      grn_no: json['grn_no'] as String?,
      code: json['code'] as String?,
    );

Map<String, dynamic> _$DAOGRNResponseToJson(DAOGRNResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'grn_no': instance.grn_no,
      'code': instance.code,
    };
