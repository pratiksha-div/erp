import 'package:json_annotation/json_annotation.dart';

part 'GetMachineReadingByID.g.dart';

@JsonSerializable()
class GetMachineReadingByID {
  List<MachineReadingByID>? data;

  GetMachineReadingByID({
    this.data
  });

  factory GetMachineReadingByID.fromJson(Map<String, dynamic> json) => _$GetMachineReadingByIDFromJson(json);

  Map<String, dynamic> toJson() => _$GetMachineReadingByIDToJson(this);
}

@JsonSerializable()
class MachineReadingByID {
  dynamic notes;
  dynamic timeend;
  dynamic readingdt;
  dynamic gate_pass_no;
  dynamic expendedtime;
  dynamic readingid;
  dynamic readingstart;
  dynamic vehicleno;
  dynamic vehicleid;
  dynamic project_id;
  dynamic readingend;
  dynamic venderid;
  dynamic timestart;
  dynamic total_run;
  dynamic amount;

  MachineReadingByID({
    this.notes,
    this.timeend,
    this.readingdt,
    this.gate_pass_no,
    this.expendedtime,
    this.readingid,
    this.readingstart,
    this.vehicleno,
    this.vehicleid,
    this.project_id,
    this.readingend,
    this.venderid,
    this.timestart,
    this.total_run,
    this.amount,
  });

  factory MachineReadingByID.fromJson(Map<String, dynamic> json) => _$MachineReadingByIDFromJson(json);

  Map<String, dynamic> toJson() => _$MachineReadingByIDToJson(this);
}