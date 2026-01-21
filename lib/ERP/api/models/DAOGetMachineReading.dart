import 'package:json_annotation/json_annotation.dart';

part 'DAOGetMachineReading.g.dart';

@JsonSerializable()
class DAOGetMachineReading {

  List<MachineReadingData>? data;

  DAOGetMachineReading({
    this.data
  });

  factory DAOGetMachineReading.fromJson(Map<String, dynamic> json) => _$DAOGetMachineReadingFromJson(json);

  Map<String, dynamic> toJson() => _$DAOGetMachineReadingToJson(this);
}

@JsonSerializable()
class MachineReadingData {
  dynamic notes;
  dynamic vehiclename;
  dynamic readingDt;
  dynamic gate_pass_no;
  dynamic expendedtime;
  dynamic vendorname;
  dynamic readingid;
  dynamic vehicleno;
  dynamic project_name;
  dynamic timeend;
  dynamic timestart;
  dynamic readingstart;
  dynamic readingend;
  dynamic total_run;
  dynamic amount;

  MachineReadingData({
    this.notes,
    this.vehiclename,
    this.readingDt,
    this.gate_pass_no,
    this.expendedtime,
    this.vendorname,
    this.readingid,
    this.vehicleno,
    this.project_name,
    this.timeend,
    this.timestart,
    this.readingstart,
    this.readingend,
    this.total_run,
    this.amount
  });

  factory MachineReadingData.fromJson(Map<String, dynamic> json) => _$MachineReadingDataFromJson(json);

  Map<String, dynamic> toJson() => _$MachineReadingDataToJson(this);
}