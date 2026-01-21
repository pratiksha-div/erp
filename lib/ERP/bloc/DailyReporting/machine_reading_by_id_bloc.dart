import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../api/models/DAOGetProject.dart';
import '../../api/models/GetMachineReadingByID.dart';
import '../../api/services/add_machine_reading_service.dart';

// MachineReadingByIDEvent
abstract class MachineReadingByIDEvent extends Equatable {
  const MachineReadingByIDEvent();

  @override
  List<Object?> get props => [];
}

class FetchMachineReadingByIDEvent extends MachineReadingByIDEvent {
  final String readingid;

  const FetchMachineReadingByIDEvent({required this.readingid});

  @override
  List<Object?> get props => [readingid];
}


// MachineReadingByIDState
abstract class MachineReadingByIDState extends Equatable {
  const MachineReadingByIDState();

  @override
  List<Object?> get props => [];
}

class MachineReadingByIDInitial extends MachineReadingByIDState {}

class MachineReadingByIDLoading extends MachineReadingByIDState {}

class MachineReadingByIDLoadSuccess extends MachineReadingByIDState {
  final List<MachineReadingByID> machineReadingByID;

  const MachineReadingByIDLoadSuccess(this.machineReadingByID);

  @override
  List<Object?> get props => [MachineReadingByID];
}

class MachineReadingByIDFailure extends MachineReadingByIDState {
  final String error;

  const MachineReadingByIDFailure(this.error);

  @override
  List<Object?> get props => [error];
}


// ********* Interface expected by the bloc *************//
abstract class MachineReadingByIDService {
  Future<String> fetchMachineReadingByIDRaw(String godownId);
}



/// Adapter that uses your existing EmployeeServices class
class MachineReadingByIDServiceAdapter implements MachineReadingByIDService {
  final GetMachineReadingByIDService _MachineReadingByIDService;

  MachineReadingByIDServiceAdapter({GetMachineReadingByIDService? MachineReadingByIDService})
      : _MachineReadingByIDService = MachineReadingByIDService ?? GetMachineReadingByIDService();

  @override
  Future<String> fetchMachineReadingByIDRaw(String Id) async {
    final result = await _MachineReadingByIDService.fetchMachineRedaingDataByID(Id);
    if (result is String) return result;
    try {
      return result != null ? result.toString() : '{}';
    } catch (_) {
      return '{}';
    }
  }

}



/// Bloc implementation
class MachineReadingByIDBloc extends Bloc<MachineReadingByIDEvent, MachineReadingByIDState> {
  final MachineReadingByIDService _service;

  MachineReadingByIDBloc({required MachineReadingByIDService service})
      : _service = service,
        super( MachineReadingByIDInitial()) {
    on<FetchMachineReadingByIDEvent>(_onFetchMaterialIssue);
  }

  Future<void> _onFetchMaterialIssue(
      FetchMachineReadingByIDEvent event, Emitter<MachineReadingByIDState> emit) async {
    emit( MachineReadingByIDLoading());

    try {
      final raw = await _service.fetchMachineReadingByIDRaw(event.readingid);

      // raw might already be a JSON string. If your service returns Map, adapt.
      final decoded = jsonDecode(raw);

      // Expecting the JSON shape: { "data": [ { "EmployeeId": "...", "EmployeeName": "..." }, ... ] }
      final data = decoded['data'];
      if (data == null || data is! List) {
        emit(const MachineReadingByIDFailure('Something went wrong, Please try again'));
        return;
      }

      final machineReadingByID = data
          .map<MachineReadingByID>((e) => MachineReadingByID.fromJson(e as Map<String, dynamic>))
          .toList();

      emit(MachineReadingByIDLoadSuccess(machineReadingByID));
    } catch (e) {
      emit(MachineReadingByIDFailure(e.toString()));
    }
  }
}