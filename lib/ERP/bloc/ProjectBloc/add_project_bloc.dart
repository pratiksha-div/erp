import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../UI/Utils/messages_constants.dart';
import '../../api/models/AddProjectModel.dart';
import '../../api/services/add_project_service.dart';

// Event
abstract class AddProjectEvent extends Equatable {
  const AddProjectEvent();

  @override
  List<Object?> get props => [];
}

class SubmitAddProjectEvent extends AddProjectEvent {
  final String customerName;
  final String projectName;
  final String projectCoordinator;
  final String projectManager;
  final String projectType;
  final String startDate;
  final String endDate ;
  final String Expected_Cost;
  final String Status;
  final String state;
  final String Address;
  final String godownlist;
  final String project_dscription;
  final String project_id;

  const SubmitAddProjectEvent({
    required this.customerName,
    required this.projectName,
    required this.projectCoordinator,
    required this.projectManager,
    required this.projectType,
    required this.startDate,
    required this.endDate,
    required this.Expected_Cost,
    required this.Status,
    required this.state,
    required this.Address,
    required this.godownlist,
    required this.project_dscription,
    required this.project_id,
  });

  @override
  List<Object?> get props => [
    customerName,
    projectName,
    projectCoordinator,
    projectManager,
    projectType,
    startDate,
  ];
}

//State
abstract class AddProjectState extends Equatable {
  const AddProjectState();

  @override
  List<Object?> get props => [];
}

class AddProjectInitial extends AddProjectState {}

class AddProjectLoading extends AddProjectState {}

class AddProjectSuccess extends AddProjectState {
  final String message;
  final String? projectId;

  const AddProjectSuccess({required this.message, this.projectId});

  @override
  List<Object?> get props => [message, projectId ?? ''];
}

class AddProjectFailed extends AddProjectState {
  final String message;

  const AddProjectFailed(this.message);

  @override
  List<Object?> get props => [message];
}



class AddProjectBloc extends Bloc<AddProjectEvent, AddProjectState> {
  AddProjectBloc() : super(AddProjectInitial()) {
    on<SubmitAddProjectEvent>((event, emit) async {
      emit(AddProjectLoading());

      try {
        print(
          '''
          Adding project
          customerName: ${event.customerName},
          projectName: ${event.projectName},
          ProjectCo_ordinator: ${event.projectCoordinator},
          projectManager: ${event.projectManager},
          projectType: ${event.projectType},
          startDate: ${event.startDate},
          endDate: ${event.endDate},
          expectedCost: ${event.Expected_Cost},
          status: ${event.Status},
          state: ${event.state},
          address: ${event.Address},
          godownlist: ${event.godownlist},
          projectDescription: ${event.project_dscription},
          projectId: ${event.project_id},
          '''
        );
        final result = await AddProjectService().addProject(
          customerName: event.customerName,
          projectName: event.projectName,
          ProjectCo_ordinator: event.projectCoordinator,
          projectManager: event.projectManager,
          projectType: event.projectType,
          startDate: event.startDate,
          endDate: event.endDate,
          expectedCost: event.Expected_Cost,
          status: event.Status,
          state: event.state,
          address: event.Address,
          godownlist: event.godownlist,
          projectDescription: event.project_dscription,
          projectId: event.project_id,
        );

        print("Add Project API Response: $result");

        if (result is BaseResponse) {
          Fluttertoast.showToast(msg: result.massage ?? "Project Saved");
          emit(AddProjectSuccess(message: result.massage??""));

        } else {
          emit(AddProjectFailed(result.massage ?? "Something went wrong"));
        }
      } catch (e, st) {
        print("Add Project Exception: $e\n$st");
        emit(AddProjectFailed(ConstantsMessage.serveError));
      }
    });
  }
}
