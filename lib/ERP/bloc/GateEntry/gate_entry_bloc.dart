import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'dart:convert';
import '../../api/models/DAOGetGateEntry.dart';
import '../../api/services/gate_entry_service.dart';

//event
abstract class GateEntryEvent extends Equatable {
  const GateEntryEvent();

  @override
  List<Object?> get props => [];
}

/// Trigger fetching GateEntry with pagination
class FetchGateEntryEvent extends GateEntryEvent {
  final int start;
  final int length;
  final String gateEntry;
  final String vehicleNo;
  final String toWarehouse;
  final String orderedBy;

  const FetchGateEntryEvent({
    required this.start,
    required this.length,
    required this.gateEntry,
    required this.vehicleNo,
    required this.toWarehouse,
    required this.orderedBy
  });

  @override
  List<Object?> get props =>
  [
    start,
    length,
    gateEntry,
    vehicleNo,
    toWarehouse,
    orderedBy
  ];
}


//sate
abstract class GateEntryState extends Equatable {
  const GateEntryState();

  @override
  List<Object?> get props => [];
}

class GateEntryInitial extends GateEntryState {
  const GateEntryInitial();
}

class GateEntryLoading extends GateEntryState {
  const GateEntryLoading();
}

class GateEntryLoadSuccess extends GateEntryState {
  final List<GateEntryData> gateEntry;

  const GateEntryLoadSuccess(this.gateEntry);

  @override
  List<Object?> get props => [gateEntry];
}

class GateEntryLoadFailure extends GateEntryState {
  final String message;

  const GateEntryLoadFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class GateEntryBloc extends Bloc<GateEntryEvent, GateEntryState> {
  final GateEntryService _service;

  GateEntryBloc({required GateEntryService service})
      : _service = service,
        super(const GateEntryInitial()) {
    on<FetchGateEntryEvent>(_onFetchGateEntry);
  }

  Future<void> _onFetchGateEntry(FetchGateEntryEvent event, Emitter<GateEntryState> emit) async {
    emit(const GateEntryLoading());

    try {
      final raw = await _service.fetchGateEntryRaw(
          start: event.start,
          length: event.length,
          gateEntry: event.gateEntry,
          vehicleNo: event.vehicleNo,
          toWarehouse: event.toWarehouse,
          orderedBy: event.orderedBy
      );
      final decoded = jsonDecode(raw);

      final data = decoded['data'];
      if (data == null || data is! List) {
        emit(const GateEntryLoadFailure('Something went wrong, Please try again'));
        return;
      }

      final gateEntry = data
          .map<GateEntryData>((e) => GateEntryData.fromJson(e as Map<String, dynamic>))
          .toList();

      emit(GateEntryLoadSuccess(gateEntry));
    } catch (e) {
      emit(GateEntryLoadFailure(e.toString()));
    }
  }
}

