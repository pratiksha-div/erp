import 'package:json_annotation/json_annotation.dart';

part 'DAOMaterialConsumptionList.g.dart';

@JsonSerializable()
class DAOMaterialConsumptionList {

  List<MaterialConsumptionList>? data;

  DAOMaterialConsumptionList({
    this.data
  });

  factory DAOMaterialConsumptionList.fromJson(Map<String, dynamic> json) => _$DAOMaterialConsumptionListFromJson(json);

  Map<String, dynamic> toJson() => _$DAOMaterialConsumptionListToJson(this);
}

@JsonSerializable()
class MaterialConsumptionList {
  dynamic item;
  dynamic date;
  dynamic material_id;
  dynamic scrap;
  dynamic project_id;
  dynamic gatePass;
  dynamic rate;
  dynamic used_quantity;
  dynamic unit;
  dynamic consumption_id;
  dynamic total_amount;
  dynamic balance_quantity;
  dynamic project_name;
  dynamic user_id;

  MaterialConsumptionList({
    this.item,
    this.date,
    this.material_id,
    this.scrap,
    this.project_id,
    this.gatePass,
    this.rate,
    this.used_quantity,
    this.unit,
    this.consumption_id,
    this.total_amount,
    this.balance_quantity,
    this.project_name,
    this.user_id
  });

  factory MaterialConsumptionList.fromJson(Map<String, dynamic> json) => _$MaterialConsumptionListFromJson(json);

  Map<String, dynamic> toJson() => _$MaterialConsumptionListToJson(this);
}