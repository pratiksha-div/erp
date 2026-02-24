import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../api/models/GetGatePassByID.dart';
import '../../api/services/add_gate_pass_service.dart';

// GatePassByIDEvent
abstract class GatePassByIDEvent extends Equatable {
  const GatePassByIDEvent();

  @override
  List<Object?> get props => [];
}

class FetchGatePassByIDEvent extends GatePassByIDEvent {
  final String gate_pass;
  final String date;

  const FetchGatePassByIDEvent({required this.gate_pass,required this.date});

  @override
  List<Object?> get props => [gate_pass,date];
}


// GatePassByIDState
abstract class GatePassByIDState extends Equatable {
  const GatePassByIDState();

  @override
  List<Object?> get props => [];
}

class GatePassByIDInitial extends GatePassByIDState {}

class GatePassByIDLoading extends GatePassByIDState {}

class GatePassByIDLoadSuccess extends GatePassByIDState {
  final List<GatePassByID> gatePassByID;

  const GatePassByIDLoadSuccess(this.gatePassByID);

  @override
  List<Object?> get props => [GatePassByID];
}

class GatePassByIDFailure extends GatePassByIDState {
  final String error;

  const GatePassByIDFailure(this.error);

  @override
  List<Object?> get props => [error];
}


// ********* Interface expected by the bloc *************//
abstract class GatePassByIDService {
  Future<String> fetchGatePassByIDRaw(String gatepass,String date);
}



/// Adapter that uses your existing EmployeeServices class
class GatePassByIDServiceAdapter implements GatePassByIDService {
  final GatePassDataByIDService _GatePassByIDService;

  GatePassByIDServiceAdapter({GatePassDataByIDService? GatePassByIDService})
      : _GatePassByIDService = GatePassByIDService ?? GatePassDataByIDService();

  @override
  Future<String> fetchGatePassByIDRaw(String gate_pass,String date) async {
    final result = await _GatePassByIDService.fetchGatePassDataByID(gate_pass,date);
    if (result is String) return result;
    try {
      return result != null ? result.toString() : '{}';
    } catch (_) {
      return '{}';
    }
  }

}



/// Bloc implementation
class GatePassByIDBloc extends Bloc<GatePassByIDEvent, GatePassByIDState> {
  final GatePassByIDService _service;

  GatePassByIDBloc({required GatePassByIDService service})
      : _service = service,
        super( GatePassByIDInitial()) {
    on<FetchGatePassByIDEvent>(_onFetchMaterialIssue);
  }

  Future<void> _onFetchMaterialIssue(
      FetchGatePassByIDEvent event, Emitter<GatePassByIDState> emit) async {
    emit( GatePassByIDLoading());

    try {
      final raw = await _service.fetchGatePassByIDRaw(event.gate_pass,event.date);

      // raw might already be a JSON string. If your service returns Map, adapt.
      final decoded = jsonDecode(raw);

      // Expecting the JSON shape: { "data": [ { "EmployeeId": "...", "EmployeeName": "..." }, ... ] }
      final data = decoded['data'];
      if (data == null || data is! List) {
        emit(const GatePassByIDFailure('Something went wrong, Please try again'));
        return;
      }

      final gatePassByID = data
          .map<GatePassByID>((e) => GatePassByID.fromJson(e as Map<String, dynamic>))
          .toList();

      emit(GatePassByIDLoadSuccess(gatePassByID));
    } catch (e) {
      emit(GatePassByIDFailure(e.toString()));
    }
  }
}