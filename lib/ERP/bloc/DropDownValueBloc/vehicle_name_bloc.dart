import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../api/models/DAOGetVehicleName.dart';
import '../../api/services/dropdown_value_service.dart';

// VehicleNameEvent
abstract class VehicleNameEvent extends Equatable {
  const VehicleNameEvent();

  @override
  List<Object?> get props => [];
}

class FetchVehicleNameEvent extends VehicleNameEvent {
  final String VendorId;

  const FetchVehicleNameEvent({required this.VendorId});

  @override
  List<Object?> get props => [VendorId];
}


// VehicleNameState
abstract class VehicleNameState extends Equatable {
  const VehicleNameState();

  @override
  List<Object?> get props => [];
}

class VehicleNameInitial extends VehicleNameState {}

class VehicleNameLoading extends VehicleNameState {}

class VehicleNameLoadSuccess extends VehicleNameState {
  final List<VehicleData> data;

  const VehicleNameLoadSuccess(this.data);

  @override
  List<Object?> get props => [data];
}

class VehicleNameFailure extends VehicleNameState {
  final String error;

  const VehicleNameFailure(this.error);

  @override
  List<Object?> get props => [error];
}


// ********* Interface expected by the bloc *************//
abstract class VehicleNameService {
  Future<String> fetchVehicleNameRaw(String VendorId);
}



/// Adapter that uses your existing EmployeeServices class
class VehicleNameServiceAdapter implements VehicleNameService {
  final DropdownServices _dropDownService;

  VehicleNameServiceAdapter({DropdownServices? dropDownService})
      : _dropDownService = dropDownService ?? DropdownServices();

  @override
  @override
  Future<String> fetchVehicleNameRaw(String VendorId) async {
    final result = await _dropDownService.getVehicleName(VendorId);
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
class VehicleNameBloc extends Bloc<VehicleNameEvent, VehicleNameState> {
  final VehicleNameService _service;

  VehicleNameBloc({required VehicleNameService service})
      : _service = service,
        super( VehicleNameInitial()) {
    on<FetchVehicleNameEvent>(_onFetchMaterialIssue);
  }

  Future<void> _onFetchMaterialIssue(
      FetchVehicleNameEvent event, Emitter<VehicleNameState> emit) async {
    emit( VehicleNameLoading());

    try {
      final raw = await _service.fetchVehicleNameRaw(event.VendorId);

      // raw might already be a JSON string. If your service returns Map, adapt.
      final decoded = jsonDecode(raw);

      // Expecting the JSON shape: { "data": [ { "EmployeeId": "...", "EmployeeName": "..." }, ... ] }
      final data = decoded['data'];
      if (data == null || data is! List) {
        emit(const VehicleNameFailure('Something went wrong, Please try again'));
        return;
      }

      final VehicleName = data
          .map<VehicleData>((e) => VehicleData.fromJson(e as Map<String, dynamic>))
          .toList();

      emit(VehicleNameLoadSuccess(VehicleName));
    } catch (e) {
      emit(VehicleNameFailure(e.toString()));
    }
  }
}


