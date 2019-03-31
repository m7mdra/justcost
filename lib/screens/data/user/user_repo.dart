import 'package:justcost/screens/data/user/model/auth_response.dart';
import 'package:dio/dio.dart';

class UserRepository {
  final Dio client;

  UserRepository(this.client);

  Future<AuthenticationResponse> createAccount(
      String username,
      String email,
      String password,
      String confirmPassword,
      String messagingId,
      String address) async {
    try {
      var response = await client.put('jc-member/signup', data: {
        "username": username,
        "email": email,
        "password": password,
        "cnf-password": password,
        "msg_id": messagingId,
        "address": address,

      });
      var authResponse = AuthenticationResponse.fromJson(response.data);
      return authResponse;
    } on DioError catch (error) {
      throw error;
    }
  }


//  Future<AuthenticationResponse> login(String identifier, String password) {}

}
