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
            event.address);
        print(response);
        if (response.status) {
          await userSession.save(response);
          yield RegisterSuccess();
        } else {
          yield RegisterError(response.message);
        }
      } on DioError catch (e) {
        yield RegisterError(e.message);
      }
    }
  }
}
