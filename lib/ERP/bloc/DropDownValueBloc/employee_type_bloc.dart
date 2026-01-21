import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../api/models/DAOGetEmployeeType.dart';
import '../../api/services/dropdown_value_service.dart';

//*********** EmployeeTypeEvent ***********//
abstract class EmployeeTypeEvent extends Equatable {
  const EmployeeTypeEvent();

  @override
  List<Object?> get props => [];
}

/// Trigger fetching EmployeeTypes from API
class FetchEmployeeTypesEvent extends EmployeeTypeEvent {
  const FetchEmployeeTypesEvent();
}


//*********** EmployeeTypeState ***********//
abstract class EmployeeTypeState extends Equatable {
  const EmployeeTypeState();

  @override
  List<Object?> get props => [];
}

class EmployeeTypeInitial extends EmployeeTypeState {
  const EmployeeTypeInitial();
}

class EmployeeTypeLoading extends EmployeeTypeState {
  const EmployeeTypeLoading();
}

/// Success state contains the parsed list of EmployeeTypes
class EmployeeTypeLoadSuccess extends EmployeeTypeState {
  final List<EmployeeTypeData> EmployeeTypes;
  const EmployeeTypeLoadSuccess(this.EmployeeTypes);

  @override
  List<Object?> get props => [EmployeeTypes];
}

class EmployeeTypeLoadFailure extends EmployeeTypeState {
  final String message;
  const EmployeeTypeLoadFailure(this.message);

  @override
  List<Object?> get props => [message];
}


// ********* Interface expected by the bloc *************//
abstract class EmployeeTypeService {
  Future<String> fetchEmployeeTypesRaw();
}

/// Adapter that uses your existing EmployeeTypeServices class
class EmployeeTypeServiceAdapter implements EmployeeTypeService {
  final DropdownServices _dropDownService;

  EmployeeTypeServiceAdapter({DropdownServices? dropDownService})
      : _dropDownService = dropDownService ?? DropdownServices();

  @override
  Future<String> fetchEmployeeTypesRaw() async {

    // call the existing async method and return its result
    final result = await _dropDownService.getEmployeeType();
    // ensure it's a String so bloc can jsonDecode it
    if (result is String) return result;
    // if it's null or Map, convert safely
    try {
      return result != null ? result.toString() : '{}';
    } catch (_) {
      return '{}';
    }
  }
}


//************** EmployeeTypeBloc **************//


/// Bloc implementation
class EmployeeTypeBloc extends Bloc<EmployeeTypeEvent, EmployeeTypeState> {
  final EmployeeTypeService _service;

  EmployeeTypeBloc({required EmployeeTypeService service})
      : _service = service,
        super(const EmployeeTypeInitial()) {
    on<FetchEmployeeTypesEvent>(_onFetchEmployeeTypes);
  }

  Future<void> _onFetchEmployeeTypes(
      FetchEmployeeTypesEvent event, Emitter<EmployeeTypeState> emit) async {
    emit(const EmployeeTypeLoading());

    try {
      final raw = await _service.fetchEmployeeTypesRaw();

      // raw might already be a JSON string. If your service returns Map, adapt.
      final decoded = jsonDecode(raw);

      // Expecting the JSON shape: { "data": [ { "EmployeeTypeId": "...", "EmployeeTypeName": "..." }, ... ] }
      final data = decoded['data'];
      if (data == null || data is! List) {
        emit(const EmployeeTypeLoadFailure('Something went wrong, Please try again'));
        return;
      }

      final EmployeeTypes = data
          .map<EmployeeTypeData>((e) => EmployeeTypeData.fromJson(e as Map<String, dynamic>))
          .toList();

      emit(EmployeeTypeLoadSuccess(EmployeeTypes));
    } catch (e) {
      emit(EmployeeTypeLoadFailure(e.toString()));
    }
  }
}




