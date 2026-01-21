import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../UI/Utils/messages_constants.dart';
import '../../api/models/AddProjectModel.dart';
import '../../api/services/add_gate_pass_service.dart';

// Event
abstract class DeleteGatePassWarehouseEvent extends Equatable {
  const DeleteGatePassWarehouseEvent();

  @override
  List<Object?> get props => [];
}

class SubmitDeleteGatePassWarehouseEvent extends DeleteGatePassWarehouseEvent {
  final String from_warehouse_id;
  final String to_warehouse_id;
  final String issued_material;
  final String quantity;

  const SubmitDeleteGatePassWarehouseEvent({
    required this.from_warehouse_id,
    required this.to_warehouse_id,
    required this.issued_material,
    required this.quantity
  });

  @override
  List<Object?> get props => [
   from_warehouse_id,
   to_warehouse_id,
   issued_material,
   quantity,
  ];
}

//State
abstract class DeleteGatePassWarehouseState extends Equatable {
  const DeleteGatePassWarehouseState();

  @override
  List<Object?> get props => [];
}

class DeleteGatePassWarehouseInitial extends DeleteGatePassWarehouseState {}

class DeleteGatePassWarehouseLoading extends DeleteGatePassWarehouseState {}

class DeleteGatePassWarehouseSuccess extends DeleteGatePassWarehouseState {
  final String message;

  const DeleteGatePassWarehouseSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class DeleteGatePassWarehouseFailed extends DeleteGatePassWarehouseState {
  final String message;

  const DeleteGatePassWarehouseFailed(this.message);

  @override
  List<Object?> get props => [message];
}



class DeleteGatePassWarehouseBloc extends Bloc<DeleteGatePassWarehouseEvent, DeleteGatePassWarehouseState> {
  DeleteGatePassWarehouseBloc() : super(DeleteGatePassWarehouseInitial()) {
    on<SubmitDeleteGatePassWarehouseEvent>((event, emit) async {
      emit(DeleteGatePassWarehouseLoading());

      try {
        final result = await DeleteGatePassService().deleteGatePassWarehouse(
          event.from_warehouse_id,
          event.to_warehouse_id,
          event.issued_material,
          event.quantity
        );
        if (result is BaseResponse) {
          emit(DeleteGatePassWarehouseSuccess(message: 'Gate Pass Warehouse Information Deleted'));

        } else {
          emit(const DeleteGatePassWarehouseFailed("Failed to Delete Gate Pass Warehouse Information"));
        }
      } catch (e, st) {
        print("Gate Pass Warehouse Information Exception: $e\n$st");
        emit(DeleteGatePassWarehouseFailed(ConstantsMessage.serveError));
      }
    });
  }
}
