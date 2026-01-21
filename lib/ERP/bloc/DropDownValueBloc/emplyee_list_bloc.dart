import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../api/models/DAOGetEmployee.dart';
import '../../api/services/dropdown_value_service.dart';

//*********** EmployeeEvent ***********//
abstract class EmployeeEvent extends Equatable {
  const EmployeeEvent();

  @override
  List<Object?> get props => [];
}

/// Trigger fetching employees from API
class FetchEmployeesEvent extends EmployeeEvent {
  const FetchEmployeesEvent();
}


//*********** EmployeeState ***********//
abstract class EmployeeState extends Equatable {
  const EmployeeState();

  @override
  List<Object?> get props => [];
}

class EmployeeInitial extends EmployeeState {
  const EmployeeInitial();
}

class EmployeeLoading extends EmployeeState {
  const EmployeeLoading();
}

/// Success state contains the parsed list of employees
class EmployeeLoadSuccess extends EmployeeState {
  final List<EmployeeData> employees;
  const EmployeeLoadSuccess(this.employees);

  @override
  List<Object?> get props => [employees];
}

class EmployeeLoadFailure extends EmployeeState {
  final String message;
  const EmployeeLoadFailure(this.message);

  @override
  List<Object?> get props => [message];
}


// ********* Interface expected by the bloc *************//
abstract class EmployeeService {
  Future<String> fetchEmployeesRaw();
}

/// Adapter that uses your existing EmployeeServices class
class EmployeeServiceAdapter implements EmployeeService {
  final DropdownServices _dropDownService;

  EmployeeServiceAdapter({DropdownServices? dropDownService})
      : _dropDownService = dropDownService ?? DropdownServices();

  @override
  Future<String> fetchEmployeesRaw() async {

    // call the existing async method and return its result
    final result = await _dropDownService.getEmployeeList();
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

//************** EmployeeBloc **************//
/// Bloc implementation
class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final EmployeeService _service;

  EmployeeBloc({required EmployeeService service})
      : _service = service,
        super(const EmployeeInitial()) {
    on<FetchEmployeesEvent>(_onFetchEmployees);
  }

  Future<void> _onFetchEmployees(
      FetchEmployeesEvent event, Emitter<EmployeeState> emit) async {
    emit(const EmployeeLoading());

    try {
      final raw = await _service.fetchEmployeesRaw();

      // raw might already be a JSON string. If your service returns Map, adapt.
      final decoded = jsonDecode(raw);

      // Expecting the JSON shape: { "data": [ { "EmployeeId": "...", "EmployeeName": "..." }, ... ] }
      final data = decoded['data'];
      if (data == null || data is! List) {
        emit(const EmployeeLoadFailure('Something went wrong, Please try again'));
        return;
      }

      final employees = data
          .map<EmployeeData>((e) => EmployeeData.fromJson(e as Map<String, dynamic>))
          .toList();

      emit(EmployeeLoadSuccess(employees));
    } catch (e) {
      emit(EmployeeLoadFailure(e.toString()));
    }
  }
}




