import 'package:json_annotation/json_annotation.dart';

part 'GetEntryByID.g.dart';

@JsonSerializable()
class GetEntryByID {
  List<EntryByID>? data;

  GetEntryByID({
    this.data
  });

  factory GetEntryByID.fromJson(Map<String, dynamic> json) => _$GetEntryByIDFromJson(json);

  Map<String, dynamic> toJson() => _$GetEntryByIDToJson(this);
}

@JsonSerializable()
class EntryByID {
  dynamic employeetype;
  dynamic employeetypename;
  dynamic notes;
  dynamic work_detail_id;
  dynamic entryDate;
  dynamic project_id;
  dynamic employeename;
  dynamic projectName;
  dynamic empName;

  EntryByID({
    this.employeetype,
    this.employeetypename,
    this.notes,
    this.work_detail_id,
    this.entryDate,
    this.project_id,
    this.employeename,
    this.projectName,
    this.empName,
  });

  factory EntryByID.fromJson(Map<String, dynamic> json) => _$EntryByIDFromJson(json);

  Map<String, dynamic> toJson() => _$EntryByIDToJson(this);
}