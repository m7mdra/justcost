import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:justcost/data/user/user_repository.dart';
import 'package:dio/dio.dart';

abstract class VerificationState {}

abstract class VerificationEvent extends Equatable {}

class ResendVerification extends VerificationEvent {}

class VerificationLoading extends VerificationState {}

class VerificationIdle extends VerificationState {}

class VerificationError extends VerificationState {
  final String message;

  VerificationError(this.message);
}

class VerificationSuccess extends VerificationState {}

class AccountVerificationBloc
    extends Bloc<VerificationEvent, VerificationState> {
  final UserRepository _userRepository;

  AccountVerificationBloc(this._userRepository);

  @override
  VerificationState get initialState => VerificationIdle();

  @override
  Stream<VerificationState> mapEventToState(VerificationEvent event) async* {
    if (event is ResendVerification) {
      yield VerificationLoading();
      try {
        var response = await _userRepository.resendVerificationEmail();
        if (response.status) {
          yield VerificationSuccess();
        } else
          yield VerificationError(response.message);
      } on DioError catch (error) {
        switch (error.type) {
          case DioErrorType.CONNECT_TIMEOUT:
            yield VerificationError("Connection timedout, try again");
            break;
          case DioErrorType.SEND_TIMEOUT:
            yield VerificationError("Connection timedout, try again");
            break;
          case DioErrorType.RECEIVE_TIMEOUT:
            yield VerificationError("Connection timedout, try again");
            break;
          case DioErrorType.RESPONSE:
            yield VerificationError(
                "Server error, please try again or contact support team");
            break;
          case DioErrorType.CANCEL:
            break;
          case DioErrorType.DEFAULT:
            yield VerificationError(
                "Server error, please try again or contact support team");
            break;
        }
      }
    }
  }
}
