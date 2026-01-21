import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../api/models/DAOGetMaterialConsumption.dart';
import '../../api/services/dropdown_value_service.dart';

// MaterialConsumptionUsedEvent
abstract class MaterialConsumptionUsedEvent extends Equatable {
  const MaterialConsumptionUsedEvent();

  @override
  List<Object?> get props => [];
}

class FetchMaterialConsumptionUsedEvent extends MaterialConsumptionUsedEvent {
  final String projectId;
  final String consumedDate;

  const FetchMaterialConsumptionUsedEvent({required this.projectId,required this.consumedDate});

  @override
  List<Object?> get props => [projectId,consumedDate];
}


// MaterialConsumptionUsedState
abstract class MaterialConsumptionUsedState extends Equatable {
  const MaterialConsumptionUsedState();

  @override
  List<Object?> get props => [];
}

class MaterialConsumptionUsedInitial extends MaterialConsumptionUsedState {}

class MaterialConsumptionUsedLoading extends MaterialConsumptionUsedState {}

class MaterialConsumptionUsedLoadSuccess extends MaterialConsumptionUsedState {
  final List<MaterialConsumptionUsedData> materials;

  const MaterialConsumptionUsedLoadSuccess(this.materials);

  @override
  List<Object?> get props => [materials];
}

class MaterialConsumptionUsedFailure extends MaterialConsumptionUsedState {
  final String error;

  const MaterialConsumptionUsedFailure(this.error);

  @override
  List<Object?> get props => [error];
}


// ********* Interface expected by the bloc *************//
abstract class MaterialConsumptionUsedService {
  Future<String> fetchMaterialConsumptionUsedRaw(String id,String consumedDate);
}



/// Adapter that uses your existing EmployeeServices class
class MaterialConsumptionUsedServiceAdapter implements MaterialConsumptionUsedService {
  final DropdownServices _dropDownService;

  MaterialConsumptionUsedServiceAdapter({DropdownServices? dropDownService})
      : _dropDownService = dropDownService ?? DropdownServices();

  @override
  @override
  Future<String> fetchMaterialConsumptionUsedRaw(String id,String date) async {
    final result = await _dropDownService.getMaterialConsumptionUsed(id,date);
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
class MaterialConsumptionUsedBloc extends Bloc<MaterialConsumptionUsedEvent, MaterialConsumptionUsedState> {
  final MaterialConsumptionUsedService _service;

  MaterialConsumptionUsedBloc({required MaterialConsumptionUsedService service})
      : _service = service,
        super( MaterialConsumptionUsedInitial()) {
    on<FetchMaterialConsumptionUsedEvent>(_onFetchMaterialIssue);
  }

  Future<void> _onFetchMaterialIssue(
      FetchMaterialConsumptionUsedEvent event, Emitter<MaterialConsumptionUsedState> emit) async {
    emit( MaterialConsumptionUsedLoading());

    try {
      final raw = await _service.fetchMaterialConsumptionUsedRaw(event.projectId,event.consumedDate);

      // raw might already be a JSON string. If your service returns Map, adapt.
      final decoded = jsonDecode(raw);

      // Expecting the JSON shape: { "data": [ { "EmployeeId": "...", "EmployeeName": "..." }, ... ] }
      final data = decoded['data'];
      if (data == null || data is! List) {
        emit(const MaterialConsumptionUsedFailure('Something went wrong, Please try again'));
        return;
      }

      final MaterialConsumptionUsed = data
          .map<MaterialConsumptionUsedData>((e) => MaterialConsumptionUsedData.fromJson(e as Map<String, dynamic>))
          .toList();

      emit(MaterialConsumptionUsedLoadSuccess(MaterialConsumptionUsed));
    } catch (e) {
      emit(MaterialConsumptionUsedFailure(e.toString()));
    }
  }
}


