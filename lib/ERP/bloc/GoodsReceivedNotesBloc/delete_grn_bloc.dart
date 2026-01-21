import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../UI/Utils/messages_constants.dart';
import '../../api/models/AddProjectModel.dart';
import '../../api/services/add_goods_received_notes_service.dart';

// Event
abstract class DeleteGRNEvent extends Equatable {
  const DeleteGRNEvent();

  @override
  List<Object?> get props => [];
}

class SubmitDeleteGRNEvent extends DeleteGRNEvent {
  final String grn_id;
  final String accepted_qty;

  const SubmitDeleteGRNEvent({
    required this.grn_id,
    required this.accepted_qty,
  });

  @override
  List<Object?> get props => [
    grn_id,
    accepted_qty
  ];
}

//State
abstract class DeleteGRNState extends Equatable {
  const DeleteGRNState();

  @override
  List<Object?> get props => [];
}

class DeleteGRNInitial extends DeleteGRNState {}

class DeleteGRNLoading extends DeleteGRNState {}

class DeleteGRNSuccess extends DeleteGRNState {
  final String message;

  const DeleteGRNSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class DeleteGRNFailed extends DeleteGRNState {
  final String message;

  const DeleteGRNFailed(this.message);

  @override
  List<Object?> get props => [message];
}



class DeleteGRNBloc extends Bloc<DeleteGRNEvent, DeleteGRNState> {
  DeleteGRNBloc() : super(DeleteGRNInitial()) {
    on<SubmitDeleteGRNEvent>((event, emit) async {
      emit(DeleteGRNLoading());

      try {
        final result = await DeleteGRNService().deleteGRNData(event.grn_id,event.accepted_qty);
        if (result is BaseResponse) {
          emit(DeleteGRNSuccess(message: 'GRN Deleted'));

        } else {
          emit(const DeleteGRNFailed("Failed to Delete GRN"));
        }
      } catch (e, st) {
        print("GRN Exception: $e\n$st");
        emit(DeleteGRNFailed(ConstantsMessage.serveError));
      }
    });
  }
}
