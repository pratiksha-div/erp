import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../api/models/DAOGetUnits.dart';
import '../../api/services/dropdown_value_service.dart';

// UnitsEvent
abstract class UnitsEvent extends Equatable {
  const UnitsEvent();

  @override
  List<Object?> get props => [];
}

class FetchUnitsEvent extends UnitsEvent {
  final String itemName;

  const FetchUnitsEvent({required this.itemName});

  @override
  List<Object?> get props => [itemName];
}


// UnitsState
abstract class UnitsState extends Equatable {
  const UnitsState();

  @override
  List<Object?> get props => [];
}

class UnitsInitial extends UnitsState {}

class UnitsLoading extends UnitsState {}

class UnitsLoadSuccess extends UnitsState {
  final List<UnitsData> units;
  final String itemName; // item these units belong to

  const UnitsLoadSuccess(this.units, this.itemName);

  @override
  List<Object?> get props => [units, itemName];
}


class UnitsFailure extends UnitsState {
  final String error;

  const UnitsFailure(this.error);

  @override
  List<Object?> get props => [error];
}


// ********* Interface expected by the bloc *************//
abstract class UnitsService {
  Future<String> fetchUnitsRaw(String itemName);
}



/// Adapter that uses your existing EmployeeServices class
class UnitsServiceAdapter implements UnitsService {
  final DropdownServices _dropDownService;

  UnitsServiceAdapter({DropdownServices? dropDownService})
      : _dropDownService = dropDownService ?? DropdownServices();

  @override
  @override
  Future<String> fetchUnitsRaw(String itemName) async {
    final result = await _dropDownService.getUnits(itemName);
    if (result is String) return result;
    try {
      return result != null ? result.toString() : '{}';
    } catch (_) {
      return '{}';
    }
  }

}


//************** EmployeeBloc **************//


/// Bloc implementation
class UnitsBloc extends Bloc<UnitsEvent, UnitsState> {
  final UnitsService _service;

  UnitsBloc({required UnitsService service})
      : _service = service,
        super( UnitsInitial()) {
    on<FetchUnitsEvent>(_onFetchMaterialIssue);
  }

  Future<void> _onFetchMaterialIssue(
      FetchUnitsEvent event, Emitter<UnitsState> emit) async {
    emit( UnitsLoading());

    try {
      final raw = await _service.fetchUnitsRaw(event.itemName);

      // raw might already be a JSON string. If your service returns Map, adapt.
      final decoded = jsonDecode(raw);

      // Expecting the JSON shape: { "data": [ { "EmployeeId": "...", "EmployeeName": "..." }, ... ] }
      final data = decoded['data'];
      if (data == null || data is! List) {
        emit(const UnitsFailure('Something went wrong, Please try again'));
        return;
      }

      final units = data
          .map<UnitsData>((e) => UnitsData.fromJson(e as Map<String, dynamic>))
          .toList();

      emit(UnitsLoadSuccess(units,event.itemName));
    } catch (e) {
      emit(UnitsFailure(e.toString()));
    }
  }
}


