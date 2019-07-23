import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:justcost/i10n/messages_all.dart';

class AppLocalizations {
  String get contactSupportTryAgain =>
      Intl.message('try again or contact support.');

  String get tryAgainButton => Intl.message('Try again');

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

  String get pickCity => Intl.message('Pick City');

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

  String get accountVerificationSubhead =>
      Intl.message('An Sms was sent to your phone number containing the code');

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

  String get fullNameEmptyError => Intl.message('Full name field is required.');

  String get nameValidationEmptyError =>
      Intl.message('Name field can not be empty');

  String get loginErrorMessageTitle => Intl.message('Invalid Credentials');

  String get loginErrorMessageMessage =>
      Intl.message('Check your password/username first then try again.');

  String get didntReceiveSms => Intl.message("Didnt receive verification?");

  String get resetSuccessTitle =>
      Intl.message('Reset Message was sent successfully');

  String get weSentMessageTo => Intl.message('We sent a message to ');

  String get containing => Intl.message('containing');

  String get fiveDigitCode =>
      Intl.message('digit code write it below to verify that its you.');

  String get usePhoneNumberOption => Intl.message('Use Phone number');

  String get useEmailOption => Intl.message('Use Email address');

  String get resetInstructions =>
      Intl.message('To Reset your account you can use Phone number or '
          'E-mail address associated with the account.');

  String get phoneNumberResetInstruction =>
      Intl.message('Type your Phone number and will send you a sms message'
          ' containing the instructions to reset your account.');

  String get emailResetInstruction =>
      Intl.message('Type your Email Address and will send you an Email message'
          ' containing the instructions to reset your account.');

  String get search => Intl.message('Search');

  String get sortSearchResult => Intl.message('Sort Search Result');

  String get sortByNameASC => Intl.message('Name - Ascending');

  String get sortByNameDESC => Intl.message('Name - Descending');

  String get sortByPriceASC => Intl.message('Price - Ascending');

  String get sortByPriceDESC => Intl.message('Price - Descending');

  String get sortByDiscountASC => Intl.message('Discount - Ascending');

  String get sortByDiscountDESC => Intl.message('Discount - Descending');

  String get sort => Intl.message('Sort');

  String get filterByCity => Intl.message('Filter by City');

  String get name => Intl.message('Name');

  String get price => Intl.message('Price');

  String get discount => Intl.message('Discount');

  String get recentAds => Intl.message('Recent Ads');

  String get featuredAds => Intl.message('Recent Ads');

  String get editProfile => Intl.message('Edit Profile');

  String get settings => Intl.message('Settings');

  String get notifications => Intl.message('Notifications');

  String get aboutUs => Intl.message('About us');

  String get logout => Intl.message('Logout');

  String get captureImage => Intl.message('Capture Image');

  String get pickFromGallery => Intl.message('Pick Image from gallery');

  String get uploadMethodAvatar =>
      Intl.message('Select A method to add avatar');

  String get updateProfileAvatar => Intl.message('Update Profile Avatar');

  String get personalInformation => Intl.message('Personal Information');

  String get na => Intl.message('Not added');

  String get male => Intl.message('Male');

  String get female => Intl.message('Female');

  String get location => Intl.message("message");

  String get accountInformation => Intl.message("Account Information");

  String get accountSecurity => Intl.message("Account Security");

  String get changePassword => Intl.message("Chnage Password");

  String get updateButton => Intl.message("Update");

  String get changePasswordSubtitle =>
      Intl.message("this proccess Requires you to relogin after chaning.");

  String get failedToUpdateProfile =>
      Intl.message('Failed to update Profile, try again');

  String get updateAccountInformation =>
      Intl.message('Update Account Information');

  String get updatePassword => Intl.message('Update Password');

  String get newPasswordFieldEmptyError =>
      Intl.message('New password Field is required.');

  String get newPasswordConfirmFieldEmptyError =>
      Intl.message('New Password confirmation is required.');

  String get passwordMismatchError => Intl.message('Password Mismatch');

  String get newPasswordFieldHint => Intl.message('New Password');

  String get confirmPasswordFieldHint => Intl.message('Confirm New Password');

  String get typeOldPasswordError =>
      Intl.message('Type old password for safity measurement');

  String get currentPassword => Intl.message("Current Password");

  String get updatePersonalInformation =>
      Intl.message('Update Personal Information');

  String get selectGenderFirst => Intl.message('Select gender first');

  String get noDataFoundAtThisMoment =>
      Intl.message('No Data found at the moment.');

  String get myAds => Intl.message('My Ads');

  String get favoriteAds => Intl.message('Favorite Ads');

  String get selectBrand => Intl.message('Select brand');

  String get attributes => Intl.message('Attributes');

  String get failedToPostComment => Intl.message('Failed to post comment');

  String get writeComment => Intl.message('Write a you comment here');

  String get postButton => Intl.message('POST');

  String get reportButton => Intl.message('Report');

  String get saveButton => Intl.message('Save');

  String get shareButton => Intl.message('Share');

  String get phoneNumberNotAvaliable =>
      Intl.message('Phone number is not avaiable for This Ad');

  String get locationNotAvaliable =>
      Intl.message('Location for this Ad is not avaliable');

  String get viewLocationButton => Intl.message('View Location');

  String get noCommentFound => Intl.message('Failed to post comment');

  String copyRights(int date) =>
      Intl.message('Copyright © $date, All Rights resereved',
          args: [date], name: 'copyRights');

  String discountPercentage(int discount) => Intl.message('$discount% OFF',
      args: [discount], name: "discountPercentage");

  String get featuredCategories => Intl.message('Featured Categories');

  String get retryButton => Intl.message('Retry');

  String get failedToLoadData => Intl.message('Failed to load Data');

  String get seeMoreButton => Intl.message('See more');
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
