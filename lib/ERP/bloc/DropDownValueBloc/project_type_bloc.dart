import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../api/models/DAOProjectType.dart';
import '../../api/services/dropdown_value_service.dart';

//*********** ProjectTypeEvent ***********//
abstract class ProjectTypeEvent extends Equatable {
  const ProjectTypeEvent();

  @override
  List<Object?> get props => [];
}

/// Trigger fetching ProjectTypes from API
class FetchProjectTypesEvent extends ProjectTypeEvent {
  const FetchProjectTypesEvent();
}


//*********** ProjectTypeState ***********//
abstract class ProjectTypeState extends Equatable {
  const ProjectTypeState();

  @override
  List<Object?> get props => [];
}

class ProjectTypeInitial extends ProjectTypeState {
  const ProjectTypeInitial();
}

class ProjectTypeLoading extends ProjectTypeState {
  const ProjectTypeLoading();
}

/// Success state contains the parsed list of ProjectTypes
class ProjectTypeLoadSuccess extends ProjectTypeState {
  final List<ProjectTypeData> ProjectTypes;
  const ProjectTypeLoadSuccess(this.ProjectTypes);

  @override
  List<Object?> get props => [ProjectTypes];
}

class ProjectTypeLoadFailure extends ProjectTypeState {
  final String message;
  const ProjectTypeLoadFailure(this.message);

  @override
  List<Object?> get props => [message];
}


// ********* Interface expected by the bloc *************//
abstract class ProjectTypeService {
  Future<String> fetchProjectTypesRaw();
}

/// Adapter that uses your existing ProjectTypeServices class
class ProjectTypeServiceAdapter implements ProjectTypeService {
  final DropdownServices _dropDownService;

  ProjectTypeServiceAdapter({DropdownServices? dropDownService})
      : _dropDownService = dropDownService ?? DropdownServices();

  @override
  Future<String> fetchProjectTypesRaw() async {

    // call the existing async method and return its result
    final result = await _dropDownService.getProjectTypes();
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


//************** ProjectTypeBloc **************//


/// Bloc implementation
class ProjectTypeBloc extends Bloc<ProjectTypeEvent, ProjectTypeState> {
  final ProjectTypeService _service;

  ProjectTypeBloc({required ProjectTypeService service})
      : _service = service,
        super(const ProjectTypeInitial()) {
    on<FetchProjectTypesEvent>(_onFetchProjectTypes);
  }

  Future<void> _onFetchProjectTypes(
      FetchProjectTypesEvent event, Emitter<ProjectTypeState> emit) async {
    emit(const ProjectTypeLoading());

    try {
      final raw = await _service.fetchProjectTypesRaw();

      // raw might already be a JSON string. If your service returns Map, adapt.
      final decoded = jsonDecode(raw);

      // Expecting the JSON shape: { "data": [ { "ProjectTypeId": "...", "ProjectTypeName": "..." }, ... ] }
      final data = decoded['data'];
      if (data == null || data is! List) {
        emit(const ProjectTypeLoadFailure('Something went wrong, Please try again'));
        return;
      }

      final ProjectTypes = data
          .map<ProjectTypeData>((e) => ProjectTypeData.fromJson(e as Map<String, dynamic>))
          .toList();

      emit(ProjectTypeLoadSuccess(ProjectTypes));
    } catch (e) {
      emit(ProjectTypeLoadFailure(e.toString()));
    }
  }
}




