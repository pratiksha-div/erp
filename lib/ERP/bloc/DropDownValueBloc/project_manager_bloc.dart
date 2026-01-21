import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../api/models/DAOGetProjectCoordinator.dart';
import '../../api/services/dropdown_value_service.dart';

//*********** ProjectManagerEvent ***********//
abstract class ProjectManagerEvent extends Equatable {
  const ProjectManagerEvent();

  @override
  List<Object?> get props => [];
}

/// Trigger fetching ProjectManagers from API
class FetchProjectManagersEvent extends ProjectManagerEvent {
  const FetchProjectManagersEvent();
}


//*********** ProjectManagerState ***********//
abstract class ProjectManagerState extends Equatable {
  const ProjectManagerState();

  @override
  List<Object?> get props => [];
}

class ProjectManagerInitial extends ProjectManagerState {
  const ProjectManagerInitial();
}

class ProjectManagerLoading extends ProjectManagerState {
  const ProjectManagerLoading();
}

/// Success state contains the parsed list of ProjectManagers
class ProjectManagerLoadSuccess extends ProjectManagerState {
  final List<ProjectCoordinateData> ProjectManagers;
  const ProjectManagerLoadSuccess(this.ProjectManagers);

  @override
  List<Object?> get props => [ProjectManagers];
}

class ProjectManagerLoadFailure extends ProjectManagerState {
  final String message;
  const ProjectManagerLoadFailure(this.message);

  @override
  List<Object?> get props => [message];
}


// ********* Interface expected by the bloc *************//
abstract class ProjectManagerService {
  Future<String> fetchProjectManagersRaw();
}

/// Adapter that uses your existing ProjectManagerServices class
class ProjectManagerServiceAdapter implements ProjectManagerService {
  final DropdownServices _dropDownService;

  ProjectManagerServiceAdapter({DropdownServices? dropDownService})
      : _dropDownService = dropDownService ?? DropdownServices();

  @override
  Future<String> fetchProjectManagersRaw() async {

    // call the existing async method and return its result
    final result = await _dropDownService.getProjectManager();
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


//************** ProjectManagerBloc **************//


/// Bloc implementation
class ProjectManagerBloc extends Bloc<ProjectManagerEvent, ProjectManagerState> {
  final ProjectManagerService _service;

  ProjectManagerBloc({required ProjectManagerService service})
      : _service = service,
        super(const ProjectManagerInitial()) {
    on<FetchProjectManagersEvent>(_onFetchProjectManagers);
  }

  Future<void> _onFetchProjectManagers(
      FetchProjectManagersEvent event, Emitter<ProjectManagerState> emit) async {
    emit(const ProjectManagerLoading());

    try {
      final raw = await _service.fetchProjectManagersRaw();

      // raw might already be a JSON string. If your service returns Map, adapt.
      final decoded = jsonDecode(raw);

      // Expecting the JSON shape: { "data": [ { "ProjectManagerId": "...", "ProjectManagerName": "..." }, ... ] }
      final data = decoded['data'];
      if (data == null || data is! List) {
        emit(const ProjectManagerLoadFailure('Something went wrong, Please try again'));
        return;
      }

      final ProjectManagers = data
          .map<ProjectCoordinateData>((e) => ProjectCoordinateData.fromJson(e as Map<String, dynamic>))
          .toList();

      emit(ProjectManagerLoadSuccess(ProjectManagers));
    } catch (e) {
      emit(ProjectManagerLoadFailure(e.toString()));
    }
  }
}




