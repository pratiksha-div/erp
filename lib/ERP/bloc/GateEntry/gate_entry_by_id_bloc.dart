import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../api/models/GetGateEntryByID.dart';
import '../../api/services/add_gate_pass_service.dart';
import '../../api/services/gate_entry_service.dart';

// GateEntryBYIDEvent
abstract class GateEntryBYIDEvent extends Equatable {
  const GateEntryBYIDEvent();

  @override
  List<Object?> get props => [];
}

class FetchGateEntryBYIDEvent extends GateEntryBYIDEvent {
  final String gate_entry_id;

  const FetchGateEntryBYIDEvent({required this.gate_entry_id});

  @override
  List<Object?> get props => [gate_entry_id];
}


// GateEntryBYIDState
abstract class GateEntryBYIDState extends Equatable {
  const GateEntryBYIDState();

  @override
  List<Object?> get props => [];
}

class GateEntryBYIDInitial extends GateEntryBYIDState {}

class GateEntryBYIDLoading extends GateEntryBYIDState {}

class GateEntryBYIDLoadSuccess extends GateEntryBYIDState {
  final List<GateEntryByID> gateEntryBYID;

  const GateEntryBYIDLoadSuccess(this.gateEntryBYID);

  @override
  List<Object?> get props => [gateEntryBYID];
}

class GateEntryBYIDFailure extends GateEntryBYIDState {
  final String error;

  const GateEntryBYIDFailure(this.error);

  @override
  List<Object?> get props => [error];
}


// ********* Interface expected by the bloc *************//
abstract class GateEntryBYIDService {
  Future<String> fetchGateEntryBYIDRaw(String id);
}

/// Adapter that uses your existing EmployeeServices class
class GateEntryBYIDServiceAdapter implements GateEntryBYIDService {
  final GateEntryByIDService _GateEntryBYIDService;

  GateEntryBYIDServiceAdapter({GateEntryByIDService? GateEntryBYIDService})
      : _GateEntryBYIDService = GateEntryBYIDService ?? GateEntryByIDService();

  @override
  Future<String> fetchGateEntryBYIDRaw(String Id) async {
    final result = await _GateEntryBYIDService.fetchEntryByID(Id);
    if (result is String) return result;
    try {
      return result != null ? result.toString() : '{}';
    } catch (_) {
      return '{}';
    }
  }

}

/// Bloc implementation
class GateEntryBYIDBloc extends Bloc<GateEntryBYIDEvent, GateEntryBYIDState> {
  final GateEntryBYIDService _service;

  GateEntryBYIDBloc({required GateEntryBYIDService service})
      : _service = service,
        super( GateEntryBYIDInitial()) {
    on<FetchGateEntryBYIDEvent>(_onFetchGateEntryID);
  }

  Future<void> _onFetchGateEntryID(
      FetchGateEntryBYIDEvent event, Emitter<GateEntryBYIDState> emit) async {
    emit( GateEntryBYIDLoading());

    try {
      final raw = await _service.fetchGateEntryBYIDRaw(event.gate_entry_id);

      // raw might already be a JSON string. If your service returns Map, adapt.
      final decoded = jsonDecode(raw);

      // Expecting the JSON shape: { "data": [ { "EmployeeId": "...", "EmployeeName": "..." }, ... ] }
      final data = decoded['data'];
      if (data == null || data is! List) {
        emit(const GateEntryBYIDFailure('Something went wrong, Please try again'));
        return;
      }

      final gateEntryBYID = data
          .map<GateEntryByID>((e) => GateEntryByID.fromJson(e as Map<String, dynamic>))
          .toList();

      emit(GateEntryBYIDLoadSuccess(gateEntryBYID));
    } catch (e) {
      emit(GateEntryBYIDFailure(e.toString()));
    }
  }
}