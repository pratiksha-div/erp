import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'dart:convert';
import '../../api/models/DAOGetNewEntries.dart';
import '../../api/services/add_material_consumption.dart';
import '../../api/services/add_new_entry.dart';

//event
abstract class NewEntryEvent extends Equatable {
  const NewEntryEvent();

  @override
  List<Object?> get props => [];
}

/// Trigger fetching NewEntrys with pagination
class FetchNewEntrysEvent extends NewEntryEvent {
  final int start;
  final int length;

  const FetchNewEntrysEvent({required this.start, required this.length});

  @override
  List<Object?> get props => [start, length];
}


//sate
abstract class NewEntryState extends Equatable {
  const NewEntryState();

  @override
  List<Object?> get props => [];
}

class NewEntryInitial extends NewEntryState {
  const NewEntryInitial();
}

class NewEntryLoading extends NewEntryState {
  const NewEntryLoading();
}

class NewEntryLoadSuccess extends NewEntryState {
  final List<NewEntryData> newEntry;

  const NewEntryLoadSuccess(this.newEntry);

  @override
  List<Object?> get props => [newEntry];
}

class NewEntryLoadFailure extends NewEntryState {
  final String message;

  const NewEntryLoadFailure(this.message);

  @override
  List<Object?> get props => [message];
}

//bloc



class NewEntryBloc extends Bloc<NewEntryEvent, NewEntryState> {
  final NewEntryService _service;

  NewEntryBloc({required NewEntryService service})
      : _service = service,
        super(const NewEntryInitial()) {
    on<FetchNewEntrysEvent>(_onFetchNewEntrys);
  }

  Future<void> _onFetchNewEntrys(FetchNewEntrysEvent event, Emitter<NewEntryState> emit) async {
    emit(const NewEntryLoading());

    try {
      final raw = await _service.fetchNewEntryRaw(start: event.start, length: event.length,);
      final decoded = jsonDecode(raw);

      final data = decoded['data'];
      if (data == null || data is! List) {
        emit(const NewEntryLoadFailure('Something went wrong, Please try again'));
        return;
      }

      final newEntry = data
          .map<NewEntryData>((e) => NewEntryData.fromJson(e as Map<String, dynamic>))
          .toList();

      emit(NewEntryLoadSuccess(newEntry));
    } catch (e) {
      emit(NewEntryLoadFailure(e.toString()));
    }
  }
}

