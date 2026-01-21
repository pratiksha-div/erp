import 'package:json_annotation/json_annotation.dart';

part 'DAOGetVendorName.g.dart';

@JsonSerializable()
class DAOGetVendorName {
  List<VendorData>? data;

  DAOGetVendorName({
    this.data
  });

  factory DAOGetVendorName.fromJson(Map<String, dynamic> json) => _$DAOGetVendorNameFromJson(json);

  Map<String, dynamic> toJson() => _$DAOGetVendorNameToJson(this);
}

@JsonSerializable()
class VendorData {
  String? contractorId;
  String? contractorName;

  VendorData({
    this.contractorId,
    this.contractorName,
  });

  factory VendorData.fromJson(Map<String, dynamic> json) => _$VendorDataFromJson(json);

  Map<String, dynamic> toJson() => _$VendorDataToJson(this);
}