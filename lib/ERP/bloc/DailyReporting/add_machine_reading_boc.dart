import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../UI/Pages/DailyReporting/Add_Machine_Reading.dart';
import '../../UI/Utils/messages_constants.dart';
import '../../api/services/add_machine_reading_service.dart';
import '../../api/services/add_new_entry.dart';
import '../../api/services/add_project_service.dart';

// Event
abstract class AddMachineReadingEvent extends Equatable {
  const AddMachineReadingEvent();

  @override
  List<Object?> get props => [];
}

class SubmitAddMachineReadingEvent extends AddMachineReadingEvent {
  final String date;
  final String reading_start;
  final String reading_stop;
  final String machine_Start;
  final String machine_Stop;
  final String time_expend;
  final String notes;
  final String project_id;
  final String readingID;
  final String vendertype;
  final String vechiceltype;
  final String gate_pass_no;
  final String total_run;
  final String amount;

  const SubmitAddMachineReadingEvent({
  required this.date,
  required this.reading_start,
  required this.reading_stop,
  required this.machine_Start,
  required this.machine_Stop,
  required this.time_expend,
  required this.notes,
  required this.project_id,
  required this.readingID,
  required this.vendertype,
  required this.vechiceltype,
  required this.gate_pass_no,
  required this.total_run,
  required this.amount
  });

  @override
  List<Object?> get props => [
   date,
   reading_start,
   reading_stop,
   machine_Start,
   machine_Stop,
   time_expend,
   notes,
   project_id,
   readingID,
   vendertype,
    vechiceltype,
    gate_pass_no,
    total_run,
    amount
  ];
}

//State
abstract class AddMachineReadingState extends Equatable {
  const AddMachineReadingState();

  @override
  List<Object?> get props => [];
}

class AddMachineReadingInitial extends AddMachineReadingState {}

class AddMachineReadingLoading extends AddMachineReadingState {}

class AddMachineReadingSuccess extends AddMachineReadingState {
  final String message;

  const AddMachineReadingSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class AddMachineReadingFailed extends AddMachineReadingState {
  final String message;

  const AddMachineReadingFailed(this.message);

  @override
  List<Object?> get props => [message];
}



class AddMachineReadingBloc extends Bloc<AddMachineReadingEvent, AddMachineReadingState> {
  AddMachineReadingBloc() : super(AddMachineReadingInitial()) {
    on<SubmitAddMachineReadingEvent>((event, emit) async {
      emit(AddMachineReadingLoading());

      try {
        final result = await AddMachineReadingService().addMachineReading(
          date:event.date,
          reading_start:event.reading_start,
          reading_stop:event.reading_stop,
          machine_Start:event.machine_Start,
          machine_Stop:event.machine_Stop,
          time_expend:event.time_expend,
          notes:event.notes,
          project_id:event.project_id,
          readingID:event.readingID,
          vendertype:event.vendertype,
          vechiceltype: event.vechiceltype,
          gate_pass_no: event.gate_pass_no,
          total_run: event.total_run,
          amount: event.amount
        );

        // print("Add New Machine Reading API Response: $result");
        if (result.code == "200") {
          emit(AddMachineReadingSuccess(message: result.massage ??"Machine Reading Saved"));
        } else {
          emit(AddMachineReadingFailed(result.massage ?? ConstantsMessage.serveError));
        }

      } catch (e, st) {
        print("Add Project Exception: $e\n$st");
        emit(AddMachineReadingFailed(ConstantsMessage.serveError));
      }
    });
  }
}
