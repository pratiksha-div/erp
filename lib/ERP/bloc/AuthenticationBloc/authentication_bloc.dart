import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../api/models/loginModel.dart';
import '../../api/services/authentication_service.dart';
import '../../data/local/AppUtils.dart';
import '../../ui/Utils/messages_constants.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class loginUserEventPressed extends AuthenticationEvent {
  String username;
  String password;

  loginUserEventPressed(this.username, this.password);
}


abstract class AuthenticationState extends Equatable {
  const AuthenticationState();
  @override
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthenticationState {

}
class AuthenticationLoading extends AuthenticationState {

}
class AuthenticationSuccess extends AuthenticationState {

}
class AuthenticationFailed extends AuthenticationState {
  String message;

  AuthenticationFailed(this.message);
}
class AuthenticationFailedsso extends AuthenticationState {

  AuthenticationFailedsso();
}

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(AuthenticationInitial()) {
    on<loginUserEventPressed>((event, emit) async {
      emit(AuthenticationLoading());
      var result = await AuthenticationService().signUser(event.username, event.password);

      if (result == ConstantsMessage.serveError) {
        emit(AuthenticationFailed(ConstantsMessage.serveError));
      } else if (result == ConstantsMessage.incorrectPassword) {
        emit(AuthenticationFailed(ConstantsMessage.incorrectPassword));
      } else if (result is LoginResponse) {
        // Successfully logged in and got the LoginResponse object
        print(
          '''
          username ${event.username},
          password ${event.password},
          '''
        );
        if(result.code==200){
          try {
            if (result.token.isNotEmpty) {
              AppUtils().setUserLoggedIn(true);
              AppUtils().setUserID(result.userId);
              AppUtils().setToken(result.token);
              AppUtils().setEmployeeId(result.employeeId);
              await AppUtils().setLoginTime(DateTime.now());
              print("Token saved: ${result.token}");
            }
            // AuthenticationService().sendOTP();
            print("responseModel: $result");
            emit(AuthenticationSuccess());
          } catch (e, stacktrace) {
            // Catch any unexpected errors
            print('Error: $e\n$stacktrace');
            emit(AuthenticationFailed(result.message));
          }
        }
        else{
          emit(AuthenticationFailed(result.message));
        }

      } else {
        emit(AuthenticationFailed(ConstantsMessage.serveError));
      }
    });
  }
}
