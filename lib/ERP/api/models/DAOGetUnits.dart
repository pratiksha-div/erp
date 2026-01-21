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

  UnitsData({
    this.unit_name,
    this.hsncode,
  });

  factory UnitsData.fromJson(Map<String, dynamic> json) => _$UnitsDataFromJson(json);

  Map<String, dynamic> toJson() => _$UnitsDataToJson(this);
}