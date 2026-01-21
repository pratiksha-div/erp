import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'dart:convert';
import '../../api/models/DAOGetGRN.dart';
import '../../api/services/add_goods_received_notes_service.dart';

//event
abstract class GoodsReceivedNotesEvent extends Equatable {
  const GoodsReceivedNotesEvent();

  @override
  List<Object?> get props => [];
}

/// Trigger fetching GoodsReceivedNotes with pagination
class FetchGoodsReceivedNotesEvent extends GoodsReceivedNotesEvent {
  final int start;
  final int length;
  final String from;
  final String to;
  final String grn_no;
  final String gate_entry_no;
  final String vehicle_no;

  const FetchGoodsReceivedNotesEvent({
    required this.start,
    required this.length,
    required this.from,
    required this.to,
    required this.grn_no,
    required this.gate_entry_no,
    required this.vehicle_no
  });

  @override
  List<Object?> get props => [start, length,from,to,grn_no,gate_entry_no,vehicle_no];
}


//sate
abstract class GoodsReceivedNotesState extends Equatable {
  const GoodsReceivedNotesState();

  @override
  List<Object?> get props => [];
}

class GoodsReceivedNotesInitial extends GoodsReceivedNotesState {
  const GoodsReceivedNotesInitial();
}

class GoodsReceivedNotesLoading extends GoodsReceivedNotesState {
  const GoodsReceivedNotesLoading();
}

class GoodsReceivedNotesLoadSuccess extends GoodsReceivedNotesState {
  final List<GRNData> GoodsReceivedNotes;

  const GoodsReceivedNotesLoadSuccess(this.GoodsReceivedNotes);

  @override
  List<Object?> get props => [GoodsReceivedNotes];
}

class GoodsReceivedNotesLoadFailure extends GoodsReceivedNotesState {
  final String message;

  const GoodsReceivedNotesLoadFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class GoodsReceivedNotesBloc extends Bloc<GoodsReceivedNotesEvent, GoodsReceivedNotesState> {
  final GoodsReceivedNotesService _service;

  GoodsReceivedNotesBloc({required GoodsReceivedNotesService service})
      : _service = service,
        super(const GoodsReceivedNotesInitial()) {
    on<FetchGoodsReceivedNotesEvent>(_onFetchGoodsReceivedNotes);
  }

  Future<void> _onFetchGoodsReceivedNotes(FetchGoodsReceivedNotesEvent event, Emitter<GoodsReceivedNotesState> emit) async {
    emit(const GoodsReceivedNotesLoading());

    try {
      final raw = await _service.fetchGoodsReceivedNotesRaw(
          start: event.start,
          length: event.length,
          from:event.from,
          to:event.to,
          grn_no:event.grn_no,
          gate_entry_no:event.gate_entry_no,
          vehicle_no:event.vehicle_no
      );
      final decoded = jsonDecode(raw);

      final data = decoded['data'];
      if (data == null || data is! List) {
        emit(const GoodsReceivedNotesLoadFailure('Something went wrong, Please try again'));
        return;
      }

      final GoodsReceivedNotes = data
          .map<GRNData>((e) => GRNData.fromJson(e as Map<String, dynamic>))
          .toList();

      emit(GoodsReceivedNotesLoadSuccess(GoodsReceivedNotes));
    } catch (e) {
      emit(GoodsReceivedNotesLoadFailure(e.toString()));
    }
  }
}

