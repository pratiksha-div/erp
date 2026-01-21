// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DAOGetNewEntries.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DAOGetNewEntries _$DAOGetNewEntriesFromJson(Map<String, dynamic> json) =>
    DAOGetNewEntries(
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => NewEntryData.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$DAOGetNewEntriesToJson(DAOGetNewEntries instance) =>
    <String, dynamic>{'data': instance.data};

NewEntryData _$NewEntryDataFromJson(Map<String, dynamic> json) => NewEntryData(
  lookupvalue: json['lookupvalue'],
  notes: json['notes'],
  empName: json['empName'],
  work_detail_id: json['work_detail_id'],
  entryDate: json['entryDate'],
  employeename: json['employeename'],
  projectname: json['projectname'],
);

Map<String, dynamic> _$NewEntryDataToJson(NewEntryData instance) =>
    <String, dynamic>{
      'lookupvalue': instance.lookupvalue,
      'notes': instance.notes,
      'empName': instance.empName,
      'work_detail_id': instance.work_detail_id,
      'entryDate': instance.entryDate,
      'employeename': instance.employeename,
      'projectname': instance.projectname,
    };
