import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:justcost/data/user/user_repository.dart';
import 'package:justcost/data/user_sessions.dart';

abstract class AuthenticationEvent extends Equatable {
  AuthenticationEvent([List props = const []]) : super(props);
}

abstract class AuthenticationState extends Equatable {}

class AppStarted extends AuthenticationEvent {}

class UpdateMessagingId extends AuthenticationEvent {
  final String newToken;

  UpdateMessagingId(this.newToken);
}

class AccountNotVerified extends AuthenticationState {}

class AuthenticationUninitialized extends AuthenticationState {}

class UserAuthenticated extends AuthenticationState {}

class UserUnauthenticated extends AuthenticationState {}

class AuthenticationLoading extends AuthenticationState {}

class AuthenticationFailed extends AuthenticationState {}

class FirstTimeLaunch extends AuthenticationState {}

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserSession session;
  final UserRepository repository;

  AuthenticationBloc({this.repository, this.session});

  @override
  AuthenticationState get initialState => AuthenticationUninitialized();

  @override
  void onTransition(
      Transition<AuthenticationEvent, AuthenticationState> transition) {
    super.onTransition(transition);
    print(transition);
  }

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event) async* {
    if (event is AppStarted) {
      if (await session.isFirstTimeLaunch()) {
        await session.setFirstTimeLaunched();

        yield FirstTimeLaunch();
      } else {
        await Future.delayed(Duration(seconds: 2));
        yield AuthenticationLoading();
        bool hasToken = await session.hasToken();
        if (hasToken) {
          if (await session.isAccountVerified()) {
            yield UserAuthenticated();
          } else {
            try {
              var parseResponse = await repository.parse();
              if (parseResponse != null) {
                if (parseResponse.data.user.isVerified) {
                  /// SAVE TOKEN IN ALL CASES BECAUSE THE USER GOT HERE BECAUSE IT WAS
                  /// OBSOLETE DATA
                  await session.save(parseResponse);
                  yield UserAuthenticated();
                } else
                  yield AccountNotVerified();
              }
            } on DioError catch (error) {
              yield AuthenticationFailed();
            } catch (error) {
              yield AuthenticationFailed();
            }
          }
        } else
          yield UserUnauthenticated();
      }
    }
  }
}
