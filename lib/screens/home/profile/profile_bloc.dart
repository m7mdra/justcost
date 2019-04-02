import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:justcost/data/user/model/auth_response.dart';
import 'package:justcost/data/user_sessions.dart';

abstract class ProfileState {}

abstract class ProfileEvent extends Equatable {}

class LoadLocalProfile extends ProfileEvent {}

class ProfileLoadedSuccessState extends ProfileState {
  final AuthenticationResponse response;

  ProfileLoadedSuccessState(this.response);
}

class GuestUserState extends ProfileState {}

class ProfileIdleState extends ProfileState {}

class UserProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserSession session;

  UserProfileBloc(this.session);

  @override
  ProfileState get initialState => ProfileIdleState();

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is LoadLocalProfile) {
      if (await session.isUserAGoat())
        yield GuestUserState();
      else {
        var user = await session.user();
        yield ProfileLoadedSuccessState(user);
        //TODO call network and get updated user data and save it again to the shared preference
      }
    }
  }
}
