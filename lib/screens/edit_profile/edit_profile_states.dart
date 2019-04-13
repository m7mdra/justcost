import 'package:justcost/data/user/model/auth_response.dart';

class EditProfileState {}

class UserLoadedState extends EditProfileState {
  final Payload payload;

  UserLoadedState(this.payload);
}

class AvatarUpdateSuccess extends EditProfileState {
  final Payload payload;

  AvatarUpdateSuccess(this.payload);
}

class AccountInformationUpdateSuccessState extends EditProfileState {
  final Payload payload;

  AccountInformationUpdateSuccessState(this.payload);
}

class PersonalInformationUpdateSuccessState extends EditProfileState {
  final Payload payload;

  PersonalInformationUpdateSuccessState(this.payload);
}


class LoadingState extends EditProfileState {
    final Payload payload;

  LoadingState(this.payload);

}

class ErrorState extends EditProfileState {
  final String message;

  ErrorState(this.message);
}

class PasswordChangedSuccess extends EditProfileState {}

class SessionExpiredState extends EditProfileState {}
