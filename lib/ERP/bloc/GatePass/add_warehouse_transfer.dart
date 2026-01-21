import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../UI/Utils/messages_constants.dart';
import '../../api/services/add_gate_pass_service.dart';

// Event
abstract class AddWarehouseTransferEvent extends Equatable {
  const AddWarehouseTransferEvent();

  @override
  List<Object?> get props => [];
}

class SubmitAddWarehouseTransferEvent extends AddWarehouseTransferEvent {
  final String groupid;
  final String subgroupid;
  final String item_id;
  final String item;
  final String date;
  final String unit;
  final String currentBalance;
  final String quantity;
  final String fromWarehouse;
  final String towarehouse;

  const SubmitAddWarehouseTransferEvent({
    required this.groupid,
    required this.subgroupid,
    required this.item_id,
    required this.item,
    required this.date,
    required this.unit,
    required this.currentBalance,
    required this.quantity,
    required this.fromWarehouse,
    required this.towarehouse,
  });

  @override
  List<Object?> get props => [
  groupid,
  subgroupid,
  item_id,
  item,
  date,
  unit,
  currentBalance,
  quantity,
  fromWarehouse,
  towarehouse,
  ];
}

//State
abstract class AddWarehouseTransferState extends Equatable {
  const AddWarehouseTransferState();

  @override
  List<Object?> get props => [];
}

class AddWarehouseTransferInitial extends AddWarehouseTransferState {}

class AddWarehouseTransferLoading extends AddWarehouseTransferState {}

class AddWarehouseTransferSuccess extends AddWarehouseTransferState {
  final String message;

  const AddWarehouseTransferSuccess({required this.message,});

  @override
  List<Object?> get props => [message];
}

class AddWarehouseTransferFailed extends AddWarehouseTransferState {
  final String message;

  const AddWarehouseTransferFailed(this.message);

  @override
  List<Object?> get props => [message];
}



class AddWarehouseTransferBloc extends Bloc<AddWarehouseTransferEvent, AddWarehouseTransferState> {
  AddWarehouseTransferBloc() : super(AddWarehouseTransferInitial()) {
    on<SubmitAddWarehouseTransferEvent>((event, emit) async {
      emit(AddWarehouseTransferLoading());

      try {
        final result = await GatePassWarehouseTransferService().addWarehouseTransferService(
           groupid:event.groupid,
           subgroupid:event.subgroupid,
           item_id:event.item_id,
           item:event.item,
           date:event.date,
           unit:event.unit,
           currentBalance:event.currentBalance,
           quantity:event.quantity,
           fromWarehouse:event.fromWarehouse,
           towarehouse:event.towarehouse,
        );

        if (result.code == "200") {
          emit(AddWarehouseTransferSuccess(message: result.massage ??""));
        } else {
          emit(AddWarehouseTransferFailed(result.massage ?? ConstantsMessage.serveError));
        }

      } catch (e, st) {
        print("Add Warehouse Transfer Exception: $e\n$st");
        emit(AddWarehouseTransferFailed(ConstantsMessage.serveError));
      }
    });
  }
}
