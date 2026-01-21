import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../UI/Utils/messages_constants.dart';
import '../../api/models/AddProjectModel.dart';
import '../../api/services/add_gate_pass_service.dart';
import '../../api/services/add_project_service.dart';
import '../../api/services/gate_entry_service.dart';
import '../../api/services/get_project_service.dart';

// Event
abstract class DeleteGateEntryEvent extends Equatable {
  const DeleteGateEntryEvent();

  @override
  List<Object?> get props => [];
}

class SubmitDeleteGateEntryEvent extends DeleteGateEntryEvent {
  final String gate_entry_id;

  const SubmitDeleteGateEntryEvent({
    required this.gate_entry_id,
  });

  @override
  List<Object?> get props => [
    gate_entry_id,
  ];
}

//State
abstract class DeleteGateEntryState extends Equatable {
  const DeleteGateEntryState();

  @override
  List<Object?> get props => [];
}

class DeleteGateEntryInitial extends DeleteGateEntryState {}

class DeleteGateEntryLoading extends DeleteGateEntryState {}

class DeleteGateEntrySuccess extends DeleteGateEntryState {
  final String message;

  const DeleteGateEntrySuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class DeleteGateEntryFailed extends DeleteGateEntryState {
  final String message;

  const DeleteGateEntryFailed(this.message);

  @override
  List<Object?> get props => [message];
}



class DeleteGateEntryBloc extends Bloc<DeleteGateEntryEvent, DeleteGateEntryState> {
  DeleteGateEntryBloc() : super(DeleteGateEntryInitial()) {
    on<SubmitDeleteGateEntryEvent>((event, emit) async {
      emit(DeleteGateEntryLoading());

      try {
        final result = await DeleteGateEntryService().deleteGateEntryService(event.gate_entry_id);
        if (result is BaseResponse) {
          emit(DeleteGateEntrySuccess(message: 'Gate Entry Deleted'));

        } else {
          emit(const DeleteGateEntryFailed("Failed to Delete Gate Pass"));
        }
      } catch (e, st) {
        print("Add Project Exception: $e\n$st");
        emit(DeleteGateEntryFailed(ConstantsMessage.serveError));
      }
    });
  }
}
