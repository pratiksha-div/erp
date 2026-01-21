import 'package:json_annotation/json_annotation.dart';

part 'DAOGetVehicleName.g.dart';

@JsonSerializable()
class DAOGetVehicleName {
  List<VehicleData>? data;

  DAOGetVehicleName({
    this.data
  });

  factory DAOGetVehicleName.fromJson(Map<String, dynamic> json) => _$DAOGetVehicleNameFromJson(json);

  Map<String, dynamic> toJson() => _$DAOGetVehicleNameToJson(this);
}

@JsonSerializable()
class VehicleData {
  String? VehicleName;
  String? VehicleNo;
  String? VehicleID;

  VehicleData({
    this.VehicleName,
    this.VehicleNo,
    this.VehicleID,
  });

  factory VehicleData.fromJson(Map<String, dynamic> json) => _$VehicleDataFromJson(json);

  Map<String, dynamic> toJson() => _$VehicleDataToJson(this);
}