import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../api/models/GetMaterialConsumptionByID.dart';
import '../../api/services/add_material_consumption.dart';

// MaterialConsumptionByIDEvent
abstract class MaterialConsumptionByIDEvent extends Equatable {
  const MaterialConsumptionByIDEvent();

  @override
  List<Object?> get props => [];
}

class FetchMaterialConsumptionByIDEvent extends MaterialConsumptionByIDEvent {
  final String consumption_id;

  const FetchMaterialConsumptionByIDEvent({required this.consumption_id});

  @override
  List<Object?> get props => [consumption_id];
}


// MaterialConsumptionByIDState
abstract class MaterialConsumptionByIDState extends Equatable {
  const MaterialConsumptionByIDState();

  @override
  List<Object?> get props => [];
}

class MaterialConsumptionByIDInitial extends MaterialConsumptionByIDState {}

class MaterialConsumptionByIDLoading extends MaterialConsumptionByIDState {}

class MaterialConsumptionByIDLoadSuccess extends MaterialConsumptionByIDState {
  final List<MaterialConsumptionByID> materialConsumptionByID;

  const MaterialConsumptionByIDLoadSuccess(this.materialConsumptionByID);

  @override
  List<Object?> get props => [MaterialConsumptionByID];
}

class MaterialConsumptionByIDFailure extends MaterialConsumptionByIDState {
  final String error;

  const MaterialConsumptionByIDFailure(this.error);

  @override
  List<Object?> get props => [error];
}


// ********* Interface expected by the bloc *************//
abstract class MaterialConsumptionByIDService {
  Future<String> fetchMaterialConsumptionByIDRaw(String godownId);
}



/// Adapter that uses your existing EmployeeServices class
class MaterialConsumptionByIDServiceAdapter implements MaterialConsumptionByIDService {
  final GetMaterialConsumptionByIDService _MaterialConsumptionByIDService;

  MaterialConsumptionByIDServiceAdapter({GetMaterialConsumptionByIDService? MaterialConsumptionByIDService})
      : _MaterialConsumptionByIDService = MaterialConsumptionByIDService ?? GetMaterialConsumptionByIDService();

  @override
  Future<String> fetchMaterialConsumptionByIDRaw(String Id) async {
    final result = await _MaterialConsumptionByIDService.fetchMaterialConsumptionDataByID(Id);
    if (result is String) return result;
    try {
      return result != null ? result.toString() : '{}';
    } catch (_) {
      return '{}';
    }
  }

}



/// Bloc implementation
class MaterialConsumptionByIDBloc extends Bloc<MaterialConsumptionByIDEvent, MaterialConsumptionByIDState> {
  final MaterialConsumptionByIDService _service;

  MaterialConsumptionByIDBloc({required MaterialConsumptionByIDService service})
      : _service = service,
        super( MaterialConsumptionByIDInitial()) {
    on<FetchMaterialConsumptionByIDEvent>(_onFetchMaterialIssue);
  }

  Future<void> _onFetchMaterialIssue(
      FetchMaterialConsumptionByIDEvent event, Emitter<MaterialConsumptionByIDState> emit) async {
    emit( MaterialConsumptionByIDLoading());

    try {
      final raw = await _service.fetchMaterialConsumptionByIDRaw(event.consumption_id);

      // raw might already be a JSON string. If your service returns Map, adapt.
      final decoded = jsonDecode(raw);

      // Expecting the JSON shape: { "data": [ { "EmployeeId": "...", "EmployeeName": "..." }, ... ] }
      final data = decoded['data'];
      if (data == null || data is! List) {
        emit(const MaterialConsumptionByIDFailure('Something went wrong, Please try again'));
        return;
      }

      final materialConsumptionByID = data
          .map<MaterialConsumptionByID>((e) => MaterialConsumptionByID.fromJson(e as Map<String, dynamic>))
          .toList();

      emit(MaterialConsumptionByIDLoadSuccess(materialConsumptionByID));
    } catch (e) {
      emit(MaterialConsumptionByIDFailure(e.toString()));
    }
  }
}