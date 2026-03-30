import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../UI/Utils/messages_constants.dart';
import '../../api/services/add_material_consumption.dart';
import '../../api/services/add_new_entry.dart';
import '../../api/services/add_project_service.dart';


// Event
abstract class AddMaterialConsumptionEvent extends Equatable {
  const AddMaterialConsumptionEvent();

  @override
  List<Object?> get props => [];
}

class SubmitAddMaterialConsumptionEvent extends AddMaterialConsumptionEvent {
     final String? project_id;
     final String? date;
     final String? gatePass;
     final String? consumedMaterial;
     final String? item;
     final String? balanceQuantity;
     final String? consumedUnit;
     final String? usedQuantity;
     final String? consumedScrap;
     final String? consumedRate;
     final String? consumedAmount;
     final String? consumption_id;

  const SubmitAddMaterialConsumptionEvent({
    this.project_id,
    this.date,
    this.gatePass,
    this.consumedMaterial,
    this.item,
    this.balanceQuantity,
    this.consumedUnit,
    this.usedQuantity,
    this.consumedScrap,
    this.consumedRate,
    this.consumedAmount,
    this.consumption_id,
  });

  @override
  List<Object?> get props => [
    project_id,
    date,
    gatePass,
    consumedMaterial,
    item,
    balanceQuantity,
    consumedUnit,
    usedQuantity,
    consumedScrap,
    consumedRate,
    consumedAmount,
    consumption_id
  ];
}

//State
abstract class AddMaterialConsumptionState extends Equatable {
  const AddMaterialConsumptionState();

  @override
  List<Object?> get props => [];
}

class AddMaterialConsumptionInitial extends AddMaterialConsumptionState {}

class AddMaterialConsumptionLoading extends AddMaterialConsumptionState {}

class AddMaterialConsumptionSuccess extends AddMaterialConsumptionState {
  final String message;

  const AddMaterialConsumptionSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class AddMaterialConsumptionFailed extends AddMaterialConsumptionState {
  final String message;

  const AddMaterialConsumptionFailed(this.message);

  @override
  List<Object?> get props => [message];
}



class AddMaterialConsumptionBloc extends Bloc<AddMaterialConsumptionEvent, AddMaterialConsumptionState> {
  AddMaterialConsumptionBloc() : super(AddMaterialConsumptionInitial()) {
    on<SubmitAddMaterialConsumptionEvent>((event, emit) async {
      emit(AddMaterialConsumptionLoading());

      try {
        final result = await AddMaterialConsumptionService().addMaterialConsumption(
          project_id: event.project_id,
          date:event.date,
          gatePass:event.gatePass,
          consumedMaterial:event.consumedMaterial,
          item:event.item,
          balanceQuantity:event.balanceQuantity,
          consumedUnit:event.consumedUnit,
          usedQuantity:event.usedQuantity,
          consumedScrap:event.consumedScrap,
          consumedRate:event.consumedRate,
          consumedAmount:event.consumedAmount,
          consumption_id:event.consumption_id,
        );
        print(
          '''
project_id: ${event.project_id},
date:${event.date},
gatePass:${event.gatePass},
consumedMaterial:${event.consumedMaterial},
item:${event.item},
balanceQuantity:${event.balanceQuantity},
consumedUnit:${event.consumedUnit},
usedQuantity:${event.usedQuantity},
consumedScrap:${event.consumedScrap},
consumedRate:${event.consumedRate},
consumedAmount:${event.consumedAmount},
consumption_id:${event.consumption_id},
          '''
        );

        print("Add Material consumption API Response: $result");
        if (result.code == "200") {
          emit(AddMaterialConsumptionSuccess(message: result.massage ??"Material Consumption Saved"));
        } else {
          emit(AddMaterialConsumptionFailed(result.massage ?? ConstantsMessage.serveError));
        }

      } catch (e, st) {
        print("Add Material consumption Exception: $e\n$st");
        emit(AddMaterialConsumptionFailed(ConstantsMessage.serveError));
      }
    });
  }
}
