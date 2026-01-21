import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../UI/Utils/messages_constants.dart';
import '../../api/services/add_gate_pass_service.dart';

// Event
abstract class AddNewGatePassEvent extends Equatable {
  const AddNewGatePassEvent();

  @override
  List<Object?> get props => [];
}

class SubmitAddNewGatePassEvent extends AddNewGatePassEvent {
   final String transferType;
   final String date;
   final String toProject;
   final String toWarehouse;
   final String vehicleNameNo;
   final String issuedTo;
   final String issuedBy;
   final String gatePass;
   final String description;
   final String fromWarehouse;
   final String outTime;
   final String materialsId;
   final String issuedMaterials;
   final String currentBalance;
   final String unit;
   final String category;
   final String subCategory;
   final String quantity;
   final String consumed;
   final String usedQuantity;
   final String scrap;
   final String rate;
   final String amount;
   final String differenceBalance;

  const SubmitAddNewGatePassEvent({
    required this.transferType,
    required this.date,
    required this.toProject,
    required this.toWarehouse,
    required this.vehicleNameNo,
    required this.issuedTo,
    required this.issuedBy,
    required this.gatePass,
    required this.description,
    required this.fromWarehouse,
    required this.outTime,
    required this.materialsId,
    required this.issuedMaterials,
    required this.currentBalance,
    required this.unit,
    required this.category,
    required this.subCategory,
    required this.quantity,
    required this.consumed,
    required this.usedQuantity,
    required this.scrap,
    required this.rate,
    required this.amount,
    required this.differenceBalance,
  });

  @override
  List<Object?> get props => [
    transferType,
    date,
    toProject,
    toWarehouse,
    vehicleNameNo,
    issuedTo,
    issuedBy,
    gatePass,
    description,
    fromWarehouse,
    outTime,
    materialsId,
    issuedMaterials,
    currentBalance,
    unit,
    category,
    subCategory,
    quantity,
    consumed,
    usedQuantity,
    scrap,
    rate,
    amount,
    differenceBalance,
  ];
}

//State
abstract class AddNewGatePassState extends Equatable {
  const AddNewGatePassState();

  @override
  List<Object?> get props => [];
}

class AddNewGatePassInitial extends AddNewGatePassState {}

class AddNewGatePassLoading extends AddNewGatePassState {}

class AddNewGatePassSuccess extends AddNewGatePassState {
  final String message;

  const AddNewGatePassSuccess({required this.message,});

  @override
  List<Object?> get props => [message];
}

class AddNewGatePassFailed extends AddNewGatePassState {
  final String message;

  const AddNewGatePassFailed(this.message);

  @override
  List<Object?> get props => [message];
}



class AddNewGatePassBloc extends Bloc<AddNewGatePassEvent, AddNewGatePassState> {
  AddNewGatePassBloc() : super(AddNewGatePassInitial()) {
    on<SubmitAddNewGatePassEvent>((event, emit) async {
      emit(AddNewGatePassLoading());
      print(
        '''
        ---- SUBMITTING GATE PASS (AGGREGATED) ----
         transferType:${event.transferType},
         date:${event.date},
         toProject:${event.toProject},
         toWarehouse:${event.toWarehouse},
         vehicleNameNo:${event.vehicleNameNo},
         issuedTo:${event.issuedTo},
         issuedBy:${event.issuedBy},
         gatePass:${event.gatePass},
         description:${event.description},
         fromWarehouse:${event.fromWarehouse},
         outTime:${event.outTime},
         materialsId:${event.materialsId},
         issuedMaterials:${event.issuedMaterials},
         currentBalance:${event.currentBalance},
         unit:${event.unit},
         category:${event.category},
         subCategory:${event.subCategory},
         quantity:${event.quantity},
         consumed:${event.consumed},
         usedQuantity:${event.usedQuantity},
         scrap:${event.scrap},
         rate:${event.rate},
         amount:${event.amount},
         differenceBalance:${event.differenceBalance}
        '''
      );

      try {
        final result = await AddGatePassService().addNewGatePassService(
          transferType:event.transferType,
          date:event.date,
          toProject:event.toProject,
          toWarehouse:event.toWarehouse,
          vehicleNameNo:event.vehicleNameNo,
          issuedTo:event.issuedTo,
          issuedBy:event.issuedBy,
          gatePass:event.gatePass,
          description:event.description,
          fromWarehouse:event.fromWarehouse,
          outTime:event.outTime,
          materialsId:event.materialsId,
          issuedMaterials:event.issuedMaterials,
          currentBalance:event.currentBalance,
          unit:event.unit,
          category:event.category,
          subCategory:event.subCategory,
          quantity:event.quantity,
          consumed:event.consumed,
          usedQuantity:event.usedQuantity,
          scrap:event.scrap,
          rate:event.rate,
          amount:event.amount,
          differenceBalance:event.differenceBalance
        );

        print("Add New Entry API Response: $result");
        if (result.code == "200") {
          emit(AddNewGatePassSuccess(message: result.massage ??"Gate Pass Entry Saved"));
        } else {
          emit(AddNewGatePassFailed(result.massage ?? ConstantsMessage.serveError));
        }

      } catch (e, st) {
        print("Add Project Exception: $e\n$st");
        emit(AddNewGatePassFailed(ConstantsMessage.serveError));
      }
    });
  }
}
