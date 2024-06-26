import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:justcost/data/exception/exceptions.dart';
import 'package:justcost/data/user/model/user.dart';
import 'package:justcost/data/user/user_repository.dart';
import 'package:justcost/data/user_sessions.dart';

abstract class ProfileState {}

abstract class ProfileEvent extends Equatable {
  ProfileEvent([List props = const []]) : super(props);
}

class LoadProfileEvent extends ProfileEvent {}

class ProfileLoadedSuccessState extends ProfileState {
  final User user;

  ProfileLoadedSuccessState(this.user);
}

class LogoutSuccessState extends ProfileState {}

class LogoutEvent extends ProfileEvent {}

class LogoutLoading extends ProfileState {}

class SessionsExpiredState extends ProfileState {}

class ProfileReloadFailedState extends ProfileState {
  final User user;

  ProfileReloadFailedState(this.user);
}

class GuestUserState extends ProfileState {}

class ProfileIdleState extends ProfileState {}

class UserProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserSession _session;
  final UserRepository _repository;

  UserProfileBloc(this._session, this._repository);

  @override
  ProfileState get initialState {
    return ProfileIdleState();
  }

  @override
  void onTransition(Transition<ProfileEvent, ProfileState> transition) {
    super.onTransition(transition);
    print(transition);
  }

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is LogoutEvent) {
      yield LogoutLoading();
      if (await _session.isUserAGoat())
        yield LogoutSuccessState();
      else {
        try {
          await _repository.logout();
          await Future.wait(
              [_session.clear(),_session.refresh(), FirebaseMessaging().deleteInstanceID()]);

          yield LogoutSuccessState();
        } catch (error) {
          await Future.wait(
              [_session.clear(),_session.refresh(), FirebaseMessaging().deleteInstanceID()]);
          yield LogoutSuccessState();
        }
      }
    }
    if (event is LoadProfileEvent) {
      if (await _session.isUserAGoat()) {
        yield GuestUserState();
      } else {
        try {
          var user = await _session.user();
          yield ProfileLoadedSuccessState(user.data.user);
          var response = await _repository.parse();
          if (response != null) {
            await _session.save(response);
            yield ProfileLoadedSuccessState(response.data.user);
          } else {
            yield ProfileReloadFailedState(user.data.user);
          }
        } on DioError catch (error) {
          print(error);
          var user = await _session.user();
          print(error);
          yield ProfileReloadFailedState(user.data.user);
        } on SessionExpired catch (error) {
          yield SessionsExpiredState();
          await _session.clear();
          await _session.refresh();

          print(error);
        } catch (error) {
          var user = await _session.user();
          print(error);

          yield ProfileReloadFailedState(user.data.user);
        }
      }
    }
  }
}
