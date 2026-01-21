// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DAOGetMaterialConsumption.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DAOGetMaterialConsumption _$DAOGetMaterialConsumptionFromJson(
  Map<String, dynamic> json,
) => DAOGetMaterialConsumption(
  data:
      (json['data'] as List<dynamic>?)
          ?.map(
            (e) =>
                MaterialConsumptionUsedData.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
);

Map<String, dynamic> _$DAOGetMaterialConsumptionToJson(
  DAOGetMaterialConsumption instance,
) => <String, dynamic>{'data': instance.data};

MaterialConsumptionUsedData _$MaterialConsumptionUsedDataFromJson(
  Map<String, dynamic> json,
) => MaterialConsumptionUsedData(
  material_id: json['material_id'] as String?,
  material_used: json['material_used'] as String?,
  balance: json['balance'] as String?,
  unit: json['unit'] as String?,
);

Map<String, dynamic> _$MaterialConsumptionUsedDataToJson(
  MaterialConsumptionUsedData instance,
) => <String, dynamic>{
  'material_id': instance.material_id,
  'material_used': instance.material_used,
  'balance': instance.balance,
  'unit': instance.unit,
};
