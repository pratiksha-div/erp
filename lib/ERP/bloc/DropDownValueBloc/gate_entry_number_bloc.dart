import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../api/models/DAOGetGENumber.dart';
import '../../api/services/dropdown_value_service.dart';

//*********** GateEntryNumberEvent ***********//
abstract class GateEntryNumberEvent extends Equatable {
  const GateEntryNumberEvent();

  @override
  List<Object?> get props => [];
}

/// Trigger fetching GateEntryNumbers from API
class FetchGateEntryNumbersEvent extends GateEntryNumberEvent {
  const FetchGateEntryNumbersEvent();
}


//*********** GateEntryNumberState ***********//
abstract class GateEntryNumberState extends Equatable {
  const GateEntryNumberState();

  @override
  List<Object?> get props => [];
}

class GateEntryNumberInitial extends GateEntryNumberState {
  const GateEntryNumberInitial();
}

class GateEntryNumberLoading extends GateEntryNumberState {
  const GateEntryNumberLoading();
}

/// Success state contains the parsed list of GateEntryNumbers
class GateEntryNumberLoadSuccess extends GateEntryNumberState {
  final List<GENumberData> gateEntryNumbers;
  const GateEntryNumberLoadSuccess(this.gateEntryNumbers);

  @override
  List<Object?> get props => [gateEntryNumbers];
}

class GateEntryNumberLoadFailure extends GateEntryNumberState {
  final String message;
  const GateEntryNumberLoadFailure(this.message);

  @override
  List<Object?> get props => [message];
}


// ********* Interface expected by the bloc *************//
abstract class GateEntryNumberService {
  Future<String> fetchGateEntryNumbersRaw();
}

/// Adapter that uses your existing GateEntryNumberServices class
class GateEntryNumberServiceAdapter implements GateEntryNumberService {
  final DropdownServices _dropDownService;

  GateEntryNumberServiceAdapter({DropdownServices? dropDownService})
      : _dropDownService = dropDownService ?? DropdownServices();

  @override
  Future<String> fetchGateEntryNumbersRaw() async {

    // call the existing async method and return its result
    final result = await _dropDownService.getGENumber();
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


//************** GateEntryNumberBloc **************//


/// Bloc implementation
class GateEntryNumberBloc extends Bloc<GateEntryNumberEvent, GateEntryNumberState> {
  final GateEntryNumberService _service;

  GateEntryNumberBloc({required GateEntryNumberService service})
      : _service = service,
        super(const GateEntryNumberInitial()) {
    on<FetchGateEntryNumbersEvent>(_onFetchGateEntryNumbers);
  }

  Future<void> _onFetchGateEntryNumbers(
      FetchGateEntryNumbersEvent event, Emitter<GateEntryNumberState> emit) async {
    emit(const GateEntryNumberLoading());

    try {
      final raw = await _service.fetchGateEntryNumbersRaw();

      // raw might already be a JSON string. If your service returns Map, adapt.
      final decoded = jsonDecode(raw);

      // Expecting the JSON shape: { "data": [ { "GateEntryNumberId": "...", "GateEntryNumberName": "..." }, ... ] }
      final data = decoded['data'];
      if (data == null || data is! List) {
        emit(const GateEntryNumberLoadFailure('Something went wrong, Please try again'));
        return;
      }

      final GateEntryNumbers = data
          .map<GENumberData>((e) => GENumberData.fromJson(e as Map<String, dynamic>))
          .toList();

      emit(GateEntryNumberLoadSuccess(GateEntryNumbers));
    } catch (e) {
      emit(GateEntryNumberLoadFailure(e.toString()));
    }
  }
}




