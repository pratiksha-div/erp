// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'GetEntryByID.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetEntryByID _$GetEntryByIDFromJson(Map<String, dynamic> json) => GetEntryByID(
  data:
      (json['data'] as List<dynamic>?)
          ?.map((e) => EntryByID.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$GetEntryByIDToJson(GetEntryByID instance) =>
    <String, dynamic>{'data': instance.data};

EntryByID _$EntryByIDFromJson(Map<String, dynamic> json) => EntryByID(
  employeetype: json['employeetype'],
  employeetypename: json['employeetypename'],
  notes: json['notes'],
  work_detail_id: json['work_detail_id'],
  entryDate: json['entryDate'],
  project_id: json['project_id'],
  employeename: json['employeename'],
  projectName: json['projectName'],
  empName: json['empName'],
  empId: json['empId'],
);

Map<String, dynamic> _$EntryByIDToJson(EntryByID instance) => <String, dynamic>{
  'employeetype': instance.employeetype,
  'employeetypename': instance.employeetypename,
  'notes': instance.notes,
  'work_detail_id': instance.work_detail_id,
  'entryDate': instance.entryDate,
  'project_id': instance.project_id,
  'employeename': instance.employeename,
  'projectName': instance.projectName,
  'empName': instance.empName,
  'empId': instance.empId,
};
