import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../api/models/DAOGetStates.dart';
import '../../api/services/dropdown_value_service.dart';

//*********** AllStatesEvent ***********//
abstract class AllStatesEvent extends Equatable {
  const AllStatesEvent();

  @override
  List<Object?> get props => [];
}

/// Trigger fetching AllStatess from API
class FetchAllStatesEvent extends AllStatesEvent {
  const FetchAllStatesEvent();
}


//*********** AllStatesState ***********//
abstract class AllStatesState extends Equatable {
  const AllStatesState();

  @override
  List<Object?> get props => [];
}

class AllStatesInitial extends AllStatesState {
  const AllStatesInitial();
}

class AllStatesLoading extends AllStatesState {
  const AllStatesLoading();
}

/// Success state contains the parsed list of AllStatess
class AllStatesLoadSuccess extends AllStatesState {
  final List<StatesData> allstates;
  const AllStatesLoadSuccess(this.allstates);

  @override
  List<Object?> get props => [allstates];
}

class AllStatesLoadFailure extends AllStatesState {
  final String message;
  const AllStatesLoadFailure(this.message);

  @override
  List<Object?> get props => [message];
}


// ********* Interface expected by the bloc *************//
abstract class AllStatesService {
  Future<String> fetchAllStatessRaw();
}

/// Adapter that uses your existing AllStatesServices class
class AllStatesServiceAdapter implements AllStatesService {
  final DropdownServices _dropDownService;

  AllStatesServiceAdapter({DropdownServices? dropDownService})
      : _dropDownService = dropDownService ?? DropdownServices();

  @override
  Future<String> fetchAllStatessRaw() async {

    // call the existing async method and return its result
    final result = await _dropDownService.getStates();
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


//************** AllStatesBloc **************//


/// Bloc implementation
class AllStatesBloc extends Bloc<AllStatesEvent, AllStatesState> {
  final AllStatesService _service;

  AllStatesBloc({required AllStatesService service})
      : _service = service,
        super(const AllStatesInitial()) {
    on<FetchAllStatesEvent>(_onFetchAllStatess);
  }

  Future<void> _onFetchAllStatess(
      FetchAllStatesEvent event, Emitter<AllStatesState> emit) async {
    emit(const AllStatesLoading());

    try {
      final raw = await _service.fetchAllStatessRaw();

      // raw might already be a JSON string. If your service returns Map, adapt.
      final decoded = jsonDecode(raw);

      // Expecting the JSON shape: { "data": [ { "AllStatesId": "...", "AllStatesName": "..." }, ... ] }
      final data = decoded['data'];
      if (data == null || data is! List) {
        emit(const AllStatesLoadFailure('Something went wrong, Please try again'));
        return;
      }

      final AllStatess = data
          .map<StatesData>((e) => StatesData.fromJson(e as Map<String, dynamic>))
          .toList();

      emit(AllStatesLoadSuccess(AllStatess));
    } catch (e) {
      emit(AllStatesLoadFailure(e.toString()));
    }
  }
}




