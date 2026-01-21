import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../UI/Utils/messages_constants.dart';
import '../../api/services/add_gate_pass_service.dart';

// Event
abstract class AddWarehouseToProjectEvent extends Equatable {
  const AddWarehouseToProjectEvent();

  @override
  List<Object?> get props => [];
}

class SubmitAddWarehouseToProjectEvent extends AddWarehouseToProjectEvent {
 final String project_id;
 final String date;
 final String vehicle_id;
 final String issued_to_id;
 final String issued_by_id;
 final String gatePass;
 final String description;
 final String fromWarehouse;
 final String outTime;
 final String materialsId;
 final String issuedMaterials;
 final String currentBalance;
 final String quantity;
 final String unit;

  const SubmitAddWarehouseToProjectEvent({
    required this.project_id,
    required this.date,
    required this.vehicle_id,
    required this.issued_to_id,
    required this.issued_by_id,
    required this.gatePass,
    required this.description,
    required this.fromWarehouse,
    required this.outTime,
    required this.materialsId,
    required this.issuedMaterials,
    required this.currentBalance,
    required this.quantity,
    required this.unit,
  });

  @override
  List<Object?> get props => [
    project_id,
    date,
    vehicle_id,
    issued_to_id,
    issued_by_id,
    gatePass,
    description,
    fromWarehouse,
    outTime,
    materialsId,
    issuedMaterials,
    currentBalance,
    quantity,
    unit
  ];
}

//State
abstract class AddWarehouseToProjectState extends Equatable {
  const AddWarehouseToProjectState();

  @override
  List<Object?> get props => [];
}

class AddWarehouseToProjectInitial extends AddWarehouseToProjectState {}

class AddWarehouseToProjectLoading extends AddWarehouseToProjectState {}

class AddWarehouseToProjectSuccess extends AddWarehouseToProjectState {
  final String message;

  const AddWarehouseToProjectSuccess({required this.message,});

  @override
  List<Object?> get props => [message];
}

class AddWarehouseToProjectFailed extends AddWarehouseToProjectState {
  final String message;

  const AddWarehouseToProjectFailed(this.message);

  @override
  List<Object?> get props => [message];
}



class AddWarehouseToProjectBloc extends Bloc<AddWarehouseToProjectEvent, AddWarehouseToProjectState> {
  AddWarehouseToProjectBloc() : super(AddWarehouseToProjectInitial()) {
    on<SubmitAddWarehouseToProjectEvent>((event, emit) async {
      emit(AddWarehouseToProjectLoading());

      try {
        final result = await GatePassWarehouseToProjectService().addWarehouseToProjectService(
          project_id:event.project_id,
          date:event.date,
          vehicle_id:event.vehicle_id,
          issued_to_id:event.issued_to_id,
          issued_by_id:event.issued_by_id,
          gatePass:event.gatePass,
          description:event.description,
          fromWarehouse:event.fromWarehouse,
          outTime:event.outTime,
          materialsId:event.materialsId,
          issuedMaterials:event.issuedMaterials,
          currentBalance:event.currentBalance,
          quantity:event.quantity,
          unit: event.unit
        );

        if (result.code == "200") {
          emit(AddWarehouseToProjectSuccess(message: result.massage ??""));
        } else {
          emit(AddWarehouseToProjectFailed(result.massage ?? ConstantsMessage.serveError));
        }

      } catch (e, st) {
        print("Add Warehouse to Project Exception: $e\n$st");
        emit(AddWarehouseToProjectFailed(ConstantsMessage.serveError));
      }
    });
  }
}
