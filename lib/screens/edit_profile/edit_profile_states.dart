import 'package:justcost/data/user/model/user.dart';

class EditProfileState {}

class UserLoadedState extends EditProfileState {
  final User payload;

  UserLoadedState(this.payload);
}

class AvatarUpdateSuccess extends EditProfileState {
  final User payload;

  AvatarUpdateSuccess(this.payload);
}

class IdleState extends EditProfileState {}

class AccountInformationUpdateSuccessState extends EditProfileState {
  final User user;

  AccountInformationUpdateSuccessState(this.user);
}

class PersonalInformationUpdateSuccessState extends EditProfileState {
  final User user;

  PersonalInformationUpdateSuccessState(this.user);
}

class LoadingState extends EditProfileState {}

class ErrorState<T> extends EditProfileState {
  final String message;
  final ErrorType errorType;
  final T event;

  ErrorState(this.message, this.errorType, this.event);
}

enum ErrorType { avatar, password, personal, account, none }

class PasswordChangedSuccess extends EditProfileState {}

class SessionExpiredState extends EditProfileState {}
