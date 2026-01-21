import 'package:json_annotation/json_annotation.dart';

part 'GetMaterialConsumptionByID.g.dart';

@JsonSerializable()
class GetMaterialConsumptionByID {
  List<MaterialConsumptionByID>? data;

  GetMaterialConsumptionByID({
    this.data
  });

  factory GetMaterialConsumptionByID.fromJson(Map<String, dynamic> json) => _$GetMaterialConsumptionByIDFromJson(json);

  Map<String, dynamic> toJson() => _$GetMaterialConsumptionByIDToJson(this);
}

@JsonSerializable()
class MaterialConsumptionByID {
  dynamic item;
  dynamic date;
  dynamic material_id;
  dynamic used_qauntity;
  dynamic updated_by;
  dynamic scrap;
  dynamic updated_dt;
  dynamic gatePass;
  dynamic rate;
  dynamic unit;
  dynamic consumption_id;
  dynamic total_amount;
  dynamic balance_quantity;
  dynamic project_id;

  MaterialConsumptionByID({
    this.item,
    this.date,
    this.material_id,
    this.used_qauntity,
    this.updated_by,
    this.scrap,
    this.updated_dt,
    this.gatePass,
    this.rate,
    this.unit,
    this.consumption_id,
    this.total_amount,
    this.balance_quantity,
    this.project_id,
  });

  factory MaterialConsumptionByID.fromJson(Map<String, dynamic> json) => _$MaterialConsumptionByIDFromJson(json);

  Map<String, dynamic> toJson() => _$MaterialConsumptionByIDToJson(this);
}