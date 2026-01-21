import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../api/models/DAOGetGENDetail.dart';
import '../../api/services/add_gate_pass_service.dart';
import '../../api/services/add_goods_received_notes_service.dart';

// GoodsReceivedNotesByIDEvent
abstract class GoodsReceivedNotesByIDEvent extends Equatable {
  const GoodsReceivedNotesByIDEvent();

  @override
  List<Object?> get props => [];
}

class FetchGoodsReceivedNotesByIDEvent extends GoodsReceivedNotesByIDEvent {
  final String gatepass_id;

  const FetchGoodsReceivedNotesByIDEvent({required this.gatepass_id});

  @override
  List<Object?> get props => [gatepass_id];
}


// GoodsReceivedNotesByIDState
abstract class GoodsReceivedNotesByIDState extends Equatable {
  const GoodsReceivedNotesByIDState();

  @override
  List<Object?> get props => [];
}

class GoodsReceivedNotesByIDInitial extends GoodsReceivedNotesByIDState {}

class GoodsReceivedNotesByIDLoading extends GoodsReceivedNotesByIDState {}

class GoodsReceivedNotesByIDLoadSuccess extends GoodsReceivedNotesByIDState {
  final List<GENData> goodsReceivedNotesByID;

  const GoodsReceivedNotesByIDLoadSuccess(this.goodsReceivedNotesByID);

  @override
  List<Object?> get props => [goodsReceivedNotesByID];
}

class GoodsReceivedNotesByIDFailure extends GoodsReceivedNotesByIDState {
  final String error;

  const GoodsReceivedNotesByIDFailure(this.error);

  @override
  List<Object?> get props => [error];
}


// ********* Interface expected by the bloc *************//
abstract class GoodsReceivedNotesByIDService {
  Future<String> fetchGoodsReceivedNotesByIDRaw(String godownId);
}



/// Adapter that uses your existing EmployeeServices class
class GoodsReceivedNotesByIDServiceAdapter implements GoodsReceivedNotesByIDService {
  final GoodsReceivedByIDService _GoodsReceivedNotesByIDService;

  GoodsReceivedNotesByIDServiceAdapter({GoodsReceivedByIDService? GoodsReceivedNotesByIDService})
      : _GoodsReceivedNotesByIDService = GoodsReceivedNotesByIDService ?? GoodsReceivedByIDService();

  @override
  Future<String> fetchGoodsReceivedNotesByIDRaw(String Id) async {
    final result = await _GoodsReceivedNotesByIDService.fetchGoodsReceivedNotesByID(Id);
    if (result is String) return result;
    try {
      return result != null ? result.toString() : '{}';
    } catch (_) {
      return '{}';
    }
  }

}



/// Bloc implementation
class GoodsReceivedNotesByIDBloc extends Bloc<GoodsReceivedNotesByIDEvent, GoodsReceivedNotesByIDState> {
  final GoodsReceivedNotesByIDService _service;

  GoodsReceivedNotesByIDBloc({required GoodsReceivedNotesByIDService service})
      : _service = service,
        super( GoodsReceivedNotesByIDInitial()) {
    on<FetchGoodsReceivedNotesByIDEvent>(_onFetchMaterialIssue);
  }

  Future<void> _onFetchMaterialIssue(
      FetchGoodsReceivedNotesByIDEvent event, Emitter<GoodsReceivedNotesByIDState> emit) async {
    emit( GoodsReceivedNotesByIDLoading());

    try {
      final raw = await _service.fetchGoodsReceivedNotesByIDRaw(event.gatepass_id);

      // raw might already be a JSON string. If your service returns Map, adapt.
      final decoded = jsonDecode(raw);

      // Expecting the JSON shape: { "data": [ { "EmployeeId": "...", "EmployeeName": "..." }, ... ] }
      final data = decoded['data'];
      if (data == null || data is! List) {
        emit(const GoodsReceivedNotesByIDFailure('Something went wrong, Please try again'));
        return;
      }

      final GoodsReceivedNotesByID = data
          .map<GENData>((e) => GENData.fromJson(e as Map<String, dynamic>))
          .toList();

      emit(GoodsReceivedNotesByIDLoadSuccess(GoodsReceivedNotesByID));
    } catch (e) {
      emit(GoodsReceivedNotesByIDFailure(e.toString()));
    }
  }
}