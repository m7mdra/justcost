import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:justcost/data/exception/exceptions.dart';
import 'package:justcost/data/user/user_repository.dart';
import 'package:justcost/data/user_sessions.dart';

abstract class LoginEvent extends Equatable {
  LoginEvent([List props = const []]) : super(props);
}

abstract class LoginState extends Equatable {}

class LoginLoading extends LoginState {}

class LoginIdle extends LoginState {}

class LoginError extends LoginState {
  final String message;

  LoginError(this.message);
}

class AccountNotVerified extends LoginState {}

class UserNameOrPasswordInvalid extends LoginState {}

class LoginSuccess extends LoginState {}

class GuestLoginSuccess extends LoginState {}

class UserLogin extends LoginEvent {
  final String identifier;
  final String password;
  final String messagingId;

  UserLogin(this.identifier, this.password, this.messagingId);
}

class GuestLogin extends LoginEvent {}

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository repository;
  final UserSession session;

  LoginBloc(this.repository, this.session);

  @override
  LoginState get initialState => LoginIdle();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is GuestLogin) {
      session.guestLogin();
      yield GuestLoginSuccess();
    }
    if (event is UserLogin) {
      yield LoginLoading();
      try {
        var authResponse = await repository.login(
            event.identifier, event.password, event.messagingId);
        if (authResponse.success) {
          await session.save(authResponse);
          if (await session.isAccountVerified())
            yield LoginSuccess();
          else
            yield AccountNotVerified();
        } else {
          if(authResponse.message == "User login Unauthorized."){
            yield LoginError("Username or password is wronge");
          }
        }
      } on SessionExpired {
        yield UserNameOrPasswordInvalid();
      } on DioError catch (e) {
        print(e);
        switch (e.type) {
          case DioErrorType.CONNECT_TIMEOUT:
            yield LoginError("Connection timedout, try again");
            break;
          case DioErrorType.SEND_TIMEOUT:
            yield LoginError("Connection timedout, try again");
            break;
          case DioErrorType.RECEIVE_TIMEOUT:
            yield LoginError("Connection timedout, try again");
            break;
          case DioErrorType.RESPONSE:
            yield LoginError(
                "Server error, please try again or contact support team");
            break;
          case DioErrorType.CANCEL:
            break;
          case DioErrorType.DEFAULT:
            yield LoginError(
                "Server error, please try again or contact support team");
            break;
        }
      } catch (e) {
        print(e);

        yield LoginError(
            "Server error, please try again or contact support team");
      }
    }
  }
}
