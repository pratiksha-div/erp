import 'package:json_annotation/json_annotation.dart';

part 'DAOGetNewEntries.g.dart';

@JsonSerializable()
class DAOGetNewEntries {

  List<NewEntryData>? data;

  DAOGetNewEntries({
    this.data
  });

  factory DAOGetNewEntries.fromJson(Map<String, dynamic> json) => _$DAOGetNewEntriesFromJson(json);

  Map<String, dynamic> toJson() => _$DAOGetNewEntriesToJson(this);
}

@JsonSerializable()
class NewEntryData {
  dynamic lookupvalue;
  dynamic notes;
  dynamic empName;
  dynamic work_detail_id;
  dynamic entryDate;
  dynamic employeename;
  dynamic projectname;
  dynamic employeeid;
  dynamic user_id;

  NewEntryData({
    this.lookupvalue,
    this.notes,
    this.empName,
    this.work_detail_id,
    this.entryDate,
    this.employeename,
    this.projectname,
    this.employeeid,
    this.user_id
  });

  factory NewEntryData.fromJson(Map<String, dynamic> json) => _$NewEntryDataFromJson(json);

  Map<String, dynamic> toJson() => _$NewEntryDataToJson(this);
}