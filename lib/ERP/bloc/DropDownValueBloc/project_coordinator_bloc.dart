import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../api/models/DAOGetProjectCoordinator.dart';
import '../../api/services/dropdown_value_service.dart';

//*********** ProjectCoordinatorEvent ***********//
abstract class ProjectCoordinatorEvent extends Equatable {
  const ProjectCoordinatorEvent();

  @override
  List<Object?> get props => [];
}

/// Trigger fetching ProjectCoordinators from API
class FetchProjectCoordinatorsEvent extends ProjectCoordinatorEvent {
  const FetchProjectCoordinatorsEvent();
}


//*********** ProjectCoordinatorState ***********//
abstract class ProjectCoordinatorState extends Equatable {
  const ProjectCoordinatorState();

  @override
  List<Object?> get props => [];
}

class ProjectCoordinatorInitial extends ProjectCoordinatorState {
  const ProjectCoordinatorInitial();
}

class ProjectCoordinatorLoading extends ProjectCoordinatorState {
  const ProjectCoordinatorLoading();
}

/// Success state contains the parsed list of ProjectCoordinators
class ProjectCoordinatorLoadSuccess extends ProjectCoordinatorState {
  final List<ProjectCoordinateData> ProjectCoordinators;
  const ProjectCoordinatorLoadSuccess(this.ProjectCoordinators);

  @override
  List<Object?> get props => [ProjectCoordinators];
}

class ProjectCoordinatorLoadFailure extends ProjectCoordinatorState {
  final String message;
  const ProjectCoordinatorLoadFailure(this.message);

  @override
  List<Object?> get props => [message];
}


// ********* Interface expected by the bloc *************//
abstract class ProjectCoordinatorService {
  Future<String> fetchProjectCoordinatorsRaw();
}

/// Adapter that uses your existing ProjectCoordinatorServices class
class ProjectCoordinatorServiceAdapter implements ProjectCoordinatorService {
  final DropdownServices _dropDownService;

  ProjectCoordinatorServiceAdapter({DropdownServices? dropDownService})
      : _dropDownService = dropDownService ?? DropdownServices();

  @override
  Future<String> fetchProjectCoordinatorsRaw() async {

    // call the existing async method and return its result
    final result = await _dropDownService.getProjectCoordinator();
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


//************** ProjectCoordinatorBloc **************//


/// Bloc implementation
class ProjectCoordinatorBloc extends Bloc<ProjectCoordinatorEvent, ProjectCoordinatorState> {
  final ProjectCoordinatorService _service;

  ProjectCoordinatorBloc({required ProjectCoordinatorService service})
      : _service = service,
        super(const ProjectCoordinatorInitial()) {
    on<FetchProjectCoordinatorsEvent>(_onFetchProjectCoordinators);
  }

  Future<void> _onFetchProjectCoordinators(
      FetchProjectCoordinatorsEvent event, Emitter<ProjectCoordinatorState> emit) async {
    emit(const ProjectCoordinatorLoading());

    try {
      final raw = await _service.fetchProjectCoordinatorsRaw();

      // raw might already be a JSON string. If your service returns Map, adapt.
      final decoded = jsonDecode(raw);

      // Expecting the JSON shape: { "data": [ { "ProjectCoordinatorId": "...", "ProjectCoordinatorName": "..." }, ... ] }
      final data = decoded['data'];
      if (data == null || data is! List) {
        emit(const ProjectCoordinatorLoadFailure('Something went wrong, Please try again'));
        return;
      }

      final ProjectCoordinators = data
          .map<ProjectCoordinateData>((e) => ProjectCoordinateData.fromJson(e as Map<String, dynamic>))
          .toList();

      emit(ProjectCoordinatorLoadSuccess(ProjectCoordinators));
    } catch (e) {
      emit(ProjectCoordinatorLoadFailure(e.toString()));
    }
  }
}




