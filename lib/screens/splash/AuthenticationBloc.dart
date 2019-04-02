import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:justcost/data/user_sessions.dart';
import 'package:meta/meta.dart';

abstract class AuthenticationEvent extends Equatable {
  AuthenticationEvent([List props = const []]) : super(props);
}

abstract class AuthenticationState extends Equatable {}

class AppStarted extends AuthenticationEvent {
  @override
  String toString() => 'AppStarted';
}

class AccountNotVerified extends AuthenticationState {}

class AuthenticationUninitialized extends AuthenticationState {
  @override
  String toString() => 'AuthenticationUninitialized';
}

class AuthenticationAuthenticated extends AuthenticationState {
  @override
  String toString() => 'AuthenticationAuthenticated';
}

class AuthenticationUnauthenticated extends AuthenticationState {
  @override
  String toString() => 'AuthenticationUnauthenticated';
}

class AuthenticationLoading extends AuthenticationState {
  @override
  String toString() => 'AuthenticationLoading';
}

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserSession session;

  AuthenticationBloc({@required this.session}) : assert(session != null);

  @override
  AuthenticationState get initialState => AuthenticationUninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event) async* {
    if (event is AppStarted) {
      yield AuthenticationLoading();
      bool hasToken = await session.hasToken();
      await Future.delayed(Duration(seconds: 1));
      if (hasToken)
        yield AuthenticationAuthenticated();
      else
        yield AuthenticationUnauthenticated();
    }
  }
}
