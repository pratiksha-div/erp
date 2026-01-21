import 'package:json_annotation/json_annotation.dart';

part 'DAOGetWarehouse.g.dart';

@JsonSerializable()
class DAOGetWarehouse {
  List<WarehouseData>? data;

  DAOGetWarehouse({
    this.data
  });

  factory DAOGetWarehouse.fromJson(Map<String, dynamic> json) => _$DAOGetWarehouseFromJson(json);

  Map<String, dynamic> toJson() => _$DAOGetWarehouseToJson(this);
}

@JsonSerializable()
class WarehouseData {
  String? godown_name;
  String? godown_id;

  WarehouseData({
    this.godown_name,
    this.godown_id,
  });

  factory WarehouseData.fromJson(Map<String, dynamic> json) => _$WarehouseDataFromJson(json);

  Map<String, dynamic> toJson() => _$WarehouseDataToJson(this);
}