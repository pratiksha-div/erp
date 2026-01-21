import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../UI/Utils/messages_constants.dart';
import '../../api/models/AddProjectModel.dart';
import '../../api/services/add_gate_pass_service.dart';

// Event
abstract class DeleteGatePassEvent extends Equatable {
  const DeleteGatePassEvent();

  @override
  List<Object?> get props => [];
}

class SubmitDeleteGatePassEvent extends DeleteGatePassEvent {
  final String gatepass_id;

  const SubmitDeleteGatePassEvent({
    required this.gatepass_id,
  });

  @override
  List<Object?> get props => [
    gatepass_id,
  ];
}

//State
abstract class DeleteGatePassState extends Equatable {
  const DeleteGatePassState();

  @override
  List<Object?> get props => [];
}

class DeleteGatePassInitial extends DeleteGatePassState {}

class DeleteGatePassLoading extends DeleteGatePassState {}

class DeleteGatePassSuccess extends DeleteGatePassState {
  final String message;

  const DeleteGatePassSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class DeleteGatePassFailed extends DeleteGatePassState {
  final String message;

  const DeleteGatePassFailed(this.message);

  @override
  List<Object?> get props => [message];
}



class DeleteGatePassBloc extends Bloc<DeleteGatePassEvent, DeleteGatePassState> {
  DeleteGatePassBloc() : super(DeleteGatePassInitial()) {
    on<SubmitDeleteGatePassEvent>((event, emit) async {
      emit(DeleteGatePassLoading());

      try {
        final result = await DeleteGatePassService().deleteGatePasssData(event.gatepass_id,);
        if (result is BaseResponse) {
          emit(DeleteGatePassSuccess(message: 'Gate Pass Deleted'));
        } else {
          emit(DeleteGatePassFailed("Failed to Delete Gate Pass"));
        }
      } catch (e, st) {
        print("Delete Gate Pass Exception: $e\n$st");
        emit(DeleteGatePassFailed(ConstantsMessage.serveError));
      }
    });
  }
}
