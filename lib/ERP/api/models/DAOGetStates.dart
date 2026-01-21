import 'package:json_annotation/json_annotation.dart';

part 'DAOGetStates.g.dart';

@JsonSerializable()
class DAOGetStates {
  List<StatesData>? data;

  DAOGetStates({
    this.data
  });

  factory DAOGetStates.fromJson(Map<String, dynamic> json) => _$DAOGetStatesFromJson(json);

  Map<String, dynamic> toJson() => _$DAOGetStatesToJson(this);
}

@JsonSerializable()
class StatesData {
  String? state_name;
  String? state_id;

  StatesData({
    this.state_name,
    this.state_id,
  });

  factory StatesData.fromJson(Map<String, dynamic> json) => _$StatesDataFromJson(json);

  Map<String, dynamic> toJson() => _$StatesDataToJson(this);
}