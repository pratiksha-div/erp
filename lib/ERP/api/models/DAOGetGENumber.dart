import 'package:json_annotation/json_annotation.dart';

part 'DAOGetGENumber.g.dart';

@JsonSerializable()
class DAOGetGENumber {
  List<GENumberData>? data;

  DAOGetGENumber({
    this.data
  });

  factory DAOGetGENumber.fromJson(Map<String, dynamic> json) => _$DAOGetGENumberFromJson(json);

  Map<String, dynamic> toJson() => _$DAOGetGENumberToJson(this);
}

@JsonSerializable()
class GENumberData {
  String? gen_no;
  String? gen_id;

  GENumberData({
    this.gen_no,
    this.gen_id,
  });

  factory GENumberData.fromJson(Map<String, dynamic> json) => _$GENumberDataFromJson(json);

  Map<String, dynamic> toJson() => _$GENumberDataToJson(this);
}