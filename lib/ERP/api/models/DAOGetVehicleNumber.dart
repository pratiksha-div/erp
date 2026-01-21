import 'package:json_annotation/json_annotation.dart';

part 'DAOGetVehicleNumber.g.dart';

@JsonSerializable()
class DAOGetVehicleNumber {
  List<VehicleNumberData>? data;

  DAOGetVehicleNumber({
    this.data
  });

  factory DAOGetVehicleNumber.fromJson(Map<String, dynamic> json) => _$DAOGetVehicleNumberFromJson(json);

  Map<String, dynamic> toJson() => _$DAOGetVehicleNumberToJson(this);
}

@JsonSerializable()
class VehicleNumberData {
  String? VehicleName;
  String? VehicleNo;
  String? VehicleID;

  VehicleNumberData({
    this.VehicleName,
    this.VehicleNo,
    this.VehicleID,
  });

  factory VehicleNumberData.fromJson(Map<String, dynamic> json) => _$VehicleNumberDataFromJson(json);

  Map<String, dynamic> toJson() => _$VehicleNumberDataToJson(this);
}