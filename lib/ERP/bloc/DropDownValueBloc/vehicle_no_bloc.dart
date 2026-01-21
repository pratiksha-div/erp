import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../api/models/DAOGetVehicleNo.dart';
import '../../api/services/dropdown_value_service.dart';

//*********** VehicleEvent ***********//
abstract class VehicleEvent extends Equatable {
  const VehicleEvent();

  @override
  List<Object?> get props => [];
}

/// Trigger fetching Vehicles from API
class FetchVehiclesEvent extends VehicleEvent {
  const FetchVehiclesEvent();
}


//*********** VehicleState ***********//
abstract class VehicleState extends Equatable {
  const VehicleState();

  @override
  List<Object?> get props => [];
}

class VehicleInitial extends VehicleState {
  const VehicleInitial();
}

class VehicleLoading extends VehicleState {
  const VehicleLoading();
}

/// Success state contains the parsed list of Vehicles
class VehicleLoadSuccess extends VehicleState {
  final List<VehicleNoData> vehicles;
  const VehicleLoadSuccess(this.vehicles);

  @override
  List<Object?> get props => [vehicles];
}

class VehicleLoadFailure extends VehicleState {
  final String message;
  const VehicleLoadFailure(this.message);

  @override
  List<Object?> get props => [message];
}


// ********* Interface expected by the bloc *************//
abstract class VehicleService {
  Future<String> fetchVehiclesRaw();
}

/// Adapter that uses your existing VehicleServices class
class VehicleServiceAdapter implements VehicleService {
  final DropdownServices _dropDownService;

  VehicleServiceAdapter({DropdownServices? dropDownService})
      : _dropDownService = dropDownService ?? DropdownServices();

  @override
  Future<String> fetchVehiclesRaw() async {

    // call the existing async method and return its result
    final result = await _dropDownService.getVehicleNo();
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


//************** VehicleBloc **************//


/// Bloc implementation
class VehicleBloc extends Bloc<VehicleEvent, VehicleState> {
  final VehicleService _service;

  VehicleBloc({required VehicleService service})
      : _service = service,
        super(const VehicleInitial()) {
    on<FetchVehiclesEvent>(_onFetchVehicles);
  }

  Future<void> _onFetchVehicles(
      FetchVehiclesEvent event, Emitter<VehicleState> emit) async {
    emit(const VehicleLoading());

    try {
      final raw = await _service.fetchVehiclesRaw();

      // raw might already be a JSON string. If your service returns Map, adapt.
      final decoded = jsonDecode(raw);

      // Expecting the JSON shape: { "data": [ { "VehicleId": "...", "VehicleName": "..." }, ... ] }
      final data = decoded['data'];
      if (data == null || data is! List) {
        emit(const VehicleLoadFailure('Something went wrong, Please try again'));
        return;
      }

      final Vehicles = data
          .map<VehicleNoData>((e) => VehicleNoData.fromJson(e as Map<String, dynamic>))
          .toList();

      emit(VehicleLoadSuccess(Vehicles));
    } catch (e) {
      emit(VehicleLoadFailure(e.toString()));
    }
  }
}




