import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../UI/Pages/GateEntry/GateEntry.dart';
import '../../api/models/DAOGetPurchaseOrderDetail.dart';
import '../../api/services/add_machine_reading_service.dart';
import '../../api/services/gate_entry_service.dart';

// PurchaseOrderDetailEvent
abstract class PurchaseOrderDetailEvent extends Equatable {
  const PurchaseOrderDetailEvent();

  @override
  List<Object?> get props => [];
}

class FetchPurchaseOrderDetailEvent extends PurchaseOrderDetailEvent {
  final String poValue;

  const FetchPurchaseOrderDetailEvent({required this.poValue});

  @override
  List<Object?> get props => [poValue];
}


// PurchaseOrderDetailState
abstract class PurchaseOrderDetailState extends Equatable {
  const PurchaseOrderDetailState();

  @override
  List<Object?> get props => [];
}

class PurchaseOrderDetailInitial extends PurchaseOrderDetailState {}

class PurchaseOrderDetailLoading extends PurchaseOrderDetailState {}

class PurchaseOrderDetailLoadSuccess extends PurchaseOrderDetailState {
  final List<PurchaseDetail> purchaseOrderDetail;

  const PurchaseOrderDetailLoadSuccess(this.purchaseOrderDetail);

  @override
  List<Object?> get props => [purchaseOrderDetail];
}

class PurchaseOrderDetailFailure extends PurchaseOrderDetailState {
  final String error;

  const PurchaseOrderDetailFailure(this.error);

  @override
  List<Object?> get props => [error];
}


// ********* Interface expected by the bloc *************//
abstract class PurchaseOrderDetailService {
  Future<String> fetchPurchaseOrderDetailRaw(String godownId);
}



/// Adapter that uses your existing EmployeeServices class
class PurchaseOrderDetailServiceAdapter implements PurchaseOrderDetailService {
  final GetPurchaseOrderDataService _PurchaseOrderDetailService;

  PurchaseOrderDetailServiceAdapter({GetPurchaseOrderDataService? PurchaseOrderDetailService})
      : _PurchaseOrderDetailService = PurchaseOrderDetailService ?? GetPurchaseOrderDataService();

  @override
  Future<String> fetchPurchaseOrderDetailRaw(String Id) async {
    final result = await _PurchaseOrderDetailService.fetchPurchaseOrderData(Id);
    if (result is String) return result;
    try {
      return result != null ? result.toString() : '{}';
    } catch (_) {
      return '{}';
    }
  }

}



/// Bloc implementation
class PurchaseOrderDetailBloc extends Bloc<PurchaseOrderDetailEvent, PurchaseOrderDetailState> {
  final PurchaseOrderDetailService _service;

  PurchaseOrderDetailBloc({required PurchaseOrderDetailService service})
      : _service = service,
        super( PurchaseOrderDetailInitial()) {
    on<FetchPurchaseOrderDetailEvent>(_onFetchMaterialIssue);
  }

  Future<void> _onFetchMaterialIssue(
      FetchPurchaseOrderDetailEvent event, Emitter<PurchaseOrderDetailState> emit) async {
    emit( PurchaseOrderDetailLoading());

    try {
      final raw = await _service.fetchPurchaseOrderDetailRaw(event.poValue);

      // raw might already be a JSON string. If your service returns Map, adapt.
      final decoded = jsonDecode(raw);
      // Expecting the JSON shape: { "data": [ { "EmployeeId": "...", "EmployeeName": "..." }, ... ] }
      final data = decoded['data'];
      if (data == null || data is! List) {
        emit(const PurchaseOrderDetailFailure('Something went wrong, Please try again'));
        return;
      }

      final purchaseOrderDetail = data.map<PurchaseDetail>((e) => PurchaseDetail.fromJson(e as Map<String, dynamic>)).toList();

      emit(PurchaseOrderDetailLoadSuccess(purchaseOrderDetail));
    } catch (e) {
      emit(PurchaseOrderDetailFailure(e.toString()));
    }
  }
}