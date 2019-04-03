import 'dart:io';

import 'package:dio/dio.dart';
import 'package:justcost/data/user/model/auth_response.dart';
import 'package:justcost/data/user/model/base_response.dart';

class UserRepository {
  final Dio client;

  UserRepository(this.client);

  Future<AuthenticationResponse> createAccount(
      String username,
      String email,
      String password,
      String confirmPassword,
      String messagingId,
      String address,
      File file,
      String phoneNumber) async {
    try {
      var response = await client.put('jc-member/signup', data: {
        "username": username,
        "email": email,
        "password": password,
        "cnf-password": password,
        "msg_id": messagingId,
        "address": address,
//        "file": UploadFileInfo(file, "avatar.png")
      });
      var authResponse = AuthenticationResponse.fromJson(response.data);
      return authResponse;
    } on DioError catch (error) {
      throw error;
    }
  }

  Future<AuthenticationResponse> login(
      String identifier, String password, String messagingId) async {
    try {
      var response = await client.post('jc-member/login', data: {
        "identifier": identifier,
        "password": password,
        "msg_id": messagingId
      });
      var authResponse = AuthenticationResponse.fromJson(response.data);
      return authResponse;
    } on DioError catch (error) {
      throw error;
    }
  }

  Future<AuthenticationResponse> parse() async {
    try {
      var response = await client.get('jc-member/parse');
      var authResponse = AuthenticationResponse.fromJson(response.data);
      return authResponse;
    } on DioError catch (error) {
      throw error;
    }
  }

  Future<ResponseStatus> resendVerificationEmail() async {
    try {
      var response = await client.get('jc-member/activation/send');
      return ResponseStatus.fromJson(response.data);
    } on DioError catch (error) {
      throw error;
    }
  }
}
