import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:justcost/data/city/model/country.dart';
import 'package:justcost/data/user/user_repository.dart';
import 'package:justcost/data/user_sessions.dart';

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
  final String name;
  final String username;
  final String password;
  final String email;
  final String messagingId;
  final String phoneNumber;
  final Country country;
  final int city;

  UserRegister(
      {this.name,
      this.username,
      this.country,
      this.password,
      this.email,
      this.messagingId,
      this.phoneNumber,
      this.city});
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
  }

  @override
  Stream<RegisterState> mapEventToState(RegisterEvent event) async* {
    if (event is UserRegister) {
      yield RegisterLoading();
      try {
        var response = await userRepository.createAccount(
            event.name,
            event.username,
            event.email,
            event.password,
            event.password,
            event.messagingId,
            "${event.country.code}${event.phoneNumber}",
            event.city);
        if (response.success) {
          await userSession.save(response);
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
