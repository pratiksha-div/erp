// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DAOStatus.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DAOStatus _$DAOStatusFromJson(Map<String, dynamic> json) => DAOStatus(
  data:
      (json['data'] as List<dynamic>?)
          ?.map((e) => StatusData.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$DAOStatusToJson(DAOStatus instance) => <String, dynamic>{
  'data': instance.data,
};

StatusData _$StatusDataFromJson(Map<String, dynamic> json) => StatusData(
  LookupValue: json['LookupValue'] as String?,
  LookupDataId: json['LookupDataId'] as String?,
);

Map<String, dynamic> _$StatusDataToJson(StatusData instance) =>
    <String, dynamic>{
      'LookupValue': instance.LookupValue,
      'LookupDataId': instance.LookupDataId,
    };
