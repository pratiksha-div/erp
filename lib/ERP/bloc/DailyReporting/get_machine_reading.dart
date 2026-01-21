import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'dart:convert';

import '../../api/models/DAOGetMachineReading.dart';
import '../../api/models/DAOGetNewEntries.dart';
import '../../api/services/add_machine_reading_service.dart';
import '../../api/services/add_new_entry.dart';

//event
abstract class MachineReadingEvent extends Equatable {
  const MachineReadingEvent();

  @override
  List<Object?> get props => [];
}

/// Trigger fetching MachineReadings with pagination
class FetchMachineReadingsEvent extends MachineReadingEvent {
  final int start;
  final int length;

  const FetchMachineReadingsEvent({required this.start, required this.length});

  @override
  List<Object?> get props => [start, length];
}


//sate
abstract class MachineReadingState extends Equatable {
  const MachineReadingState();

  @override
  List<Object?> get props => [];
}

class MachineReadingInitial extends MachineReadingState {
  const MachineReadingInitial();
}

class MachineReadingLoading extends MachineReadingState {
  const MachineReadingLoading();
}

class MachineReadingLoadSuccess extends MachineReadingState {
  final List<MachineReadingData> MachineReading;

  const MachineReadingLoadSuccess(this.MachineReading);

  @override
  List<Object?> get props => [MachineReading];
}

class MachineReadingLoadFailure extends MachineReadingState {
  final String message;

  const MachineReadingLoadFailure(this.message);

  @override
  List<Object?> get props => [message];
}

//bloc



class MachineReadingBloc extends Bloc<MachineReadingEvent, MachineReadingState> {
  final MachineReadingService _service;

  MachineReadingBloc({required MachineReadingService service})
      : _service = service,
        super(const MachineReadingInitial()) {
    on<FetchMachineReadingsEvent>(_onFetchMachineReadings);
  }

  Future<void> _onFetchMachineReadings(FetchMachineReadingsEvent event, Emitter<MachineReadingState> emit) async {
    emit(const MachineReadingLoading());

    try {
      final raw = await _service.fetchMachineReadingRaw(start: event.start, length: event.length,);
      final decoded = jsonDecode(raw);

      final data = decoded['data'];
      if (data == null || data is! List) {
        emit(const MachineReadingLoadFailure('Something went wrong, Please try again'));
        return;
      }

      final MachineReadings = data
          .map<MachineReadingData>((e) => MachineReadingData.fromJson(e as Map<String, dynamic>))
          .toList();

      emit(MachineReadingLoadSuccess(MachineReadings));
    } catch (e) {
      emit(MachineReadingLoadFailure(e.toString()));
    }
  }
}

