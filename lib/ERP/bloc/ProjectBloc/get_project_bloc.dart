import 'package:equatable/equatable.dart';
import '../../api/models/DAOGetProject.dart';
import 'package:bloc/bloc.dart';
import 'dart:convert';
import '../../api/models/DAOGetProject.dart';
import '../../api/services/get_project_service.dart';

//event
abstract class ProjectEvent extends Equatable {
  const ProjectEvent();

  @override
  List<Object?> get props => [];
}

/// Trigger fetching projects with pagination
class FetchProjectsEvent extends ProjectEvent {
  final int start;
  final int length;
  final String project_name;

  const FetchProjectsEvent({required this.start, required this.length,required this.project_name});

  @override
  List<Object?> get props => [start, length,project_name];
}


//sate
abstract class ProjectState extends Equatable {
  const ProjectState();

  @override
  List<Object?> get props => [];
}

class ProjectInitial extends ProjectState {
  const ProjectInitial();
}

class ProjectLoading extends ProjectState {
  const ProjectLoading();
}

class ProjectLoadSuccess extends ProjectState {
  final List<ProjectData> projects;
  final int recordsTotal;

  ProjectLoadSuccess(this.projects,this.recordsTotal);

  @override
  List<Object?> get props => [projects,recordsTotal];
}

class ProjectLoadFailure extends ProjectState {
  final String message;

  const ProjectLoadFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  final ProjectService _service;

  ProjectBloc({required ProjectService service})
      : _service = service,
        super(const ProjectInitial()) {
    on<FetchProjectsEvent>(_onFetchProjects);
  }

  Future<void> _onFetchProjects(FetchProjectsEvent event, Emitter<ProjectState> emit) async {
    emit(const ProjectLoading());

    try {
      final raw = await _service.fetchProjectsRaw(start: event.start, length: event.length,project_name: event.project_name);
      final decoded = jsonDecode(raw);

      final data = decoded['data'];
      final recordsTotal = decoded['recordsTotal'];
      if (data == null || data is! List) {
        emit(const ProjectLoadFailure('Something went wrong, Please try again'));
        return;
      }

      final projects = data
          .map<ProjectData>((e) => ProjectData.fromJson(e as Map<String, dynamic>))
          .toList();

      emit(ProjectLoadSuccess(projects,recordsTotal));
    } catch (e) {
      emit(ProjectLoadFailure(e.toString()));
    }
  }
}

