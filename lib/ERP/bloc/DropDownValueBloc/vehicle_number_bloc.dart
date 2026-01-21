import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../api/models/DAOGetVehicleNumber.dart';
import '../../api/services/dropdown_value_service.dart';

// VehicleNumberEvent
abstract class VehicleNumberEvent extends Equatable {
  const VehicleNumberEvent();

  @override
  List<Object?> get props => [];
}

class FetchVehicleNumberEvent extends VehicleNumberEvent {
  final String VehicleId;

  const FetchVehicleNumberEvent({required this.VehicleId});

  @override
  List<Object?> get props => [VehicleId];
}


// VehicleNumberState
abstract class VehicleNumberState extends Equatable {
  const VehicleNumberState();

  @override
  List<Object?> get props => [];
}

class VehicleNumberInitial extends VehicleNumberState {}

class VehicleNumberLoading extends VehicleNumberState {}

class VehicleNumberLoadSuccess extends VehicleNumberState {
  final List<VehicleNumberData> materials;

  const VehicleNumberLoadSuccess(this.materials);

  @override
  List<Object?> get props => [materials];
}

class VehicleNumberFailure extends VehicleNumberState {
  final String error;

  const VehicleNumberFailure(this.error);

  @override
  List<Object?> get props => [error];
}


// ********* Interface expected by the bloc *************//
abstract class VehicleNumberService {
  Future<String> fetchVehicleNumberRaw(String VehicleId);
}



/// Adapter that uses your existing EmployeeServices class
class VehicleNumberServiceAdapter implements VehicleNumberService {
  final DropdownServices _dropDownService;

  VehicleNumberServiceAdapter({DropdownServices? dropDownService})
      : _dropDownService = dropDownService ?? DropdownServices();

  @override
  @override
  Future<String> fetchVehicleNumberRaw(String VehicleId) async {
    final result = await _dropDownService.getVehicleNumber(VehicleId);
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
class VehicleNumberBloc extends Bloc<VehicleNumberEvent, VehicleNumberState> {
  final VehicleNumberService _service;

  VehicleNumberBloc({required VehicleNumberService service})
      : _service = service,
        super( VehicleNumberInitial()) {
    on<FetchVehicleNumberEvent>(_onFetchMaterialIssue);
  }

  Future<void> _onFetchMaterialIssue(
      FetchVehicleNumberEvent event, Emitter<VehicleNumberState> emit) async {
    emit( VehicleNumberLoading());

    try {
      final raw = await _service.fetchVehicleNumberRaw(event.VehicleId);

      // raw might already be a JSON string. If your service returns Map, adapt.
      final decoded = jsonDecode(raw);

      // Expecting the JSON shape: { "data": [ { "EmployeeId": "...", "EmployeeName": "..." }, ... ] }
      final data = decoded['data'];
      if (data == null || data is! List) {
        emit(const VehicleNumberFailure('Something went wrong, Please try again'));
        return;
      }

      final VehicleNumber = data
          .map<VehicleNumberData>((e) => VehicleNumberData.fromJson(e as Map<String, dynamic>))
          .toList();

      emit(VehicleNumberLoadSuccess(VehicleNumber));
    } catch (e) {
      emit(VehicleNumberFailure(e.toString()));
    }
  }
}


