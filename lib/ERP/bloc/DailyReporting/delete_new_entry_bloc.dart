import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../UI/Utils/messages_constants.dart';
import '../../api/models/AddProjectModel.dart';
import '../../api/services/add_gate_pass_service.dart';
import '../../api/services/add_machine_reading_service.dart';
import '../../api/services/add_material_consumption.dart';
import '../../api/services/add_new_entry.dart';
import '../../api/services/add_project_service.dart';
import '../../api/services/get_project_service.dart';

// Event
abstract class DeleteNewEntryEvent extends Equatable {
  const DeleteNewEntryEvent();

  @override
  List<Object?> get props => [];
}

class SubmitDeleteNewEntryEvent extends DeleteNewEntryEvent {
  final String work_detail_id;

  const SubmitDeleteNewEntryEvent({
    required this.work_detail_id,
  });

  @override
  List<Object?> get props => [
    work_detail_id,
  ];
}

//State
abstract class DeleteNewEntryState extends Equatable {
  const DeleteNewEntryState();

  @override
  List<Object?> get props => [];
}

class DeleteNewEntryInitial extends DeleteNewEntryState {}

class DeleteNewEntryLoading extends DeleteNewEntryState {}

class DeleteNewEntrySuccess extends DeleteNewEntryState {
  final String message;

  const DeleteNewEntrySuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class DeleteNewEntryFailed extends DeleteNewEntryState {
  final String message;

  const DeleteNewEntryFailed(this.message);

  @override
  List<Object?> get props => [message];
}



class DeleteNewEntryBloc extends Bloc<DeleteNewEntryEvent, DeleteNewEntryState> {
  DeleteNewEntryBloc() : super(DeleteNewEntryInitial()) {
    on<SubmitDeleteNewEntryEvent>((event, emit) async {
      emit(DeleteNewEntryLoading());

      try {
        final result = await DeleteEntryService().deleteEntrysData(event.work_detail_id,);
        if (result is BaseResponse) {
          emit(DeleteNewEntrySuccess(message: 'Entry Deleted'));

        } else {
          emit(const DeleteNewEntryFailed("Failed to Delete Entry"));
        }
      } catch (e, st) {
        print("Add Project Exception: $e\n$st");
        emit(DeleteNewEntryFailed(ConstantsMessage.serveError));
      }
    });
  }
}
