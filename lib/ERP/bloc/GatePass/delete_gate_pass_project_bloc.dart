import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../UI/Utils/messages_constants.dart';
import '../../api/models/AddProjectModel.dart';
import '../../api/services/add_gate_pass_service.dart';

abstract class DeleteGatePassProjectEvent extends Equatable {
  const DeleteGatePassProjectEvent();

  @override
  List<Object?> get props => [];
}

class SubmitDeleteGatePassProjectEvent extends DeleteGatePassProjectEvent {
  final String gate_pass;
  final String from_warehouse_id;
  final String to_project_name;
  final String issued_material;
  final String quantity;
  final String out_time;
  final String consumed;
  final String date;

  const SubmitDeleteGatePassProjectEvent({
    required this.gate_pass,
    required this.from_warehouse_id,
    required this.to_project_name,
    required this.issued_material,
    required this.quantity,
    required this.out_time,
    required this.consumed,
    required this.date,
  });

  @override
  List<Object?> get props => [
    gate_pass,
    from_warehouse_id,
    to_project_name,
    issued_material,
    quantity,
    out_time,
    consumed,
    date
  ];
}

//State
abstract class DeleteGatePassProjectState extends Equatable {
  const DeleteGatePassProjectState();

  @override
  List<Object?> get props => [];
}

class DeleteGatePassProjectInitial extends DeleteGatePassProjectState {}

class DeleteGatePassProjectLoading extends DeleteGatePassProjectState {}

class DeleteGatePassProjectSuccess extends DeleteGatePassProjectState {
  final String message;

  const DeleteGatePassProjectSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class DeleteGatePassProjectFailed extends DeleteGatePassProjectState {
  final String message;

  const DeleteGatePassProjectFailed(this.message);

  @override
  List<Object?> get props => [message];
}



class DeleteGatePassProjectBloc extends Bloc<DeleteGatePassProjectEvent, DeleteGatePassProjectState> {
  DeleteGatePassProjectBloc() : super(DeleteGatePassProjectInitial()) {
    on<SubmitDeleteGatePassProjectEvent>((event, emit) async {
      emit(DeleteGatePassProjectLoading());

      try {
        final result = await DeleteGatePassService().deleteGatePassProject(
          event.gate_pass,
          event.from_warehouse_id,
          event.to_project_name,
          event.issued_material,
          event.quantity,
          event.out_time,
          event.consumed,
          event.date
        );
        if (result is BaseResponse) {
          emit(const DeleteGatePassProjectSuccess(message: 'Gate Pass Project Information Deleted'));

        } else {
          emit(const DeleteGatePassProjectFailed("Failed to Delete Gate Pass Project Information"));
        }
      } catch (e, st) {
        print("Gate Pass Project Information Exception: $e\n$st");
        emit(DeleteGatePassProjectFailed(ConstantsMessage.serveError));
      }
    });
  }
}
