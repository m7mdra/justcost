import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:justcost/data/city/model/country.dart';
import 'package:justcost/data/user/model/auth_response.dart';
import 'package:justcost/data/user/model/user.dart';
import 'package:justcost/screens/postad/ad.dart';
import 'package:shared_preferences/shared_preferences.dart';

const USER_RESPONSE_KEY = "data";
const TOKEN_KEY = "token";
const USER_ID_KEY = "userId";
const USERNAME_KEY = "username";
const EMAIL_KEY = "email";
const FULL_NAME_KEY = "fullName";
const GENDER_KEY = "gender";
const MESSAGING_TOKEN_ID_KEY = "msgTokenId";
const AVATAR_URL_KEY = "avatar";
const EXPIRATION_KEY = "expiration";
const ACCOUNT_STATUS_KEY = "accountStatus";
const NOT_BEFORE_KEY = "notBefore";
const USER_TYPE_KEY = "userType";
const CITY_KEY = 'city_obj';
const MOBILE_NUMBER_KEY = "mobile_number";
const FIRST_TIME_LAUNCH_KEY = "firstTimeLaunch";
const COUNTRY_KEY = "country";
const LANGUAGE_KEY = "lang";

class UserSession {
  Future<void> save(AuthenticationResponse response) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(
        USER_RESPONSE_KEY, jsonEncode(response.toJson()));
    print("Success");
    print(response);
    var user = response.data.user;
    print("Success1");
    print(user);
    sharedPreferences.setString(MOBILE_NUMBER_KEY, user.mobile);
    sharedPreferences.setString(TOKEN_KEY, response.data.token);
    sharedPreferences.setString(USER_TYPE_KEY, "member");
//    sharedPreferences.setString(AVATAR_URL_KEY, user.image);
    sharedPreferences.setInt(USER_ID_KEY, user.id);
    sharedPreferences.setString(USERNAME_KEY, user.username);
    sharedPreferences.setString(EMAIL_KEY, user.email);
    sharedPreferences.setString(FULL_NAME_KEY, user.name);
    sharedPreferences.setInt(GENDER_KEY, user.gender);
    sharedPreferences.setString(CITY_KEY, jsonEncode(user.city.toJson()));
    sharedPreferences.setString(
        MESSAGING_TOKEN_ID_KEY, response.data.user.firebaseToken);
    sharedPreferences.setString(COUNTRY_KEY, jsonEncode(user.country.toJson()));

    sharedPreferences.setBool(
        ACCOUNT_STATUS_KEY, response.data.user.isVerified);
    await refresh();
  }
  Future<void> saveAvater(AuthenticationResponse response) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(
        USER_RESPONSE_KEY, jsonEncode(response.toJson()));
    print("Success");
    print(response);
    var user = response.data.user;
    print("Success1");
    print(user);
    sharedPreferences.setString(AVATAR_URL_KEY, user.image);
    await refresh();
  }

  Future<bool> saveLanguage(String code) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.setString(LANGUAGE_KEY, code);
  }

  Future<String> getCurrentLanguage() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(LANGUAGE_KEY) ?? "ar";
  }

  Future<void> refresh() async {
    /* SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.reload();*/
  }

  Future saveUser(User user) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(MOBILE_NUMBER_KEY, user.mobile);
    sharedPreferences.setString(USER_TYPE_KEY, "member");
    sharedPreferences.setString(AVATAR_URL_KEY, user.image);
    sharedPreferences.setInt(USER_ID_KEY, user.id);
    sharedPreferences.setString(USERNAME_KEY, user.username);
    sharedPreferences.setString(EMAIL_KEY, user.email);
    sharedPreferences.setString(FULL_NAME_KEY, user.name);
    sharedPreferences.setInt(GENDER_KEY, user.gender);
    sharedPreferences.setString(CITY_KEY, jsonEncode(user.city.toJson()));
    sharedPreferences.setString(COUNTRY_KEY, jsonEncode(user.country.toJson()));
    await refresh();
  }

  Future<bool> guestLogin() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    return sharedPreferences.setString(USER_TYPE_KEY, "guest");
  }

  /// returns true if the current user is authenticated.
  /// returns false if the current user is guest or a goat for all we know
  Future<bool> isUserAGoat() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userType = sharedPreferences.getString(USER_TYPE_KEY);
    if (userType == null) return true;
    return userType == "guest";
  }

  Future<bool> hasToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.getString(TOKEN_KEY);

    return token != null && token.isNotEmpty;
  }

  Future<bool> isAccountVerified() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(ACCOUNT_STATUS_KEY);
  }

  Future<AuthenticationResponse> user() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var json = jsonDecode(sharedPreferences.getString(USER_RESPONSE_KEY));
    return AuthenticationResponse.fromJson(json);
  }

  Future<String> token() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(TOKEN_KEY);
  }

  Future<int> userId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    return sharedPreferences.getInt(USER_ID_KEY);
  }

  Future<String> username() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    return sharedPreferences.getString(USERNAME_KEY);
  }

  Future<String> fullName() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    return sharedPreferences.getString(FULL_NAME_KEY);
  }

  Future<String> avatar() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(AVATAR_URL_KEY);
  }

  Future<String> gender() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    return sharedPreferences.getString(GENDER_KEY);
  }

  Future<bool> clear() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.clear()
      ..then((clear) {
        print("Did clear sessions? $clear");
      });
  }

  Future<bool> isFirstTimeLaunch() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var firstTime = sharedPreferences.getBool(FIRST_TIME_LAUNCH_KEY);
    if (firstTime == null)
      return true;
    else
      return false;
  }

  setFirstTimeLaunched() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(FIRST_TIME_LAUNCH_KEY, false);
    await refresh();
  }
}
