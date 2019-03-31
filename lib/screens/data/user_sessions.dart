import 'package:justcost/screens/data/user/model/auth_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSession {
  Future<void> save(AuthenticationResponse response) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("token", response.content.token);
    sharedPreferences.setString("userId", response.content.payload.uid);
    sharedPreferences.setString("username", response.content.payload.username);
    sharedPreferences.setString("email", response.content.payload.email);
    sharedPreferences.setString("fullName", response.content.payload.fullName);
    sharedPreferences.setString("gender", response.content.payload.gender);
    sharedPreferences.setString(
        "msgTokenId", response.content.payload.msgTokenId);
    sharedPreferences.setString("avatar", response.content.payload.photo);
    sharedPreferences.setInt("msgTokenId", response.content.payload.expiration);
    sharedPreferences.setInt(
        "accountStatus", response.content.payload.accountStatus);
    sharedPreferences.setInt("notBefore", response.content.payload.notBefore);
    sharedPreferences.setInt("expiration", response.content.payload.expiration);
  }

  Future<bool> hasToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = await sharedPreferences.getString("token");
    return token != null && token.isNotEmpty;
  }

  Future<String> token() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString("token");
  }

  Future<String> userId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString("userId");
  }

  Future<String> username() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString("username");
  }

  Future<String> fullName() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString("fullName");
  }

  Future<String> avatar() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString("avatar");
  }

  Future<String> gender() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString("gender");
  }

  Future<bool> clear() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.clear();
  }
}
