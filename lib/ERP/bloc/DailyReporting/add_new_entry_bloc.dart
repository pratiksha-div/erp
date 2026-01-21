import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../UI/Utils/messages_constants.dart';
import '../../api/services/add_new_entry.dart';
import '../../api/services/add_project_service.dart';


// Event
abstract class AddNewEntryEvent extends Equatable {
  const AddNewEntryEvent();

  @override
  List<Object?> get props => [];
}

class SubmitAddNewEntryEvent extends AddNewEntryEvent {
  final String project_id;
  final String entryDate;
  final String projectName;
  final String EmployeeType;
  final String EmployeeName;
  final String working_notes;
  final String work_detail_id;

  const SubmitAddNewEntryEvent({
    required this.project_id,
    required this.entryDate,
    required this.projectName,
    required this.EmployeeType,
    required this.EmployeeName,
    required this.working_notes,
    required this.work_detail_id
  });

  @override
  List<Object?> get props => [
    project_id,
    entryDate,
    projectName,
    EmployeeType,
    EmployeeName,
    working_notes,
    work_detail_id
  ];
}

//State
abstract class AddNewEntryState extends Equatable {
  const AddNewEntryState();

  @override
  List<Object?> get props => [];
}

class AddNewEntryInitial extends AddNewEntryState {}

class AddNewEntryLoading extends AddNewEntryState {}

class AddNewEntrySuccess extends AddNewEntryState {
  final String message;

  const AddNewEntrySuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class AddNewEntryFailed extends AddNewEntryState {
  final String message;

  const AddNewEntryFailed(this.message);

  @override
  List<Object?> get props => [message];
}



class AddNewEntryBloc extends Bloc<AddNewEntryEvent, AddNewEntryState> {
  AddNewEntryBloc() : super(AddNewEntryInitial()) {
    on<SubmitAddNewEntryEvent>((event, emit) async {
      emit(AddNewEntryLoading());

      try {
        final result = await AddNewEntryService().addNewEntry(
            project_id: event.project_id,
            entryDate: event.entryDate,
            projectName: event.projectName,
            EmployeeType: event.EmployeeType,
            EmployeeName: event.EmployeeName,
            working_notes: event.working_notes,
            work_detail_id:event.work_detail_id,
        );
        if (result.code == "200") {
          emit(AddNewEntrySuccess(message: result.massage ??"Entry Saved"));
        } else {
          emit(AddNewEntryFailed(result.massage ?? ConstantsMessage.serveError));
        }

      } catch (e, st) {
        print("Add Project Exception: $e\n$st");
        emit(AddNewEntryFailed(ConstantsMessage.serveError));
      }
    });
  }
}
