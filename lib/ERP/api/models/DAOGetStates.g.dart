// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DAOGetStates.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DAOGetStates _$DAOGetStatesFromJson(Map<String, dynamic> json) => DAOGetStates(
  data:
      (json['data'] as List<dynamic>?)
          ?.map((e) => StatesData.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$DAOGetStatesToJson(DAOGetStates instance) =>
    <String, dynamic>{'data': instance.data};

StatesData _$StatesDataFromJson(Map<String, dynamic> json) => StatesData(
  state_name: json['state_name'] as String?,
  state_id: json['state_id'] as String?,
);

Map<String, dynamic> _$StatesDataToJson(StatesData instance) =>
    <String, dynamic>{
      'state_name': instance.state_name,
      'state_id': instance.state_id,
    };
