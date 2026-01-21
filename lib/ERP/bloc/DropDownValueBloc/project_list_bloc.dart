import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../api/models/DAOGetProjectList.dart';
import '../../api/services/dropdown_value_service.dart';

//*********** ProjectListEvent ***********//
abstract class ProjectListEvent extends Equatable {
  const ProjectListEvent();

  @override
  List<Object?> get props => [];
}

/// Trigger fetching ProjectLists from API
class FetchProjectListsEvent extends ProjectListEvent {
  const FetchProjectListsEvent();
}


//*********** ProjectListState ***********//
abstract class ProjectListState extends Equatable {
  const ProjectListState();

  @override
  List<Object?> get props => [];
}

class ProjectListInitial extends ProjectListState {
  const ProjectListInitial();
}

class ProjectListLoading extends ProjectListState {
  const ProjectListLoading();
}

/// Success state contains the parsed list of ProjectLists
class ProjectListLoadSuccess extends ProjectListState {
  final List<ProjectListData> projectLists;
  const ProjectListLoadSuccess(this.projectLists);

  @override
  List<Object?> get props => [projectLists];
}

class ProjectListLoadFailure extends ProjectListState {
  final String message;
  const ProjectListLoadFailure(this.message);

  @override
  List<Object?> get props => [message];
}


// ********* Interface expected by the bloc *************//
abstract class ProjectListService {
  Future<String> fetchProjectListsRaw();
}

/// Adapter that uses your existing ProjectListServices class
class ProjectListServiceAdapter implements ProjectListService {
  final DropdownServices _dropDownService;

  ProjectListServiceAdapter({DropdownServices? dropDownService})
      : _dropDownService = dropDownService ?? DropdownServices();

  @override
  Future<String> fetchProjectListsRaw() async {

    // call the existing async method and return its result
    final result = await _dropDownService.getProjectList();
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


//************** ProjectListBloc **************//


/// Bloc implementation
class ProjectListBloc extends Bloc<ProjectListEvent, ProjectListState> {
  final ProjectListService _service;

  ProjectListBloc({required ProjectListService service})
      : _service = service,
        super(const ProjectListInitial()) {
    on<FetchProjectListsEvent>(_onFetchProjectLists);
  }

  Future<void> _onFetchProjectLists(
      FetchProjectListsEvent event, Emitter<ProjectListState> emit) async {
    emit(const ProjectListLoading());

    try {
      final raw = await _service.fetchProjectListsRaw();

      // raw might already be a JSON string. If your service returns Map, adapt.
      final decoded = jsonDecode(raw);

      // Expecting the JSON shape: { "data": [ { "ProjectListId": "...", "ProjectListName": "..." }, ... ] }
      final data = decoded['data'];
      if (data == null || data is! List) {
        emit(const ProjectListLoadFailure('Something went wrong, Please try again'));
        return;
      }

      final ProjectLists = data
          .map<ProjectListData>((e) => ProjectListData.fromJson(e as Map<String, dynamic>))
          .toList();

      emit(ProjectListLoadSuccess(ProjectLists));
    } catch (e) {
      emit(ProjectListLoadFailure(e.toString()));
    }
  }
}




