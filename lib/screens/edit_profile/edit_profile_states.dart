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

class IdleState extends EditProfileState {}

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

class ErrorState<T> extends EditProfileState {
  final String message;
  final ErrorType errorType;
  final T event;

  ErrorState(this.message, this.errorType, this.event);
}

enum ErrorType { avatar, password, personal, account, none }

class PasswordChangedSuccess extends EditProfileState {}

class SessionExpiredState extends EditProfileState {}
