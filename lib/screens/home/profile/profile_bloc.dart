import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:justcost/data/user/model/auth_response.dart';
import 'package:justcost/data/user/user_repository.dart';
import 'package:justcost/data/user_sessions.dart';
import 'package:dio/dio.dart';

abstract class ProfileState {}

abstract class ProfileEvent extends Equatable {
  ProfileEvent([List props = const []]) : super(props);
}

class LoadProfileEvent extends ProfileEvent {}

class ProfileLoadedSuccessState extends ProfileState {
  final Payload userPayload;

  ProfileLoadedSuccessState(this.userPayload);
}

class LogoutSuccessState extends ProfileState {}

class LogoutEvent extends ProfileEvent {}

class ProfileReloadFailedState extends ProfileState {
  Payload userPayload;

  ProfileReloadFailedState(this.userPayload);
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
      if (await _session.isUserAGoat())
        yield LogoutSuccessState();
      else {
        String token = await _session.token();
        await _session.clear();
        //await _repository.logout();
        //TODO: call network api to terminate the token.
        yield LogoutSuccessState();
      }
    }
    if (event is LoadProfileEvent) {
      if (await _session.isUserAGoat()) {
        yield GuestUserState();
      } else {
        var user = await _session.user();
        print("user: $user");

        try {
          yield ProfileLoadedSuccessState(user.content.payload);
          var response = await _repository.parse();
          if (response != null) {
            yield ProfileLoadedSuccessState(response);
          } else {
            yield ProfileReloadFailedState(user.content.payload);
          }
        } on DioError catch (error) {
          print(error);
          yield ProfileReloadFailedState(user.content.payload);
        } catch (error) {
          print(error);
          yield ProfileReloadFailedState(user.content.payload);
        }
      }
    }
  }
}
