import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../UI/Utils/messages_constants.dart';
import '../../api/services/add_goods_received_notes_service.dart';

// Event
abstract class AddGoodsReceivedNotesEvent extends Equatable {
  const AddGoodsReceivedNotesEvent();

  @override
  List<Object?> get props => [];
}

class SubmitAddGoodsReceivedNotesEvent extends AddGoodsReceivedNotesEvent {
  final String grn_date;
  final String gen_no;
  final String bill_no;
  final String challan_no;
  final String vehcile_no;
  final String po_no;
  final String from_vendor;
  final String company_name;
  final String to_warehouse;
  final String to_warehouse_id;
  final String requested_by;
  final String contact;
  final String item_names;
  final String quantities;
  final String received_qty;
  final String short_qty;
  final String excess_qty;
  final String rejected_qty;
  final String accepted_qty;
  final String po_balance;
  final String rate;
  final String discount;
  final String amount;
  final String item_id;
  final String group_id;
  final String sub_group_id;
  final String unit;
  final String grand_total;
  final String remarks;

  const SubmitAddGoodsReceivedNotesEvent({
    required this.grn_date,
    required this.gen_no,
    required this.bill_no,
    required this.challan_no,
    required this.vehcile_no,
    required this.po_no,
    required this.from_vendor,
    required this.company_name,
    required this.to_warehouse,
    required this.to_warehouse_id,
    required this.requested_by,
    required this.contact,
    required this.item_names,
    required this.quantities,
    required this.received_qty,
    required this.short_qty,
    required this.excess_qty,
    required this.rejected_qty,
    required this.accepted_qty,
    required this.po_balance,
    required this.rate,
    required this.discount,
    required this.amount,
    required this.item_id,
    required this.group_id,
    required this.sub_group_id,
    required this.unit,
    required this.grand_total,
    required this.remarks
  });

  @override
  List<Object?> get props => [
   grn_date,
   gen_no,
   bill_no,
   challan_no,
   vehcile_no,
   po_no,
   from_vendor,
   company_name,
   to_warehouse,
   to_warehouse_id,
   requested_by,
   contact,
   item_names,
   quantities,
   received_qty,
   short_qty,
   excess_qty,
   rejected_qty,
   accepted_qty,
   po_balance,
   rate,
   discount,
   amount,
   item_id,
   group_id,
   sub_group_id,
   unit,
   grand_total,
   remarks
  ];
}

//State
abstract class AddGoodsReceivedNotesState extends Equatable {
  const AddGoodsReceivedNotesState();

  @override
  List<Object?> get props => [];
}

class AddGoodsReceivedNotesInitial extends AddGoodsReceivedNotesState {}

class AddGoodsReceivedNotesLoading extends AddGoodsReceivedNotesState {}

class AddGoodsReceivedNotesSuccess extends AddGoodsReceivedNotesState {
  final String message;
  final String grn_no;

  const AddGoodsReceivedNotesSuccess({required this.message,required this.grn_no});

  @override
  List<Object?> get props => [message,grn_no];
}

class AddGoodsReceivedNotesFailed extends AddGoodsReceivedNotesState {
  final String message;

  const AddGoodsReceivedNotesFailed(this.message);

  @override
  List<Object?> get props => [message];
}



class AddGoodsReceivedNotesBloc extends Bloc<AddGoodsReceivedNotesEvent, AddGoodsReceivedNotesState> {
  AddGoodsReceivedNotesBloc() : super(AddGoodsReceivedNotesInitial()) {
    on<SubmitAddGoodsReceivedNotesEvent>((event, emit) async {
      emit(AddGoodsReceivedNotesLoading());
      print(
          '''
        ---- SUBMITTING GATE PASS (AGGREGATED) ----
         grn_date : ${event.grn_date}
         gen_no : ${event.gen_no}
         bill_no : ${event.bill_no}
         challan_no : ${event.challan_no}
         vehcile_no : ${event.vehcile_no}
         po_no : ${event.po_no}
         from_vendor : ${event.from_vendor}
         company_name : ${event.company_name}
         to_warehouse : ${event.to_warehouse}
         to_warehouse_id : ${event.to_warehouse_id}
         requested_by : ${event.requested_by}
         contact : ${event.contact}
         item_names : ${event.item_names}
         quantities : ${event.quantities}
         received_qty : ${event.received_qty}
         short_qty : ${event.short_qty}
         excess_qty : ${event.excess_qty}
         rejected_qty : ${event.rejected_qty}
         accepted_qty : ${event.accepted_qty}
         po_balance : ${event.po_balance}
         rate : ${event.rate}
         discount : ${event.discount}
         amount : ${event.amount}
         item_id : ${event.item_id}
         group_id : ${event.group_id}
         sub_group_id : ${event.sub_group_id}
         unit : ${event.unit}
         grand_total : ${event.grand_total}
         remarks : ${event.remarks}
        '''
      );

      try {
        final result = await AddGoodsReceivedNotesService().addGoodsReceivedNotes(
            grn_date: event.grn_date,
            gen_no: event.gen_no,
            bill_no: event.bill_no,
            challan_no: event.challan_no,
            vehcile_no: event.vehcile_no,
            po_no: event.po_no,
            from_vendor: event.from_vendor,
            company_name: event.company_name,
            to_warehouse: event.to_warehouse,
            to_warehouse_id: event.to_warehouse_id,
            requested_by: event.requested_by,
            contact: event.contact,
            item_names: event.item_names,
            quantities: event.quantities,
            received_qty: event.received_qty,
            short_qty: event.short_qty,
            excess_qty: event.excess_qty,
            rejected_qty: event.rejected_qty,
            accepted_qty: event.accepted_qty,
            po_balance: event.po_balance,
            rate: event.rate,
            discount: event.discount,
            amount: event.amount,
            item_id: event.item_id,
            group_id: event.group_id,
            sub_group_id: event.sub_group_id,
            unit: event.unit,
            grand_total: event.grand_total,
            remarks:event.remarks,
        );
        print("Add Goods Received Service Response: $result");
        if (result.code == "200") {
          emit(AddGoodsReceivedNotesSuccess(message: result.message ??"Goods Received Service Saved",grn_no: result.grn_no??""));
        } else {
          emit(AddGoodsReceivedNotesFailed(result.message ?? ConstantsMessage.serveError));
        }

      } catch (e, st) {
        print("Add Goods Received Service Exception: $e\n$st");
        emit(AddGoodsReceivedNotesFailed(ConstantsMessage.serveError));
      }
    });
  }
}
