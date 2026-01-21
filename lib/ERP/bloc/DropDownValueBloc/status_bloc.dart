import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../api/models/DAOStatus.dart';
import '../../api/services/dropdown_value_service.dart';

//*********** StatusEvent ***********//
abstract class StatusEvent extends Equatable {
  const StatusEvent();

  @override
  List<Object?> get props => [];
}

/// Trigger fetching Statuss from API
class FetchStatussEvent extends StatusEvent {
  const FetchStatussEvent();
}


//*********** StatusState ***********//
abstract class StatusState extends Equatable {
  const StatusState();

  @override
  List<Object?> get props => [];
}

class StatusInitial extends StatusState {
  const StatusInitial();
}

class StatusLoading extends StatusState {
  const StatusLoading();
}

/// Success state contains the parsed list of Statuss
class StatusLoadSuccess extends StatusState {
  final List<StatusData> Statuss;
  const StatusLoadSuccess(this.Statuss);

  @override
  List<Object?> get props => [Statuss];
}

class StatusLoadFailure extends StatusState {
  final String message;
  const StatusLoadFailure(this.message);

  @override
  List<Object?> get props => [message];
}


// ********* Interface expected by the bloc *************//
abstract class StatusService {
  Future<String> fetchStatussRaw();
}

/// Adapter that uses your existing StatusServices class
class StatusServiceAdapter implements StatusService {
  final DropdownServices _dropDownService;

  StatusServiceAdapter({DropdownServices? dropDownService})
      : _dropDownService = dropDownService ?? DropdownServices();

  @override
  Future<String> fetchStatussRaw() async {

    // call the existing async method and return its result
    final result = await _dropDownService.getStatus();
    // ensure it's a String so bloc can jsonDecode it
    if (result is String) return result;
    // if it's null or Map, convert safely
    try {
      return result != null ? result.toString() : '{}';
    } catch (_) {
      return '{}';
    }
  }
}


//************** StatusBloc **************//


/// Bloc implementation
class StatusBloc extends Bloc<StatusEvent, StatusState> {
  final StatusService _service;

  StatusBloc({required StatusService service})
      : _service = service,
        super(const StatusInitial()) {
    on<FetchStatussEvent>(_onFetchStatuss);
  }

  Future<void> _onFetchStatuss(
      FetchStatussEvent event, Emitter<StatusState> emit) async {
    emit(const StatusLoading());

    try {
      final raw = await _service.fetchStatussRaw();

      // raw might already be a JSON string. If your service returns Map, adapt.
      final decoded = jsonDecode(raw);

      // Expecting the JSON shape: { "data": [ { "StatusId": "...", "StatusName": "..." }, ... ] }
      final data = decoded['data'];
      if (data == null || data is! List) {
        emit(const StatusLoadFailure('Something went wrong, Please try again'));
        return;
      }

      final Statuss = data
          .map<StatusData>((e) => StatusData.fromJson(e as Map<String, dynamic>))
          .toList();

      emit(StatusLoadSuccess(Statuss));
    } catch (e) {
      emit(StatusLoadFailure(e.toString()));
    }
  }
}




