import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../UI/Utils/messages_constants.dart';
import '../../api/models/AddProjectModel.dart';
import '../../api/services/add_gate_pass_service.dart';
import '../../api/services/add_machine_reading_service.dart';
import '../../api/services/add_project_service.dart';
import '../../api/services/get_project_service.dart';

// Event
abstract class DeleteMachineReadingEvent extends Equatable {
  const DeleteMachineReadingEvent();

  @override
  List<Object?> get props => [];
}

class SubmitDeleteMachineReadingEvent extends DeleteMachineReadingEvent {
  final String readingid;

  const SubmitDeleteMachineReadingEvent({
    required this.readingid,
  });

  @override
  List<Object?> get props => [
    readingid,
  ];
}

//State
abstract class DeleteMachineReadingState extends Equatable {
  const DeleteMachineReadingState();

  @override
  List<Object?> get props => [];
}

class DeleteMachineReadingInitial extends DeleteMachineReadingState {}

class DeleteMachineReadingLoading extends DeleteMachineReadingState {}

class DeleteMachineReadingSuccess extends DeleteMachineReadingState {
  final String message;

  const DeleteMachineReadingSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class DeleteMachineReadingFailed extends DeleteMachineReadingState {
  final String message;

  const DeleteMachineReadingFailed(this.message);

  @override
  List<Object?> get props => [message];
}



class DeleteMachineReadingBloc extends Bloc<DeleteMachineReadingEvent, DeleteMachineReadingState> {
  DeleteMachineReadingBloc() : super(DeleteMachineReadingInitial()) {
    on<SubmitDeleteMachineReadingEvent>((event, emit) async {
      emit(DeleteMachineReadingLoading());

      try {
        final result = await DeleteMachineReadingService().deleteMachineReadingsData(event.readingid,);
        if (result is BaseResponse) {
          emit(DeleteMachineReadingSuccess(message: 'Entry Deleted'));

        } else {
          emit(const DeleteMachineReadingFailed("Failed to Delete Entry"));
        }
      } catch (e, st) {
        print("Add Project Exception: $e\n$st");
        emit(DeleteMachineReadingFailed(ConstantsMessage.serveError));
      }
    });
  }
}
