import 'package:justcost/data/user/model/auth_response.dart';

class EditProfileState {}

class UserLoadedState extends EditProfileState {
  final Payload payload;

  UserLoadedState(this.payload);
}

class AvatarUpdateSuccess extends EditProfileState {}

class AccountInformationUpdateSuccessState extends EditProfileState {}

class PersonalInformationUpdateSuccessState extends EditProfileState {}

class PasswordUpdateSuccess extends EditProfileState {}

class LoadingState extends EditProfileState {}

class ErrorState extends EditProfileState {}

class PasswordChangedSuccess extends EditProfileState {}
