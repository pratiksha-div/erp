import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../api/models/AddProjectModel.dart';
import '../../api/models/loginModel.dart';
import '../../api/services/authentication_service.dart';
import '../../data/local/AppUtils.dart';
import '../../ui/Utils/messages_constants.dart';

abstract class VerifyOTPEvent extends Equatable {
  const VerifyOTPEvent();
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class VerifyOTPEventPressed extends VerifyOTPEvent {
  String otp;

  VerifyOTPEventPressed(this.otp);
}



abstract class VerifyOTPState extends Equatable {
  const VerifyOTPState();
  @override
  List<Object> get props => [];
}

class VerifyOTPInitial extends VerifyOTPState {

}
class VerifyOTPLoading extends VerifyOTPState {

}
class VerifyOTPSuccess extends VerifyOTPState {

}
class VerifyOTPFailed extends VerifyOTPState {
  String message;

  VerifyOTPFailed(this.message);
}
class VerifyOTPFailedsso extends VerifyOTPState {

  VerifyOTPFailedsso();
}



class VerifyOTPBloc extends Bloc<VerifyOTPEvent, VerifyOTPState> {
  VerifyOTPBloc() : super(VerifyOTPInitial()) {
    on<VerifyOTPEventPressed>((event, emit) async {
      emit(VerifyOTPLoading());
      var result = await AuthenticationService().verifyOTPService(event.otp);
         if (result is BaseResponse) {
        try {
          final response = result as LoginResponse;
          Fluttertoast.showToast(
            msg: "Successfully Logged in",
          );
          print("responseModel: $response");
          emit(VerifyOTPSuccess());
        } catch (e, stacktrace) {
          print('Error: $e\n$stacktrace');
          emit(VerifyOTPFailed(ConstantsMessage.serveError));
        }
      } else {
        emit(VerifyOTPFailed(ConstantsMessage.serveError));
      }
    });
  }
}
