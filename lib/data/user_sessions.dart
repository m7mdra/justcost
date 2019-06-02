import 'dart:convert';

import 'package:justcost/data/user/model/auth_response.dart';
import 'package:justcost/data/user/model/user.dart';
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
const ADDRESS_KEY = 'address';
const CITY_OBJECT_KEY = 'city_obj';

class UserSession {
  Future<void> save(AuthenticationResponse response) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(
        USER_RESPONSE_KEY, jsonEncode(response.toJson()));
    sharedPreferences.setString(TOKEN_KEY, response.data.token);
    sharedPreferences.setString(USER_TYPE_KEY, "member");
    sharedPreferences.setString(AVATAR_URL_KEY, response.data.user.image);
    sharedPreferences.setInt(USER_ID_KEY, response.data.user.id);
    sharedPreferences.setString(USERNAME_KEY, response.data.user.username);
    sharedPreferences.setString(EMAIL_KEY, response.data.user.email);
    sharedPreferences.setString(FULL_NAME_KEY, response.data.user.name);
    sharedPreferences.setInt(GENDER_KEY, response.data.user.gender);
    sharedPreferences.setString(
        CITY_OBJECT_KEY, jsonEncode(response.data.user.cities.toJson()));
    sharedPreferences.setString(
        MESSAGING_TOKEN_ID_KEY, response.data.user.firebaseToken);

    sharedPreferences.setBool(
        ACCOUNT_STATUS_KEY, response.data.user.isVerified);

    sharedPreferences.setInt(ADDRESS_KEY, response.data.user.city);
  }

  Future saveUser(User user) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setInt(USER_ID_KEY, user.id);
    if (user.cities != null)
      sharedPreferences.setString(
          CITY_OBJECT_KEY, jsonEncode(user.cities.toJson()));
    sharedPreferences.setString(USERNAME_KEY, user.username);
    sharedPreferences.setString(EMAIL_KEY, user.email);
    sharedPreferences.setString(FULL_NAME_KEY, user.name);
    sharedPreferences.setInt(GENDER_KEY, user.gender);
    sharedPreferences.setString(MESSAGING_TOKEN_ID_KEY, user.firebaseToken);
    sharedPreferences.setString(AVATAR_URL_KEY, user.image);
    sharedPreferences.setInt(ADDRESS_KEY, user.city);
    sharedPreferences.setBool(ACCOUNT_STATUS_KEY, user.isVerified);
  }

  Future<bool> guestLogin() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.setString(USER_TYPE_KEY, "guest");
  }

  Future<bool> isUserAGoat() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(USER_TYPE_KEY) == "guest";
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

    return AuthenticationResponse.fromJson(
        jsonDecode(sharedPreferences.getString(USER_RESPONSE_KEY)));
  }

  Future<String> token() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(TOKEN_KEY);
  }

  Future<String> userId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(USER_ID_KEY);
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
    return sharedPreferences.clear();
  }
}
