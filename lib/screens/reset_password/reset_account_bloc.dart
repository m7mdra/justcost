import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:justcost/data/user/user_repository.dart';
import 'package:dio/dio.dart';

abstract class ResetEvent extends Equatable {}

abstract class ResetState {}

class SubmitEmailEvent extends ResetEvent {
  final String email;

  SubmitEmailEvent(this.email);
}

class ResetLoadingState extends ResetState {}

class ResetErrorState extends ResetState {
  final String message;

  ResetErrorState(this.message);
}

class ResetSuccessState extends ResetState {}

class ResetIdleState extends ResetState {}

class ResetAccountBloc extends Bloc<ResetEvent, ResetState> {
  final UserRepository _repository;

  ResetAccountBloc(this._repository);

  @override
  ResetState get initialState => ResetIdleState();

  @override
  Stream<ResetState> mapEventToState(ResetEvent event) async* {
    if (event is SubmitEmailEvent) {
      yield ResetLoadingState();
      try {
        var response = await _repository.reset(event.email);
        if (response.status) {
          yield ResetSuccessState();
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
