import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../UI/Utils/messages_constants.dart';
import '../../api/models/AddProjectModel.dart';
import '../../api/services/add_gate_pass_service.dart';
import '../../api/services/add_machine_reading_service.dart';
import '../../api/services/add_material_consumption.dart';
import '../../api/services/add_project_service.dart';
import '../../api/services/get_project_service.dart';

// Event
abstract class DeleteMaterialConsumptionEvent extends Equatable {
  const DeleteMaterialConsumptionEvent();

  @override
  List<Object?> get props => [];
}

class SubmitDeleteMaterialConsumptionEvent extends DeleteMaterialConsumptionEvent {
  final String consumption_id;

  const SubmitDeleteMaterialConsumptionEvent({
    required this.consumption_id,
  });

  @override
  List<Object?> get props => [
    consumption_id,
  ];
}

//State
abstract class DeleteMaterialConsumptionState extends Equatable {
  const DeleteMaterialConsumptionState();

  @override
  List<Object?> get props => [];
}

class DeleteMaterialConsumptionInitial extends DeleteMaterialConsumptionState {}

class DeleteMaterialConsumptionLoading extends DeleteMaterialConsumptionState {}

class DeleteMaterialConsumptionSuccess extends DeleteMaterialConsumptionState {
  final String message;

  const DeleteMaterialConsumptionSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class DeleteMaterialConsumptionFailed extends DeleteMaterialConsumptionState {
  final String message;

  const DeleteMaterialConsumptionFailed(this.message);

  @override
  List<Object?> get props => [message];
}



class DeleteMaterialConsumptionBloc extends Bloc<DeleteMaterialConsumptionEvent, DeleteMaterialConsumptionState> {
  DeleteMaterialConsumptionBloc() : super(DeleteMaterialConsumptionInitial()) {
    on<SubmitDeleteMaterialConsumptionEvent>((event, emit) async {
      emit(DeleteMaterialConsumptionLoading());

      try {
        final result = await DeleteMaterialConsumptionService().deleteMaterialConsumptionsData(event.consumption_id,);
        if (result is BaseResponse) {
          emit(DeleteMaterialConsumptionSuccess(message: 'Material Consumption Deleted'));

        } else {
          emit(const DeleteMaterialConsumptionFailed("Failed to Delete Material Consumption"));
        }
      } catch (e, st) {
        print("Add Project Exception: $e\n$st");
        emit(DeleteMaterialConsumptionFailed(ConstantsMessage.serveError));
      }
    });
  }
}
