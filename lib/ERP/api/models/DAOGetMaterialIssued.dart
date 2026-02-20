import 'package:json_annotation/json_annotation.dart';

part 'DAOGetMaterialIssued.g.dart';

@JsonSerializable()
class DAOGetMaterialIssued {

  List<MaterialIssuedData>? data;

  DAOGetMaterialIssued({
    this.data
  });

  factory DAOGetMaterialIssued.fromJson(Map<String, dynamic> json) => _$DAOGetMaterialIssuedFromJson(json);

  Map<String, dynamic> toJson() => _$DAOGetMaterialIssuedToJson(this);
}

@JsonSerializable()
class MaterialIssuedData {
  dynamic item_id;
  dynamic item;
  dynamic current_balance;
  dynamic groupid;
  dynamic subgroupname;
  dynamic groupname;
  dynamic subgroupid;

  MaterialIssuedData({
    this.item_id,
    this.item,
    this.current_balance,
    this.groupid,
    this.subgroupname,
    this.groupname,
    this.subgroupid,

  });

  factory MaterialIssuedData.fromJson(Map<String, dynamic> json) => _$MaterialIssuedDataFromJson(json);

  Map<String, dynamic> toJson() => _$MaterialIssuedDataToJson(this);
}