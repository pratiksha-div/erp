import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../api/models/DAOGetProject.dart';
import '../../api/models/DAOGetProjectData.dart';
import '../../api/services/get_project_service.dart';

// ProjectDataEvent
abstract class ProjectDataEvent extends Equatable {
  const ProjectDataEvent();

  @override
  List<Object?> get props => [];
}

class FetchProjectDataEvent extends ProjectDataEvent {
  final String projectId;

  const FetchProjectDataEvent({required this.projectId});

  @override
  List<Object?> get props => [projectId];
}


// ProjectDataState
abstract class ProjectDataState extends Equatable {
  const ProjectDataState();

  @override
  List<Object?> get props => [];
}

class ProjectDataInitial extends ProjectDataState {}

class ProjectDataLoading extends ProjectDataState {}

class ProjectDataLoadSuccess extends ProjectDataState {
  final List<GetProjectData> projectData;

  const ProjectDataLoadSuccess(this.projectData);

  @override
  List<Object?> get props => [projectData];
}

class ProjectDataFailure extends ProjectDataState {
  final String error;

  const ProjectDataFailure(this.error);

  @override
  List<Object?> get props => [error];
}


// ********* Interface expected by the bloc *************//
abstract class ProjectDataService {
  Future<String> fetchProjectDataRaw(String godownId);
}



/// Adapter that uses your existing EmployeeServices class
class ProjectDataServiceAdapter implements ProjectDataService {
  final GetProjectDataService _projectDataService;

  ProjectDataServiceAdapter({GetProjectDataService? projectDataService})
      : _projectDataService = projectDataService ?? GetProjectDataService();

  @override
  Future<String> fetchProjectDataRaw(String Id) async {
    final result = await _projectDataService.fetchProjectsData(Id);
    if (result is String) return result;
    try {
      return result != null ? result.toString() : '{}';
    } catch (_) {
      return '{}';
    }
  }

}



/// Bloc implementation
class ProjectDataBloc extends Bloc<ProjectDataEvent, ProjectDataState> {
  final ProjectDataService _service;

  ProjectDataBloc({required ProjectDataService service})
      : _service = service,
        super( ProjectDataInitial()) {
    on<FetchProjectDataEvent>(_onFetchMaterialIssue);
  }

  Future<void> _onFetchMaterialIssue(
      FetchProjectDataEvent event, Emitter<ProjectDataState> emit) async {
    emit( ProjectDataLoading());

    try {
      final raw = await _service.fetchProjectDataRaw(event.projectId);

      // raw might already be a JSON string. If your service returns Map, adapt.
      final decoded = jsonDecode(raw);

      // Expecting the JSON shape: { "data": [ { "EmployeeId": "...", "EmployeeName": "..." }, ... ] }
      final data = decoded['data'];
      if (data == null || data is! List) {
        emit(const ProjectDataFailure('Something went wrong, Please try again'));
        return;
      }

      final projectData = data
          .map<GetProjectData>((e) => GetProjectData.fromJson(e as Map<String, dynamic>))
          .toList();

      emit(ProjectDataLoadSuccess(projectData));
    } catch (e) {
      emit(ProjectDataFailure(e.toString()));
    }
  }
}