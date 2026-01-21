import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../UI/Utils/messages_constants.dart';
import '../../api/services/authentication_service.dart';


abstract class OtpEvent extends Equatable {
  const OtpEvent();

  @override
  List<Object?> get props => [];
}

// Trigger fetching OTP data
class FetchOtpEvent extends OtpEvent {}


abstract class OtpState extends Equatable {
  const OtpState();

  @override
  List<Object?> get props => [];
}

class OtpInitial extends OtpState {}

class OtpLoading extends OtpState {}

class OtpLoaded extends OtpState {
  final String message;
  final int code;
  final int otp;

  const OtpLoaded({
    this.message="",
    this.code=200,
    this.otp=0,
  });

  @override
  List<Object?> get props => [message, code, otp];
}

class OtpError extends OtpState {
  final String error;

  const OtpError(this.error);

  @override
  List<Object?> get props => [error];
}


class OtpBloc extends Bloc<OtpEvent, OtpState> {
  OtpBloc() : super(OtpInitial()) {
    on<OtpEvent>((event, emit) async {
      emit(OtpLoading());

      try {
        final result = await AuthenticationService().sendOTP();

        print("OTP response: $result");
        if (result.code == "200") {
          Fluttertoast.showToast(
            msg: "OTP sent to your email",
          );
          emit(OtpLoaded());
        } else {
          emit(OtpError(result.massage ?? ConstantsMessage.serveError));
        }

      } catch (e, st) {
        print("Exception occurred wile sending otp to your email: $e\n$st");
        emit(OtpError(ConstantsMessage.serveError));
      }
    });
  }
}


