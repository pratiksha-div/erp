import 'package:json_annotation/json_annotation.dart';

part 'DAOGetVehicleNo.g.dart';

@JsonSerializable()
class DAOGetVehicleNo {
  List<VehicleNoData>? data;

  DAOGetVehicleNo({
    this.data
  });

  factory DAOGetVehicleNo.fromJson(Map<String, dynamic> json) => _$DAOGetVehicleNoFromJson(json);

  Map<String, dynamic> toJson() => _$DAOGetVehicleNoToJson(this);
}

@JsonSerializable()
class VehicleNoData {
  String? vehiclename;
  String? vehicleno;
  String? vehicleid;

  VehicleNoData({
    this.vehiclename,
    this.vehicleno,
    this.vehicleid,
  });

  factory VehicleNoData.fromJson(Map<String, dynamic> json) => _$VehicleNoDataFromJson(json);

  Map<String, dynamic> toJson() => _$VehicleNoDataToJson(this);
}