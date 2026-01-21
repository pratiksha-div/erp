import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'dart:convert';
import '../../api/models/DAOGetGatePass.dart';
import '../../api/services/add_gate_pass_service.dart';


//event
abstract class GatePassEvent extends Equatable {
  const GatePassEvent();

  @override
  List<Object?> get props => [];
}

/// Trigger fetching GatePasss with pagination
class FetchGatePasssEvent extends GatePassEvent {
  final int start;
  final int length;
  final String from;
  final String to;
  final String gate_pass_number;
  final String transferType;
  final String item;

  const FetchGatePasssEvent({
    required this.start,
    required this.length,
    required this.from,
    required this.to,
    required this.gate_pass_number,
    required this.transferType,
    required this.item,
  });

  @override
  List<Object?> get props => [start, length];
}


//sate
abstract class GatePassState extends Equatable {
  const GatePassState();

  @override
  List<Object?> get props => [];
}

class GatePassInitial extends GatePassState {
  const GatePassInitial();
}

class GatePassLoading extends GatePassState {
  const GatePassLoading();
}

class GatePassLoadSuccess extends GatePassState {
  final List<GatePassData> GatePass;

  const GatePassLoadSuccess(this.GatePass);

  @override
  List<Object?> get props => [GatePass];
}

class GatePassLoadFailure extends GatePassState {
  final String message;

  const GatePassLoadFailure(this.message);

  @override
  List<Object?> get props => [message];
}

//bloc



class GatePassBloc extends Bloc<GatePassEvent, GatePassState> {
  final GatePassService _service;

  GatePassBloc({required GatePassService service})
      : _service = service,
        super(const GatePassInitial()) {
    on<FetchGatePasssEvent>(_onFetchGatePasss);
  }

  Future<void> _onFetchGatePasss(FetchGatePasssEvent event, Emitter<GatePassState> emit) async {
    emit(const GatePassLoading());

    try {
      final raw = await _service.fetchGatePassRaw(
          start: event.start,
          length: event.length,
          from: event.from,
          to: event.to,
          gate_pass_number: event.gate_pass_number,
          transferType: event.transferType,
          item: event.item
      );
      final decoded = jsonDecode(raw);

      final data = decoded['data'];
      if (data == null || data is! List) {
        emit(const GatePassLoadFailure('Something went wrong, Please try again'));
        return;
      }

      final GatePasss = data
          .map<GatePassData>((e) => GatePassData.fromJson(e as Map<String, dynamic>))
          .toList();

      emit(GatePassLoadSuccess(GatePasss));
    } catch (e) {
      emit(GatePassLoadFailure(e.toString()));
    }
  }
}

