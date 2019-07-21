import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:justcost/i10n/messages_all.dart';

class AppLocalizations {

  static Future<AppLocalizations> load(Locale locale) {
    final String name =
        locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      return AppLocalizations();
    });
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  String get loginLoadingMessage =>
      Intl.message('Please wait while trying to login.',
          name: 'loginLoadingMessage');
  String get logoutButton => Intl.message("Logout");


  String get continueButton => Intl.message('Continue');

  String get homePageTitle => Intl.message('Home');

  String get searchPageTitle => Intl.message('Search');

  String get postAdPageTitle => Intl.message('Post Ad');

  String get categoriesPageTitle => Intl.message('Categories');

  String get profilePageTitle => Intl.message('Profile');

  String get resetAccount => Intl.message('Reset Account');

  String get resetAccountSuccess =>
      Intl.message('An email was sent successfully to your account');

  String get resetAccountInstruction => Intl.message(
      'Type your e-mail address and will send you a mail containing the instructions to reset your password');

  String get didNotReceivedEmail => Intl.message('Didnt receive email?');

  String get resendButton => Intl.message('Resend');

  String get verificationFieldEmptyError =>
      Intl.message('Verification code Field is Empty');

  String get accountVerificationHeading =>
      Intl.message('Account Verficiation is required.');

  String get verificationCodeFieldHint => Intl.message('Verification Code');

  String get accountVerificationSubhead => Intl.message(
      'An Sms was sent to your phone number containing the code');

  String get verificationLoadingMessage =>
      Intl.message('Please wait while trying to verify your account.',
          name: 'verificationLoadingMessage');

  String get submitButton => Intl.message('Submit');

  String get accountVerifiedSuccess =>
      Intl.message('Account Verified Successfully.');

  String get sessionExpiredMessage =>
      Intl.message('Session Expired, log in again');

  String get phoneNumberField => Intl.message('Phone Number');

  String get accountCreation => Intl.message('Account Creation');

  String get createAccountLoadingMessage =>
      Intl.message('"Please wait while creating account."',
          name: 'createAccountLoadingMessage');

  String get appName => Intl.message('JustCost', name: 'appName');

  String get usernameFieldHint =>
      Intl.message('Username', name: 'usernameFieldHint');

  String get phoneNumberEmptyError =>
      Intl.message('Phone Number field can not be empty');

  String get usernameFieldEmptyError =>
      Intl.message('Username field can not be empty');

  String get emailFieldEmptyError =>
      Intl.message('Email field can not be empty');

  String get emailFieldInvalidError => Intl.message('Email field is invalid');

  String get emailFieldHint => Intl.message('E-mail address');

  String get passwordFieldEmptyError =>
      Intl.message('Password field can not be empty');

  String get forgotPasswordButton => Intl.message('Forgot Password?');

  String get continueAsGuestButton => Intl.message('Continue as guest');

  String get createAccountButton => Intl.message('Create account');

  String get aboutUsButton => Intl.message('About us');

  String get getHelp => Intl.message('Get Help');

  String appVersion(String version) =>
      Intl.message('Version $version', args: [version], name: 'appVersion');

  String get passwordFieldHint =>
      Intl.message('Password', name: 'passwordFieldHint');

  String get loginScreenName => Intl.message('Login', name: 'loginScreenName');

  String copyRights(int date) =>
      Intl.message('Copyright © $date, All Rights resereved',
          args: [date], name: 'copyRights');

  String get privacy => Intl.message('Privacy');

  String get notificationPanel => Intl.message('Notifications');

  String get tos => Intl.message('Term of Service');

  String get generalError => Intl.message('Error Occurred');

  String get addressFieldEmptyError =>
      Intl.message("Address Field can not be empty");

  String get addressField => Intl.message('Address');

  String get logoutSuccessMessage => Intl.message('Logged out successfully');

  String get passwordChangedSuccessfully =>
      Intl.message('Password Changed successfully, login again.');

  String get fullNameField => Intl.message('Full Name');

  String get country => Intl.message("Country");

  String get city => Intl.message("City");

  String get gender => Intl.message("Gender");

  String get passwordValidationMoreThan6 =>
      Intl.message('Password can not be less than 6 characters');

  String get nameValidationEmptyError =>
      Intl.message('Name field can not be empty');

  String get loginErrorMessageTitle => Intl.message('Invalid Credentials');

  String get loginErrorMessageMessage =>
      Intl.message('Check your password/username first then try again.');

  String get didntReceiveSms => Intl.message("Didnt receive verification?");
  String get resetSuccessTitle=>Intl.message('Reset Message was sent successfully');
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ar'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(locale);

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
