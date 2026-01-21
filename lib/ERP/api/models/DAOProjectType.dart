import 'package:json_annotation/json_annotation.dart';

part 'DAOProjectType.g.dart';

@JsonSerializable()
class DAOProjectType {
  List<ProjectTypeData>? data;

  DAOProjectType({
    this.data
  });

  factory DAOProjectType.fromJson(Map<String, dynamic> json) => _$DAOProjectTypeFromJson(json);

  Map<String, dynamic> toJson() => _$DAOProjectTypeToJson(this);
}

@JsonSerializable()
class ProjectTypeData {
  String? LookupValue;
  String? LookupDataId;

  ProjectTypeData({
    this.LookupValue,
    this.LookupDataId,
  });

  factory ProjectTypeData.fromJson(Map<String, dynamic> json) => _$ProjectTypeDataFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectTypeDataToJson(this);
}