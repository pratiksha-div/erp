import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../api/models/GetEntryByID.dart';
import '../../api/services/add_new_entry.dart';

// EntryByIDEvent
abstract class EntryByIDEvent extends Equatable {
  const EntryByIDEvent();

  @override
  List<Object?> get props => [];
}

class FetchEntryByIDEvent extends EntryByIDEvent {
  final String work_detail_id;

  const FetchEntryByIDEvent({required this.work_detail_id});

  @override
  List<Object?> get props => [work_detail_id];
}


// EntryByIDState
abstract class EntryByIDState extends Equatable {
  const EntryByIDState();

  @override
  List<Object?> get props => [];
}

class EntryByIDInitial extends EntryByIDState {}

class EntryByIDLoading extends EntryByIDState {}

class EntryByIDLoadSuccess extends EntryByIDState {
  final List<EntryByID> entryByID;

  const EntryByIDLoadSuccess(this.entryByID);

  @override
  List<Object?> get props => [entryByID];
}

class EntryByIDFailure extends EntryByIDState {
  final String error;

  const EntryByIDFailure(this.error);

  @override
  List<Object?> get props => [error];
}


// ********* Interface expected by the bloc *************//
abstract class EntryByIDService {
  Future<String> fetchEntryByIDRaw(String godownId);
}



/// Adapter that uses your existing EmployeeServices class
class EntryByIDServiceAdapter implements EntryByIDService {
  final GetEntryByIDService _EntryByIDService;

  EntryByIDServiceAdapter({GetEntryByIDService? EntryByIDService})
      : _EntryByIDService = EntryByIDService ?? GetEntryByIDService();

  @override
  Future<String> fetchEntryByIDRaw(String Id) async {
    final result = await _EntryByIDService.fetchEntryByID(Id);
    if (result is String) return result;
    try {
      return result != null ? result.toString() : '{}';
    } catch (_) {
      return '{}';
    }
  }

}



/// Bloc implementation
class EntryByIDBloc extends Bloc<EntryByIDEvent, EntryByIDState> {
  final EntryByIDService _service;

  EntryByIDBloc({required EntryByIDService service})
      : _service = service,
        super( EntryByIDInitial()) {
    on<FetchEntryByIDEvent>(_onFetchMaterialIssue);
  }

  Future<void> _onFetchMaterialIssue(
      FetchEntryByIDEvent event, Emitter<EntryByIDState> emit) async {
    emit( EntryByIDLoading());

    try {
      final raw = await _service.fetchEntryByIDRaw(event.work_detail_id);

      // raw might already be a JSON string. If your service returns Map, adapt.
      final decoded = jsonDecode(raw);

      // Expecting the JSON shape: { "data": [ { "EmployeeId": "...", "EmployeeName": "..." }, ... ] }
      final data = decoded['data'];
      if (data == null || data is! List) {
        emit(const EntryByIDFailure('Something went wrong, Please try again'));
        return;
      }

      final entryByID = data
          .map<EntryByID>((e) => EntryByID.fromJson(e as Map<String, dynamic>))
          .toList();

      emit(EntryByIDLoadSuccess(entryByID));
    } catch (e) {
      emit(EntryByIDFailure(e.toString()));
    }
  }
}