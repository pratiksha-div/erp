import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../UI/Utils/messages_constants.dart';
import '../../api/services/gate_entry_service.dart';

// Event
abstract class AddPurchaseDetailEvent extends Equatable {
  const AddPurchaseDetailEvent();

  @override
  List<Object?> get props => [];
}

class SubmitAddPurchaseDetailEvent extends AddPurchaseDetailEvent {
  final String gate_entry_id;
  final String challanNo;
  final String billNo;
  final String vehicleNo;
  final String poNumber;
  final String vendor;
  final String orderedBy;
  final String toWarehouse;
  final String itemNames;
  final String itemQuantities;
  final String itemIds;
  final String groupIds;
  final String subGroupIds;
  final String company_name;
  final String unit;
  final String to_warehouse_id;
  final String gate_entry_date;
  final String bill_date;
  final String project_id;
  final String rate;
  final String grand_total;

  const SubmitAddPurchaseDetailEvent({
    required this.gate_entry_id,
    required this.challanNo,
    required this.billNo,
    required this.vehicleNo,
    required this.poNumber,
    required this.vendor,
    required this.orderedBy,
    required this.toWarehouse,
    required this.itemNames,
    required this.itemQuantities,
    required this.itemIds,
    required this.groupIds,
    required this.subGroupIds,
    required this.company_name,
    required this.unit,
    required this.to_warehouse_id,
    required this.gate_entry_date,
    required this.bill_date,
    required this.project_id,
    required this.rate,
    required this.grand_total
  });

  @override
  List<Object?> get props => [
    gate_entry_id,
    challanNo,
    billNo,
    vehicleNo,
    poNumber,
    vendor,
    orderedBy,
    toWarehouse,
    itemNames,
    itemQuantities,
    itemIds,
    groupIds,
    subGroupIds,
    company_name,
    unit,
    to_warehouse_id,
    gate_entry_date,
    bill_date,
    project_id,
    rate,
    grand_total
  ];
}

//State
abstract class AddPurchaseDetailState extends Equatable {
  const AddPurchaseDetailState();

  @override
  List<Object?> get props => [];
}

class AddPurchaseDetailInitial extends AddPurchaseDetailState {}

class AddPurchaseDetailLoading extends AddPurchaseDetailState {}

class AddPurchaseDetailSuccess extends AddPurchaseDetailState {
  final String message;
  final String gen_no;

  const AddPurchaseDetailSuccess({required this.message,required this.gen_no});

  @override
  List<Object?> get props => [message,gen_no];
}

class AddPurchaseDetailFailed extends AddPurchaseDetailState {
  final String message;

  const AddPurchaseDetailFailed(this.message);

  @override
  List<Object?> get props => [message];
}



class AddPurchaseDetailBloc extends Bloc<AddPurchaseDetailEvent, AddPurchaseDetailState> {
  AddPurchaseDetailBloc() : super(AddPurchaseDetailInitial()) {
    on<SubmitAddPurchaseDetailEvent>((event, emit) async {
      emit(AddPurchaseDetailLoading());

      try {
        final result = await AddPurchaseDetailService().addPurchaseDetail(
          gate_entry_id:event.gate_entry_id,
          challanNo:event.challanNo,
          billNo:event.billNo,
          vehicleNo:event.vehicleNo,
          poNumber:event.poNumber,
          vendor:event.vendor,
          orderedBy:event.orderedBy,
          toWarehouse:event.toWarehouse,
          itemNames:event.itemNames,
          itemQuantities:event.itemQuantities,
          itemIds:event.itemIds,
          groupIds:event.groupIds,
          subGroupId:event.subGroupIds,
          company_name:event.company_name,
          unit:event.unit,
          to_warehouse_id:event.to_warehouse_id,
          gate_entry_date: event.gate_entry_date,
          bill_date: event.bill_date,
          project_id: event.project_id,
          rate:event.rate,
          grand_total:event.grand_total
        );
        if (result.code == "200") {
          emit(AddPurchaseDetailSuccess(message: result.massage ??"Saved",gen_no: result.gen_no??""));
        } else {
          emit(AddPurchaseDetailFailed(result.massage ?? ConstantsMessage.serveError));
        }

      } catch (e, st) {
        print("Save Purchase Order Exception: $e\n$st");
        emit(AddPurchaseDetailFailed(ConstantsMessage.serveError));
      }
    });
  }
}
