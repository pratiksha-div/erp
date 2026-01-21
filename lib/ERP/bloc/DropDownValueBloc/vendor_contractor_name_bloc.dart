import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../api/models/DAOGetVendorName.dart';
import '../../api/services/dropdown_value_service.dart';

//*********** VendorNameEvent ***********//
abstract class VendorNameEvent extends Equatable {
  const VendorNameEvent();

  @override
  List<Object?> get props => [];
}

/// Trigger fetching VendorNames from API
class FetchVendorNamesEvent extends VendorNameEvent {
  const FetchVendorNamesEvent();
}


//*********** VendorNameState ***********//
abstract class VendorNameState extends Equatable {
  const VendorNameState();

  @override
  List<Object?> get props => [];
}

class VendorNameInitial extends VendorNameState {
  const VendorNameInitial();
}

class VendorNameLoading extends VendorNameState {
  const VendorNameLoading();
}

/// Success state contains the parsed list of VendorNames
class VendorNameLoadSuccess extends VendorNameState {
  final List<VendorData> vendorNames;
  const VendorNameLoadSuccess(this.vendorNames);

  @override
  List<Object?> get props => [vendorNames];
}

class VendorNameLoadFailure extends VendorNameState {
  final String message;
  const VendorNameLoadFailure(this.message);

  @override
  List<Object?> get props => [message];
}


// ********* Interface expected by the bloc *************//
abstract class VendorNameService {
  Future<String> fetchVendorNamesRaw();
}

/// Adapter that uses your existing VendorNameServices class
class VendorNameServiceAdapter implements VendorNameService {
  final DropdownServices _dropDownService;

  VendorNameServiceAdapter({DropdownServices? dropDownService})
      : _dropDownService = dropDownService ?? DropdownServices();

  @override
  Future<String> fetchVendorNamesRaw() async {

    // call the existing async method and return its result
    final result = await _dropDownService.getVendorName();
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


//************** VendorNameBloc **************//


/// Bloc implementation
class VendorNameBloc extends Bloc<VendorNameEvent, VendorNameState> {
  final VendorNameService _service;

  VendorNameBloc({required VendorNameService service})
      : _service = service,
        super(const VendorNameInitial()) {
    on<FetchVendorNamesEvent>(_onFetchVendorNames);
  }

  Future<void> _onFetchVendorNames(
      FetchVendorNamesEvent event, Emitter<VendorNameState> emit) async {
    emit(const VendorNameLoading());

    try {
      final raw = await _service.fetchVendorNamesRaw();

      // raw might already be a JSON string. If your service returns Map, adapt.
      final decoded = jsonDecode(raw);

      // Expecting the JSON shape: { "data": [ { "VendorNameId": "...", "VendorNameName": "..." }, ... ] }
      final data = decoded['data'];
      if (data == null || data is! List) {
        emit(const VendorNameLoadFailure('Something went wrong, Please try again'));
        return;
      }

      final vendorNames = data
          .map<VendorData>((e) => VendorData.fromJson(e as Map<String, dynamic>))
          .toList();

      emit(VendorNameLoadSuccess(vendorNames));
    } catch (e) {
      emit(VendorNameLoadFailure(e.toString()));
    }
  }
}




