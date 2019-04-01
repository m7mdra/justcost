import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:justcost/screens/data/user/user_repo.dart';
import 'package:justcost/screens/data/user_sessions.dart';
import 'package:dio/dio.dart';

abstract class RegisterState extends Equatable {}

abstract class RegisterEvent extends Equatable {}

class RegisterLoading extends RegisterState {}

class RegisterError extends RegisterState {
  final String message;

  RegisterError(this.message);
}

class RegisterIdle extends RegisterState {}

class RegisterSuccess extends RegisterState {}

class UserRegister extends RegisterEvent {
  final String username;
  final String password;
  final String email;
  final String messagingId;
  final String address;
  final String phoneNumber;
  final File avatar;

  UserRegister(
      {this.username,
      this.password,
      this.avatar,
      this.email,
      this.messagingId,
      this.address,
      this.phoneNumber});
}

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final UserSession userSession;
  final UserRepository userRepository;

  RegisterBloc(this.userSession, this.userRepository);

  @override
  RegisterState get initialState => RegisterIdle();

  @override
  void onTransition(Transition<RegisterEvent, RegisterState> transition) {
    super.onTransition(transition);
    print(transition);
  }

  @override
  Stream<RegisterState> mapEventToState(RegisterEvent event) async* {
    if (event is UserRegister) {
      yield RegisterLoading();

      try {
        var response = await userRepository.createAccount(
            event.username,
            event.email,
            event.password,
            event.password,
            event.messagingId,
            event.address,
            event.avatar,
            event.phoneNumber);
        print(response);
        if (response.status) {
          await userSession.save(response);
          await Future.delayed(Duration(seconds: 1));
          yield RegisterSuccess();
        } else {
          yield RegisterError(response.message);
        }
      } on DioError catch (e) {
        switch (e.type) {
          case DioErrorType.CONNECT_TIMEOUT:
            yield RegisterError("Connection timedout, try again");
            break;
          case DioErrorType.SEND_TIMEOUT:
            yield RegisterError("Connection timedout, try again");
            break;
          case DioErrorType.RECEIVE_TIMEOUT:
            yield RegisterError("Connection timedout, try again");
            break;
          case DioErrorType.RESPONSE:
            yield RegisterError(
                "Server error, please try again or contact support team");

            break;
          case DioErrorType.CANCEL:
            break;
          case DioErrorType.DEFAULT:
            yield RegisterError(
                "Server error, please try again or contact support team");
            break;
        }
      }
    }
  }
}
