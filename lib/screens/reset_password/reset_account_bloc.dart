import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:justcost/data/user/user_repository.dart';
import 'package:justcost/screens/edit_profile/edit_profile_states.dart';
import 'package:justcost/screens/edit_profile/edit_profile_states.dart';

abstract class ResetEvent extends Equatable {}

abstract class ResetState {}

class SubmitEmailEvent extends ResetEvent {
  final String email;

  SubmitEmailEvent(this.email);
}

class SubmitPhoneNumber extends ResetEvent {
  final String phoneNumber;

  SubmitPhoneNumber(this.phoneNumber);
}

class OnBackPressedEvent extends ResetEvent {}

class PhoneNumberResetSelected extends ResetEvent {}

class EmailResetSelected extends ResetEvent {}


class SendCodeEvent extends ResetEvent {
  final String code;
  final String mobile;

  SendCodeEvent(this.code,this.mobile);
}

class InsertNewPassword extends ResetEvent {
  final String password;
  final String token;

  InsertNewPassword({this.password,this.token});
}

class PhoneNumberResetSelectedState extends ResetState {}

class EmailResetSelectedState extends ResetState {}

class ResetLoadingState extends ResetState {}

class ResetErrorState extends ResetState {
  final String message;

  ResetErrorState(this.message);
}

class SendCodeSuccessState extends ResetState {
  String token;

  SendCodeSuccessState({this.token});
}

class PasswordChangedSuccess extends ResetState {}

class ResetSuccessState extends ResetState {
  String phone;

  ResetSuccessState({this.phone});
}

class ResetEmailSuccessState extends ResetState {}

class ResetIdleState extends ResetState {}

class ResetAccountBloc extends Bloc<ResetEvent, ResetState> {
  final UserRepository _repository;

  ResetAccountBloc(this._repository);

  @override
  ResetState get initialState => ResetIdleState();

  @override
  Stream<ResetState> mapEventToState(ResetEvent event) async* {
    if (event is PhoneNumberResetSelected)
      yield PhoneNumberResetSelectedState();
    if (event is EmailResetSelected) yield EmailResetSelectedState();

    if (event is SubmitPhoneNumber) {
      yield ResetLoadingState();
      try {
        var response = await _repository.resetPhoneRequest(event.phoneNumber);
        if (response.status) {
          yield ResetSuccessState(phone: event.phoneNumber);
        } else {
          yield ResetErrorState(response.message);
        }
      } on DioError catch (e) {
        switch (e.type) {
          case DioErrorType.CONNECT_TIMEOUT:
            yield ResetErrorState("Connection timedout, try again");
            break;
          case DioErrorType.SEND_TIMEOUT:
            yield ResetErrorState("Connection timedout, try again");
            break;
          case DioErrorType.RECEIVE_TIMEOUT:
            yield ResetErrorState("Connection timedout, try again");
            break;
          case DioErrorType.RESPONSE:
            yield ResetErrorState(
                "Server error, please try again or contact support team");

            break;
          case DioErrorType.CANCEL:
          case DioErrorType.DEFAULT:
            yield ResetErrorState(
                "Server error, please try again or contact support team");
            break;
        }
      }
    }
    if (event is SendCodeEvent) {
      yield ResetLoadingState();
      try {
        var response = await _repository.sendCodeRequest(event.code,event.mobile);
        print('RESPONSE   : $response');
        if (response['success']) {
          yield SendCodeSuccessState(token: response['data']['token']);
        } else {
          yield ResetErrorState(response.message);
        }
      } on DioError catch (e) {
        switch (e.type) {
          case DioErrorType.CONNECT_TIMEOUT:
            yield ResetErrorState("Connection timedout, try again");
            break;
          case DioErrorType.SEND_TIMEOUT:
            yield ResetErrorState("Connection timedout, try again");
            break;
          case DioErrorType.RECEIVE_TIMEOUT:
            yield ResetErrorState("Connection timedout, try again");
            break;
          case DioErrorType.RESPONSE:
            yield ResetErrorState(
                "Server error, please try again or contact support team");

            break;
          case DioErrorType.CANCEL:
          case DioErrorType.DEFAULT:
            yield ResetErrorState(
                "Server error, please try again or contact support team");
            break;
        }
      }
    }
    if (event is InsertNewPassword) {
      yield ResetLoadingState();
      try {
        var response = await _repository.sendNewPasswordRequest(event.password,event.token);
        if (response.status) {
          yield PasswordChangedSuccess();
        } else {
          yield ResetErrorState(response.message);
        }
      } on DioError catch (e) {
        switch (e.type) {
          case DioErrorType.CONNECT_TIMEOUT:
            yield ResetErrorState("Connection timedout, try again");
            break;
          case DioErrorType.SEND_TIMEOUT:
            yield ResetErrorState("Connection timedout, try again");
            break;
          case DioErrorType.RECEIVE_TIMEOUT:
            yield ResetErrorState("Connection timedout, try again");
            break;
          case DioErrorType.RESPONSE:
            yield ResetErrorState(
                "Server error, please try again or contact support team");

            break;
          case DioErrorType.CANCEL:
          case DioErrorType.DEFAULT:
            yield ResetErrorState(
                "Server error, please try again or contact support team");
            break;
        }
      }
    }

    if (event is SubmitEmailEvent) {
      yield ResetLoadingState();
      try {
        var response = await _repository.resetEmailRequest(event.email);
        if (response['success'] == 'done') {
          yield ResetEmailSuccessState();
        } else {
          yield ResetErrorState(response.message);
        }
      } on DioError catch (e) {
        switch (e.type) {
          case DioErrorType.CONNECT_TIMEOUT:
            yield ResetErrorState("Connection timedout, try again");
            break;
          case DioErrorType.SEND_TIMEOUT:
            yield ResetErrorState("Connection timedout, try again");
            break;
          case DioErrorType.RECEIVE_TIMEOUT:
            yield ResetErrorState("Connection timedout, try again");
            break;
          case DioErrorType.RESPONSE:
            yield ResetErrorState(
                "Server error, please try again or contact support team");

            break;
          case DioErrorType.CANCEL:
          case DioErrorType.DEFAULT:
            yield ResetErrorState(
                "Server error, please try again or contact support team");
            break;
        }
      }
    }

  }
}
