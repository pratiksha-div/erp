import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../UI/Utils/messages_constants.dart';
import '../../api/models/AddProjectModel.dart';
import '../../api/services/add_project_service.dart';
import '../../api/services/get_project_service.dart';

// Event
abstract class DeleteProjectEvent extends Equatable {
  const DeleteProjectEvent();

  @override
  List<Object?> get props => [];
}

class SubmitDeleteProjectEvent extends DeleteProjectEvent {
  final String project_id;

  const SubmitDeleteProjectEvent({
    required this.project_id,
  });

  @override
  List<Object?> get props => [
    project_id,
  ];
}

//State
abstract class DeleteProjectState extends Equatable {
  const DeleteProjectState();

  @override
  List<Object?> get props => [];
}

class DeleteProjectInitial extends DeleteProjectState {}

class DeleteProjectLoading extends DeleteProjectState {}

class DeleteProjectSuccess extends DeleteProjectState {
  final String message;

  const DeleteProjectSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class DeleteProjectFailed extends DeleteProjectState {
  final String message;

  const DeleteProjectFailed(this.message);

  @override
  List<Object?> get props => [message];
}



class DeleteProjectBloc extends Bloc<DeleteProjectEvent, DeleteProjectState> {
  DeleteProjectBloc() : super(DeleteProjectInitial()) {
    on<SubmitDeleteProjectEvent>((event, emit) async {
      emit(DeleteProjectLoading());

      try {
        final result = await DeleteProjectService().deleteProjectsData(event.project_id,);
        if (result is BaseResponse) {
          emit(DeleteProjectSuccess(message: 'Project Deleted'));

        } else {
          emit(const DeleteProjectFailed("Failed to Delete Project"));
        }
      } catch (e, st) {
        print("Add Project Exception: $e\n$st");
        emit(DeleteProjectFailed(ConstantsMessage.serveError));
      }
    });
  }
}
