import 'package:json_annotation/json_annotation.dart';

part 'DAOGetRegCustomer.g.dart';

@JsonSerializable()
class DAOGetRegCustomer {
  List<RegCustomerData>? data;

  DAOGetRegCustomer({
    this.data
  });

  factory DAOGetRegCustomer.fromJson(Map<String, dynamic> json) => _$DAOGetRegCustomerFromJson(json);

  Map<String, dynamic> toJson() => _$DAOGetRegCustomerToJson(this);
}

@JsonSerializable()
class RegCustomerData {
  String? persons_id;
  String? ProductCode;
  String? cust_name;

  RegCustomerData({
    this.persons_id,
    this.ProductCode,
    this.cust_name,
  });

  factory RegCustomerData.fromJson(Map<String, dynamic> json) => _$RegCustomerDataFromJson(json);

  Map<String, dynamic> toJson() => _$RegCustomerDataToJson(this);
}