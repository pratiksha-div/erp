import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../api/models/GetGRNDetailByID.dart';
import '../../api/services/add_goods_received_notes_service.dart';

// GRNDetailByIDEvent
abstract class GRNDetailByIDEvent extends Equatable {
  const GRNDetailByIDEvent();

  @override
  List<Object?> get props => [];
}

class FetchGRNDetailByIDEvent extends GRNDetailByIDEvent {
  final String grn_id;

  const FetchGRNDetailByIDEvent({required this.grn_id});

  @override
  List<Object?> get props => [grn_id];
}


// GRNDetailByIDState
abstract class GRNDetailByIDState extends Equatable {
  const GRNDetailByIDState();

  @override
  List<Object?> get props => [];
}

class GRNDetailByIDInitial extends GRNDetailByIDState {}

class GRNDetailByIDLoading extends GRNDetailByIDState {}

class GRNDetailByIDLoadSuccess extends GRNDetailByIDState {
  final List<GRNDetailByIDData> GRNDetailByID;

  const GRNDetailByIDLoadSuccess(this.GRNDetailByID);

  @override
  List<Object?> get props => [GRNDetailByID];
}

class GRNDetailByIDFailure extends GRNDetailByIDState {
  final String error;

  const GRNDetailByIDFailure(this.error);

  @override
  List<Object?> get props => [error];
}


// ********* Interface expected by the bloc *************//
abstract class GRNDetailByIDService {
  Future<String> fetchGRNDetailByIDRaw(String godownId);
}



/// Adapter that uses your existing EmployeeServices class
class GRNDetailByIDServiceAdapter implements GRNDetailByIDService {
  final GetGRNDetailByIDService _GRNDetailByIDService;

  GRNDetailByIDServiceAdapter({GetGRNDetailByIDService? GRNDetailByIDService})
      : _GRNDetailByIDService = GRNDetailByIDService ?? GetGRNDetailByIDService();

  @override
  Future<String> fetchGRNDetailByIDRaw(String Id) async {
    final result = await _GRNDetailByIDService.fetchGRNDetialByID(Id);
    if (result is String) return result;
    try {
      return result != null ? result.toString() : '{}';
    } catch (_) {
      return '{}';
    }
  }

}



/// Bloc implementation
class GRNDetailByIDBloc extends Bloc<GRNDetailByIDEvent, GRNDetailByIDState> {
  final GRNDetailByIDService _service;

  GRNDetailByIDBloc({required GRNDetailByIDService service})
      : _service = service,
        super( GRNDetailByIDInitial()) {
    on<FetchGRNDetailByIDEvent>(_onFetchMaterialIssue);
  }

  Future<void> _onFetchMaterialIssue(
      FetchGRNDetailByIDEvent event, Emitter<GRNDetailByIDState> emit) async {
    emit( GRNDetailByIDLoading());

    try {
      final raw = await _service.fetchGRNDetailByIDRaw(event.grn_id);

      // raw might already be a JSON string. If your service returns Map, adapt.
      final decoded = jsonDecode(raw);

      // Expecting the JSON shape: { "data": [ { "EmployeeId": "...", "EmployeeName": "..." }, ... ] }
      final data = decoded['data'];
      if (data == null || data is! List) {
        emit(const GRNDetailByIDFailure('Something went wrong, Please try again'));
        return;
      }

      final GRNDetailByID = data
          .map<GRNDetailByIDData>((e) => GRNDetailByIDData.fromJson(e as Map<String, dynamic>))
          .toList();

      emit(GRNDetailByIDLoadSuccess(GRNDetailByID));
    } catch (e) {
      emit(GRNDetailByIDFailure(e.toString()));
    }
  }
}