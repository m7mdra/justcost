import 'package:justcost/data/user/model/auth_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

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

class UserSession {
  Future<void> save(AuthenticationResponse response) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(
        USER_RESPONSE_KEY, jsonEncode(response.toJson()));
    sharedPreferences.setString(TOKEN_KEY, response.content.token);
    sharedPreferences.setString(USER_TYPE_KEY, "member");
    sharedPreferences.setString(USER_ID_KEY, response.content.payload.uid);
    sharedPreferences.setString(
        USERNAME_KEY, response.content.payload.username);
    sharedPreferences.setString(EMAIL_KEY, response.content.payload.email);
    sharedPreferences.setString(
        FULL_NAME_KEY, response.content.payload.fullName);
    sharedPreferences.setString(GENDER_KEY, response.content.payload.gender);
    sharedPreferences.setString(
        MESSAGING_TOKEN_ID_KEY, response.content.payload.msgTokenId);
    sharedPreferences.setString(AVATAR_URL_KEY, response.content.payload.photo);
    sharedPreferences.setInt(
        EXPIRATION_KEY, response.content.payload.expiration);
    sharedPreferences.setInt(
        ACCOUNT_STATUS_KEY, response.content.payload.accountStatus);
    sharedPreferences.setInt(
        NOT_BEFORE_KEY, response.content.payload.notBefore);
  }

  Future<void> saveUser(Payload payload) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(USER_ID_KEY, payload.uid);
    sharedPreferences.setString(USERNAME_KEY, payload.username);
    sharedPreferences.setString(EMAIL_KEY, payload.email);
    sharedPreferences.setString(FULL_NAME_KEY, payload.fullName);
    sharedPreferences.setString(GENDER_KEY, payload.gender);
    sharedPreferences.setString(MESSAGING_TOKEN_ID_KEY, payload.msgTokenId);
    sharedPreferences.setString(AVATAR_URL_KEY, payload.photo);
    sharedPreferences.setInt(EXPIRATION_KEY, payload.expiration);
    sharedPreferences.setInt(ACCOUNT_STATUS_KEY, payload.accountStatus);
    sharedPreferences.setInt(NOT_BEFORE_KEY, payload.notBefore);
  }

  Future<bool> guestLogin() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.setString(USER_TYPE_KEY, "guest");
  }

  Future<bool> isUserAGoat() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.getString(USER_TYPE_KEY) == "guest";
  }

  Future<bool> hasToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = await sharedPreferences.getString(TOKEN_KEY);
    return token != null && token.isNotEmpty;
  }

  Future<bool> isAccountVerified() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.getInt(ACCOUNT_STATUS_KEY) == 1;
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
