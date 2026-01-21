import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../api/models/DAOGetWarehouse.dart';
import '../../api/services/dropdown_value_service.dart';

//*********** WarehouseEvent ***********//
abstract class WarehouseEvent extends Equatable {
  const WarehouseEvent();

  @override
  List<Object?> get props => [];
}

/// Trigger fetching Warehouses from API
class FetchWarehouseEvent extends WarehouseEvent {
  const FetchWarehouseEvent();
}


//*********** WarehouseState ***********//
abstract class WarehouseState extends Equatable {
  const WarehouseState();

  @override
  List<Object?> get props => [];
}

class WarehouseInitial extends WarehouseState {
  const WarehouseInitial();
}

class WarehouseLoading extends WarehouseState {
  const WarehouseLoading();
}

/// Success state contains the parsed list of Warehouses
class WarehouseLoadSuccess extends WarehouseState {
  final List<WarehouseData> warehouses;
  const WarehouseLoadSuccess(this.warehouses);

  @override
  List<Object?> get props => [warehouses];
}

class WarehouseLoadFailure extends WarehouseState {
  final String message;
  const WarehouseLoadFailure(this.message);

  @override
  List<Object?> get props => [message];
}


// ********* Interface expected by the bloc *************//
abstract class WarehouseService {
  Future<String> fetchWarehousesRaw();
}

/// Adapter that uses your existing WarehouseServices class
class WarehouseServiceAdapter implements WarehouseService {
  final DropdownServices _dropDownService;

  WarehouseServiceAdapter({DropdownServices? dropDownService})
      : _dropDownService = dropDownService ?? DropdownServices();

  @override
  Future<String> fetchWarehousesRaw() async {

    // call the existing async method and return its result
    final result = await _dropDownService.getWarehouseList();
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


//************** WarehouseBloc **************//


/// Bloc implementation
class WarehouseBloc extends Bloc<WarehouseEvent, WarehouseState> {
  final WarehouseService _service;

  WarehouseBloc({required WarehouseService service})
      : _service = service,
        super(const WarehouseInitial()) {
    on<FetchWarehouseEvent>(_onFetchWarehouses);
  }

  Future<void> _onFetchWarehouses(
      FetchWarehouseEvent event, Emitter<WarehouseState> emit) async {
    emit(const WarehouseLoading());

    try {
      final raw = await _service.fetchWarehousesRaw();

      // raw might already be a JSON string. If your service returns Map, adapt.
      final decoded = jsonDecode(raw);

      // Expecting the JSON shape: { "data": [ { "WarehouseId": "...", "WarehouseName": "..." }, ... ] }
      final data = decoded['data'];
      if (data == null || data is! List) {
        emit(const WarehouseLoadFailure('Something went wrong, Please try again'));
        return;
      }

      final Warehouses = data
          .map<WarehouseData>((e) => WarehouseData.fromJson(e as Map<String, dynamic>))
          .toList();

      emit(WarehouseLoadSuccess(Warehouses));
    } catch (e) {
      emit(WarehouseLoadFailure(e.toString()));
    }
  }
}




