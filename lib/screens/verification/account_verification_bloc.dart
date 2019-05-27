import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:justcost/data/exception/exceptions.dart';
import 'package:justcost/data/user/user_repository.dart';
import 'package:justcost/data/user_sessions.dart';

abstract class VerificationState {}

abstract class VerificationEvent extends Equatable {}

class ResendVerification extends VerificationEvent {}

class SubmitVerificationCode extends VerificationEvent {
  final String code;

  SubmitVerificationCode(this.code);
}

class LogoutEvent extends VerificationEvent {}

class AccountVerifiedSuccessfully extends VerificationState {}

class AccountVerificationFailed extends VerificationState {
  final String message;

  AccountVerificationFailed(this.message);
}

class SessionExpiredState extends VerificationState {}

class VerificationLoading extends VerificationState {}

class VerificationIdle extends VerificationState {}

class ResendVerificationFailed extends VerificationState {
  final String message;

  ResendVerificationFailed(this.message);
}

class VerificationSentSuccess extends VerificationState {}

class AccountVerificationBloc
    extends Bloc<VerificationEvent, VerificationState> {
  final UserRepository _userRepository;
  final UserSession _session;

  AccountVerificationBloc(this._userRepository, this._session);

  @override
  VerificationState get initialState => VerificationIdle();

  @override
  Stream<VerificationState> mapEventToState(VerificationEvent event) async* {
    if (event is LogoutEvent) {
      await _session.clear();
      await _userRepository.logout();
    }
    if (event is SubmitVerificationCode) {
      yield VerificationLoading();
      try {
        var response = await _userRepository.submitActivationCode(event.code);
        if (response.success) {
          var data = response.data;
          await _session.saveUser(
              id: data.id,
              name: data.name,
              email: data.email,
              username: data.username,
              isVerified: data.isVerified,
              gender: data.gender,
              firebaseToken: data.firebaseToken,
              city: data.city);
          yield AccountVerifiedSuccessfully();
        } else {
          yield AccountVerificationFailed(response.message);
        }
      } on DioError catch (error) {
        switch (error.type) {
          case DioErrorType.CONNECT_TIMEOUT:
            yield AccountVerificationFailed("Connection timedout, try again");
            break;
          case DioErrorType.SEND_TIMEOUT:
            yield AccountVerificationFailed("Connection timedout, try again");
            break;
          case DioErrorType.RECEIVE_TIMEOUT:
            yield AccountVerificationFailed("Connection timedout, try again");
            break;
          case DioErrorType.RESPONSE:
            yield AccountVerificationFailed(
                "Server error, please try again or contact support team");
            break;
          case DioErrorType.CANCEL:
            break;
          case DioErrorType.DEFAULT:
            yield AccountVerificationFailed(
                "Server error, please try again or contact support team");
            break;
        }
      } on SessionExpired catch (error) {
        yield SessionExpiredState();
      } catch (error) {
        yield AccountVerificationFailed("Unknown error: $error}");
      }
    }
    if (event is ResendVerification) {
      yield VerificationLoading();
      try {
        var response = await _userRepository.resendVerificationEmail();
        if (response.status) {
          yield VerificationSentSuccess();
        } else
          yield ResendVerificationFailed(response.message);
      } on DioError catch (error) {
        switch (error.type) {
          case DioErrorType.CONNECT_TIMEOUT:
            yield ResendVerificationFailed("Connection timedout, try again");
            break;
          case DioErrorType.SEND_TIMEOUT:
            yield ResendVerificationFailed("Connection timedout, try again");
            break;
          case DioErrorType.RECEIVE_TIMEOUT:
            yield ResendVerificationFailed("Connection timedout, try again");
            break;
          case DioErrorType.RESPONSE:
            yield ResendVerificationFailed(
                "Server error, please try again or contact support team");
            break;
          case DioErrorType.CANCEL:
            break;
          case DioErrorType.DEFAULT:
            yield ResendVerificationFailed(
                "Server error, please try again or contact support team");
            break;
        }
      } on SessionExpired catch (error) {
        yield SessionExpiredState();
      } catch (e) {
        yield ResendVerificationFailed(
            "Server error, please try again or contact support team");
      }
    }
  }
}
