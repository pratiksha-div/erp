import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../api/models/DAOGetUnits.dart';
import '../../api/services/dropdown_value_service.dart';

// BasicUnitsEvent
abstract class BasicUnitsEvent extends Equatable {
  const BasicUnitsEvent();

  @override
  List<Object?> get props => [];
}

class FetchBasicUnitsEvent extends BasicUnitsEvent {
  final String itemName;

  const FetchBasicUnitsEvent({required this.itemName});

  @override
  List<Object?> get props => [itemName];
}


// BasicUnitsState
abstract class BasicUnitsState extends Equatable {
  const BasicUnitsState();

  @override
  List<Object?> get props => [];
}

class BasicUnitsInitial extends BasicUnitsState {}

class BasicUnitsLoading extends BasicUnitsState {}

class BasicUnitsLoadSuccess extends BasicUnitsState {
  final List<UnitsData> basicUnits;
  final String itemName; // item these BasicUnits belong to

  const BasicUnitsLoadSuccess(this.basicUnits, this.itemName);

  @override
  List<Object?> get props => [basicUnits, itemName];
}


class BasicUnitsFailure extends BasicUnitsState {
  final String error;

  const BasicUnitsFailure(this.error);

  @override
  List<Object?> get props => [error];
}


// ********* Interface expected by the bloc *************//
abstract class BasicUnitsService {
  Future<String> fetchBasicUnitsRaw(String itemName);
}



/// Adapter that uses your existing EmployeeServices class
class BasicUnitsServiceAdapter implements BasicUnitsService {
  final DropdownServices _dropDownService;

  BasicUnitsServiceAdapter({DropdownServices? dropDownService})
      : _dropDownService = dropDownService ?? DropdownServices();

  @override
  @override
  Future<String> fetchBasicUnitsRaw(String itemName) async {
    final result = await _dropDownService.getBasicUnits(itemName);
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
class BasicUnitsBloc extends Bloc<BasicUnitsEvent, BasicUnitsState> {
  final BasicUnitsService _service;

  BasicUnitsBloc({required BasicUnitsService service})
      : _service = service,
        super( BasicUnitsInitial()) {
    on<FetchBasicUnitsEvent>(_onFetchMaterialIssue);
  }

  Future<void> _onFetchMaterialIssue(
      FetchBasicUnitsEvent event, Emitter<BasicUnitsState> emit) async {
    emit( BasicUnitsLoading());

    try {
      final raw = await _service.fetchBasicUnitsRaw(event.itemName);

      // raw might already be a JSON string. If your service returns Map, adapt.
      final decoded = jsonDecode(raw);

      // Expecting the JSON shape: { "data": [ { "EmployeeId": "...", "EmployeeName": "..." }, ... ] }
      final data = decoded['data'];
      if (data == null || data is! List) {
        emit(const BasicUnitsFailure('Something went wrong, Please try again'));
        return;
      }

      final basicUnits = data
          .map<UnitsData>((e) => UnitsData.fromJson(e as Map<String, dynamic>))
          .toList();

      emit(BasicUnitsLoadSuccess(basicUnits,event.itemName));
    } catch (e) {
      emit(BasicUnitsFailure(e.toString()));
    }
  }
}


