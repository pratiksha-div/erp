import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'dart:convert';

import '../../api/models/DAOGetNewEntries.dart';
import '../../api/models/DAOMaterialConsumptionList.dart';
import '../../api/services/add_material_consumption.dart';
import '../../api/services/add_new_entry.dart';

//event
abstract class MaterialConsumptionEvent extends Equatable {
  const MaterialConsumptionEvent();

  @override
  List<Object?> get props => [];
}

/// Trigger fetching MaterialConsumptions with pagination
class FetchMaterialConsumptionsEvent extends MaterialConsumptionEvent {
  final int start;
  final int length;

  const FetchMaterialConsumptionsEvent({required this.start, required this.length});

  @override
  List<Object?> get props => [start, length];
}


//sate
abstract class MaterialConsumptionState extends Equatable {
  const MaterialConsumptionState();

  @override
  List<Object?> get props => [];
}

class MaterialConsumptionInitial extends MaterialConsumptionState {
  const MaterialConsumptionInitial();
}

class MaterialConsumptionLoading extends MaterialConsumptionState {
  const MaterialConsumptionLoading();
}

class MaterialConsumptionLoadSuccess extends MaterialConsumptionState {
  final List<MaterialConsumptionList> MaterialConsumption;

  const MaterialConsumptionLoadSuccess(this.MaterialConsumption);

  @override
  List<Object?> get props => [MaterialConsumption];
}

class MaterialConsumptionLoadFailure extends MaterialConsumptionState {
  final String message;

  const MaterialConsumptionLoadFailure(this.message);

  @override
  List<Object?> get props => [message];
}

//bloc



class MaterialConsumptionBloc extends Bloc<MaterialConsumptionEvent, MaterialConsumptionState> {
  final MaterialConsumptionService _service;

  MaterialConsumptionBloc({required MaterialConsumptionService service})
      : _service = service,
        super(const MaterialConsumptionInitial()) {
    on<FetchMaterialConsumptionsEvent>(_onFetchMaterialConsumptions);
  }

  Future<void> _onFetchMaterialConsumptions(FetchMaterialConsumptionsEvent event, Emitter<MaterialConsumptionState> emit) async {
    emit(const MaterialConsumptionLoading());

    try {
      final raw = await _service.fetchMaterialConsumptionRaw(start: event.start, length: event.length,);
      final decoded = jsonDecode(raw);

      final data = decoded['data'];
      if (data == null || data is! List) {
        emit(const MaterialConsumptionLoadFailure('Something went wrong, Please try again'));
        return;
      }

      final MaterialConsumptions = data
          .map<MaterialConsumptionList>((e) => MaterialConsumptionList.fromJson(e as Map<String, dynamic>))
          .toList();

      emit(MaterialConsumptionLoadSuccess(MaterialConsumptions));
    } catch (e) {
      emit(MaterialConsumptionLoadFailure(e.toString()));
    }
  }
}

