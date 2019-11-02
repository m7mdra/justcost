import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:justcost/data/city/model/country.dart';
import 'package:justcost/data/user/model/register_error_response.dart';
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
            "${event.country.code}$event.phoneNumber",
            event.city);
        if (response.success) {
          print(response.data);
          await userSession.save(response);
          yield RegisterSuccess();
        } else {
          print(response.message);
          yield RegisterError(response.message);
        }
      } on DioError catch (e) {
        var errorRes = RegisterErrorResponse.fromJson(e.response.data);
        var validationError = errorRes.error.validationError;
        var errors = List.from(
          [
            validationError?.name?.join('\n'),
            validationError?.city?.join('\n'),
            validationError?.cPassword?.join('\n'),
            validationError?.password?.join('\n'),
            validationError?.mobile?.join('\n'),
            validationError?.firebaseToken?.join('\n'),
            validationError?.email?.join('\n'),
            validationError?.username?.join('\n')
          ],
        );
        errors.removeWhere((error)=>error==null);
        yield RegisterError(errors.join("\n"));
      }
    }
  }
}
