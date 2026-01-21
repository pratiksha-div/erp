// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'GetMachineReadingByID.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetMachineReadingByID _$GetMachineReadingByIDFromJson(
  Map<String, dynamic> json,
) => GetMachineReadingByID(
  data:
      (json['data'] as List<dynamic>?)
          ?.map((e) => MachineReadingByID.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$GetMachineReadingByIDToJson(
  GetMachineReadingByID instance,
) => <String, dynamic>{'data': instance.data};

MachineReadingByID _$MachineReadingByIDFromJson(Map<String, dynamic> json) =>
    MachineReadingByID(
      notes: json['notes'],
      timeend: json['timeend'],
      readingdt: json['readingdt'],
      gate_pass_no: json['gate_pass_no'],
      expendedtime: json['expendedtime'],
      readingid: json['readingid'],
      readingstart: json['readingstart'],
      vehicleno: json['vehicleno'],
      vehicleid: json['vehicleid'],
      project_id: json['project_id'],
      readingend: json['readingend'],
      venderid: json['venderid'],
      timestart: json['timestart'],
      total_run: json['total_run'],
      amount: json['amount'],
    );

Map<String, dynamic> _$MachineReadingByIDToJson(MachineReadingByID instance) =>
    <String, dynamic>{
      'notes': instance.notes,
      'timeend': instance.timeend,
      'readingdt': instance.readingdt,
      'gate_pass_no': instance.gate_pass_no,
      'expendedtime': instance.expendedtime,
      'readingid': instance.readingid,
      'readingstart': instance.readingstart,
      'vehicleno': instance.vehicleno,
      'vehicleid': instance.vehicleid,
      'project_id': instance.project_id,
      'readingend': instance.readingend,
      'venderid': instance.venderid,
      'timestart': instance.timestart,
      'total_run': instance.total_run,
      'amount': instance.amount,
    };
