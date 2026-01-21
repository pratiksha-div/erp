import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../api/models/DAOPurchaseOrderNumber.dart';
import '../../api/services/dropdown_value_service.dart';

//*********** PurchaseOrderNumberEvent ***********//
abstract class PurchaseOrderNumberEvent extends Equatable {
  const PurchaseOrderNumberEvent();

  @override
  List<Object?> get props => [];
}

/// Trigger fetching PurchaseOrderNumbers from API
class FetchPurchaseOrderNumbersEvent extends PurchaseOrderNumberEvent {
  const FetchPurchaseOrderNumbersEvent();
}


//*********** PurchaseOrderNumberState ***********//
abstract class PurchaseOrderNumberState extends Equatable {
  const PurchaseOrderNumberState();

  @override
  List<Object?> get props => [];
}

class PurchaseOrderNumberInitial extends PurchaseOrderNumberState {
  const PurchaseOrderNumberInitial();
}

class PurchaseOrderNumberLoading extends PurchaseOrderNumberState {
  const PurchaseOrderNumberLoading();
}

/// Success state contains the parsed list of PurchaseOrderNumbers
class PurchaseOrderNumberLoadSuccess extends PurchaseOrderNumberState {
  final List<PurchaseOrderNumberData> purchaseOrderNumbers;
  const PurchaseOrderNumberLoadSuccess(this.purchaseOrderNumbers);

  @override
  List<Object?> get props => [purchaseOrderNumbers];
}

class PurchaseOrderNumberLoadFailure extends PurchaseOrderNumberState {
  final String message;
  const PurchaseOrderNumberLoadFailure(this.message);

  @override
  List<Object?> get props => [message];
}


// ********* Interface expected by the bloc *************//
abstract class PurchaseOrderNumberService {
  Future<String> fetchPurchaseOrderNumbersRaw();
}

/// Adapter that uses your existing PurchaseOrderNumberServices class
class PurchaseOrderNumberServiceAdapter implements PurchaseOrderNumberService {
  final DropdownServices _dropDownService;

  PurchaseOrderNumberServiceAdapter({DropdownServices? dropDownService})
      : _dropDownService = dropDownService ?? DropdownServices();

  @override
  Future<String> fetchPurchaseOrderNumbersRaw() async {

    // call the existing async method and return its result
    final result = await _dropDownService.getPurchaseOrderNumber();
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


//************** PurchaseOrderNumberBloc **************//


/// Bloc implementation
class PurchaseOrderNumberBloc extends Bloc<PurchaseOrderNumberEvent, PurchaseOrderNumberState> {
  final PurchaseOrderNumberService _service;

  PurchaseOrderNumberBloc({required PurchaseOrderNumberService service})
      : _service = service,
        super(const PurchaseOrderNumberInitial()) {
    on<FetchPurchaseOrderNumbersEvent>(_onFetchPurchaseOrderNumbers);
  }

  Future<void> _onFetchPurchaseOrderNumbers(
      FetchPurchaseOrderNumbersEvent event, Emitter<PurchaseOrderNumberState> emit) async {
    emit(const PurchaseOrderNumberLoading());

    try {
      final raw = await _service.fetchPurchaseOrderNumbersRaw();

      // raw might already be a JSON string. If your service returns Map, adapt.
      final decoded = jsonDecode(raw);

      // Expecting the JSON shape: { "data": [ { "PurchaseOrderNumberId": "...", "PurchaseOrderNumberName": "..." }, ... ] }
      final data = decoded['data'];
      if (data == null || data is! List) {
        emit(const PurchaseOrderNumberLoadFailure('Something went wrong, Please try again'));
        return;
      }

      final PurchaseOrderNumbers = data
          .map<PurchaseOrderNumberData>((e) => PurchaseOrderNumberData.fromJson(e as Map<String, dynamic>))
          .toList();

      emit(PurchaseOrderNumberLoadSuccess(PurchaseOrderNumbers));
    } catch (e) {
      emit(PurchaseOrderNumberLoadFailure(e.toString()));
    }
  }
}




