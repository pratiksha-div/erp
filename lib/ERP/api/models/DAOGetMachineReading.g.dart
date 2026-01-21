// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DAOGetMachineReading.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DAOGetMachineReading _$DAOGetMachineReadingFromJson(
  Map<String, dynamic> json,
) => DAOGetMachineReading(
  data:
      (json['data'] as List<dynamic>?)
          ?.map((e) => MachineReadingData.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$DAOGetMachineReadingToJson(
  DAOGetMachineReading instance,
) => <String, dynamic>{'data': instance.data};

MachineReadingData _$MachineReadingDataFromJson(Map<String, dynamic> json) =>
    MachineReadingData(
      notes: json['notes'],
      vehiclename: json['vehiclename'],
      readingDt: json['readingDt'],
      gate_pass_no: json['gate_pass_no'],
      expendedtime: json['expendedtime'],
      vendorname: json['vendorname'],
      readingid: json['readingid'],
      vehicleno: json['vehicleno'],
      project_name: json['project_name'],
      timeend: json['timeend'],
      timestart: json['timestart'],
      readingstart: json['readingstart'],
      readingend: json['readingend'],
      total_run: json['total_run'],
      amount: json['amount'],
    );

Map<String, dynamic> _$MachineReadingDataToJson(MachineReadingData instance) =>
    <String, dynamic>{
      'notes': instance.notes,
      'vehiclename': instance.vehiclename,
      'readingDt': instance.readingDt,
      'gate_pass_no': instance.gate_pass_no,
      'expendedtime': instance.expendedtime,
      'vendorname': instance.vendorname,
      'readingid': instance.readingid,
      'vehicleno': instance.vehicleno,
      'project_name': instance.project_name,
      'timeend': instance.timeend,
      'timestart': instance.timestart,
      'readingstart': instance.readingstart,
      'readingend': instance.readingend,
      'total_run': instance.total_run,
      'amount': instance.amount,
    };
