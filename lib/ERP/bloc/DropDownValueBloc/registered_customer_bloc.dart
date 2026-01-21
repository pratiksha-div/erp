import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../api/models/DAOGetRegCustomer.dart';
import '../../api/services/dropdown_value_service.dart';

/// ================= EVENTS =================

abstract class RegisteredCustomerEvent extends Equatable {
  const RegisteredCustomerEvent();

  @override
  List<Object?> get props => [];
}

/// Fetch customers based on input text
class FetchRegisteredCustomerEvent extends RegisteredCustomerEvent {
  final String value;

  const FetchRegisteredCustomerEvent({required this.value});

  @override
  List<Object?> get props => [value];
}

/// Clear suggestion list (when text empty or item selected)
class ClearRegisteredCustomerEvent extends RegisteredCustomerEvent {
  const ClearRegisteredCustomerEvent();
}

/// ================= STATES =================

abstract class RegisteredCustomerState extends Equatable {
  const RegisteredCustomerState();

  @override
  List<Object?> get props => [];
}

class RegisteredCustomerInitial extends RegisteredCustomerState {}

class RegisteredCustomerLoading extends RegisteredCustomerState {}

class RegisteredCustomerLoadSuccess extends RegisteredCustomerState {
  final List<RegCustomerData> regCustomer;

  const RegisteredCustomerLoadSuccess(this.regCustomer);

  @override
  List<Object?> get props => [regCustomer];
}

class RegisteredCustomerFailure extends RegisteredCustomerState {
  final String error;

  const RegisteredCustomerFailure(this.error);

  @override
  List<Object?> get props => [error];
}

/// ================= SERVICE =================

abstract class RegisteredCustomerService {
  Future<String> fetchRegisteredCustomerRaw(String itemName);
}

/// Adapter for existing DropdownServices
class RegisteredCustomerServiceAdapter
    implements RegisteredCustomerService {
  final DropdownServices _dropDownService;

  RegisteredCustomerServiceAdapter({DropdownServices? dropDownService})
      : _dropDownService = dropDownService ?? DropdownServices();

  @override
  Future<String> fetchRegisteredCustomerRaw(String itemName) async {
    final result = await _dropDownService.getRegisteredCustomer(itemName);
    if (result is String) return result;
    return result?.toString() ?? '{}';
  }
}

/// ================= BLOC =================

class RegisteredCustomerBloc
    extends Bloc<RegisteredCustomerEvent, RegisteredCustomerState> {
  final RegisteredCustomerService _service;

  RegisteredCustomerBloc({required RegisteredCustomerService service})
      : _service = service,
        super(RegisteredCustomerInitial()) {
    on<FetchRegisteredCustomerEvent>(_onFetchRegisteredCustomer);
    on<ClearRegisteredCustomerEvent>(_onClearRegisteredCustomer);
  }

  /// Clear state
  void _onClearRegisteredCustomer(
      ClearRegisteredCustomerEvent event,
      Emitter<RegisteredCustomerState> emit,
      ) {
    emit(RegisteredCustomerInitial());
  }

  /// Fetch customers
  Future<void> _onFetchRegisteredCustomer(
      FetchRegisteredCustomerEvent event,
      Emitter<RegisteredCustomerState> emit,
      ) async {
    // 🔒 Avoid API call for short text
    if (event.value.trim().length < 2) {
      emit(RegisteredCustomerInitial());
      return;
    }

    emit(RegisteredCustomerLoading());

    try {
      final raw = await _service.fetchRegisteredCustomerRaw(event.value);
      final decoded = jsonDecode(raw);

      final data = decoded['data'];
      if (data == null || data is! List) {
        emit(const RegisteredCustomerFailure(
            'Something went wrong, Please try again'));
        return;
      }

      final customers = data
          .map<RegCustomerData>(
            (e) => RegCustomerData.fromJson(e as Map<String, dynamic>),
      )
          .toList();

      emit(RegisteredCustomerLoadSuccess(customers));
    } catch (e) {
      emit(RegisteredCustomerFailure(e.toString()));
    }
  }
}
