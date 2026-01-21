import 'package:json_annotation/json_annotation.dart';

part 'DAOGetMaterialConsumption.g.dart';

@JsonSerializable()
class DAOGetMaterialConsumption {

  List<MaterialConsumptionUsedData>? data;

  DAOGetMaterialConsumption({
    this.data
  });

  factory DAOGetMaterialConsumption.fromJson(Map<String, dynamic> json) => _$DAOGetMaterialConsumptionFromJson(json);

  Map<String, dynamic> toJson() => _$DAOGetMaterialConsumptionToJson(this);
}

@JsonSerializable()
class MaterialConsumptionUsedData {
  String? material_id;
  String? material_used;
  String? balance;
  String? unit;

  MaterialConsumptionUsedData({
    this.material_id,
    this.material_used,
    this.balance,
    this.unit

  });

  factory MaterialConsumptionUsedData.fromJson(Map<String, dynamic> json) => _$MaterialConsumptionUsedDataFromJson(json);

  Map<String, dynamic> toJson() => _$MaterialConsumptionUsedDataToJson(this);
}