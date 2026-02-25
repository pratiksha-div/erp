import 'package:json_annotation/json_annotation.dart';

part 'DAOGetUnits.g.dart';

@JsonSerializable()
class DAOGetUnits {
  List<UnitsData>? data;

  DAOGetUnits({
    this.data
  });

  factory DAOGetUnits.fromJson(Map<String, dynamic> json) => _$DAOGetUnitsFromJson(json);

  Map<String, dynamic> toJson() => _$DAOGetUnitsToJson(this);
}

@JsonSerializable()
class UnitsData {
  String? unit_name;
  String? hsncode;
  String? basic_unit_name;
  String? basic_value;
  String? alt_unit_name;
  String? alt_value;

  UnitsData({
    this.unit_name,
    this.hsncode,
    this.basic_unit_name,
    this.basic_value,
    this.alt_unit_name,
    this.alt_value
  });

  factory UnitsData.fromJson(Map<String, dynamic> json) => _$UnitsDataFromJson(json);

  Map<String, dynamic> toJson() => _$UnitsDataToJson(this);
}