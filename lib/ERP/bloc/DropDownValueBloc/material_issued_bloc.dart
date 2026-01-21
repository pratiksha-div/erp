import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../api/models/DAOGetMaterialIssued.dart';
import '../../api/services/dropdown_value_service.dart';

// MaterialIssuedEvent
abstract class MaterialIssuedEvent extends Equatable {
  const MaterialIssuedEvent();

  @override
  List<Object?> get props => [];
}

class FetchMaterialIssuedEvent extends MaterialIssuedEvent {
  final String godownId;

  const FetchMaterialIssuedEvent({required this.godownId});

  @override
  List<Object?> get props => [godownId];
}


// MaterialIssuedState
abstract class MaterialIssuedState extends Equatable {
  const MaterialIssuedState();

  @override
  List<Object?> get props => [];
}

class MaterialIssuedInitial extends MaterialIssuedState {}

class MaterialIssuedLoading extends MaterialIssuedState {}

class MaterialIssuedLoadSuccess extends MaterialIssuedState {
  final List<MaterialIssuedData> materials;

  const MaterialIssuedLoadSuccess(this.materials);

  @override
  List<Object?> get props => [materials];
}

class MaterialIssuedFailure extends MaterialIssuedState {
  final String error;

  const MaterialIssuedFailure(this.error);

  @override
  List<Object?> get props => [error];
}


// ********* Interface expected by the bloc *************//
abstract class MaterialIssuedService {
  Future<String> fetchMaterialIssuedRaw(String godownId);
}



/// Adapter that uses your existing EmployeeServices class
class MaterialIssuedServiceAdapter implements MaterialIssuedService {
  final DropdownServices _dropDownService;

  MaterialIssuedServiceAdapter({DropdownServices? dropDownService})
      : _dropDownService = dropDownService ?? DropdownServices();

  @override
  Future<String> fetchMaterialIssuedRaw(String godownId) async {
    final result = await _dropDownService.getMaterialIssued(godownId);
    if (result is String) return result;
    try {
      return result != null ? result.toString() : '{}';
    } catch (_) {
      return '{}';
    }
  }

}


//************** MaterialIssuedBloc **************//


/// Bloc implementation
class MaterialIssuedBloc extends Bloc<MaterialIssuedEvent, MaterialIssuedState> {
  final MaterialIssuedService _service;

  MaterialIssuedBloc({required MaterialIssuedService service})
      : _service = service,
        super( MaterialIssuedInitial()) {
    on<FetchMaterialIssuedEvent>(_onFetchMaterialIssue);
  }

  Future<void> _onFetchMaterialIssue(
      FetchMaterialIssuedEvent event, Emitter<MaterialIssuedState> emit) async {
    emit( MaterialIssuedLoading());

    try {
      final raw = await _service.fetchMaterialIssuedRaw(event.godownId);

      // raw might already be a JSON string. If your service returns Map, adapt.
      final decoded = jsonDecode(raw);

      // Expecting the JSON shape: { "data": [ { "EmployeeId": "...", "EmployeeName": "..." }, ... ] }
      final data = decoded['data'];
      if (data == null || data is! List) {
        emit(const MaterialIssuedFailure('Something went wrong, Please try again'));
        return;
      }

      final materialIssued = data
          .map<MaterialIssuedData>((e) => MaterialIssuedData.fromJson(e as Map<String, dynamic>))
          .toList();

      emit(MaterialIssuedLoadSuccess(materialIssued));
    } catch (e) {
      emit(MaterialIssuedFailure(e.toString()));
    }
  }
}


