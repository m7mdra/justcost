import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class EditProfileEvent extends Equatable {}

class UpdatePasswordEvent extends EditProfileEvent {
  final String newPassword;
  final String confirmNewPassword;
  final currentPassword;

  UpdatePasswordEvent(
      {this.newPassword, this.confirmNewPassword, this.currentPassword});
}

class UpdateAccountInformationEvent extends EditProfileEvent {
  final String username;
  final String email;
  final String password;

  UpdateAccountInformationEvent({this.username, this.email, this.password});
}

class UpdatePersonalInformationEvent extends EditProfileEvent {
  final String fullName;
  final int gender;
  final int city;

  UpdatePersonalInformationEvent({this.fullName, this.gender, this.city});
}

class UpdateProfileAvatarEvent extends EditProfileEvent {
  final File originalImage;
  final File croppedImage;

  UpdateProfileAvatarEvent({this.originalImage, this.croppedImage});
}

class LoadUserDataEvent extends EditProfileEvent {}
