import 'package:json_annotation/json_annotation.dart';

part 'DAOGRNResponse.g.dart';

@JsonSerializable()
class DAOGRNResponse {
  String? message;
  String? grn_no;
  String? code;

  DAOGRNResponse({
    this.message,
    this.grn_no,
    this.code,
  });

  factory DAOGRNResponse.fromJson(Map<String, dynamic> json) => _$DAOGRNResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DAOGRNResponseToJson(this);
}
