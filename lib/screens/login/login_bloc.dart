import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dio/dio.dart';
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
  void onTransition(Transition<LoginEvent, LoginState> transition) {
    // TODO: implement onTransition
    super.onTransition(transition);
    print(transition);
  }

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is GuestLogin) {
      session.guestLogin();
      await Future.delayed(Duration(seconds: 1));
      yield GuestLoginSuccess();
    }
    if (event is UserLogin) {
      yield LoginLoading();
      try {
        var authResponse = await repository.login(
            event.identifier, event.password, event.messagingId);
        if (authResponse.status) {
          await session.save(authResponse);
          await Future.delayed(Duration(seconds: 1));
          if (await session.isAccountVerified())
            yield LoginSuccess();
          else
            yield AccountNotVerified();
        } else {
          yield LoginError(authResponse.message);
        }
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
        yield LoginError(
            "Server error, please try again or contact support team");
      }
    }
  }
}
