import 'dart:io';

import 'package:dio/dio.dart';
import 'package:justcost/data/user/model/auth_response.dart';
import 'package:justcost/data/user/model/base_response.dart';

class UserRepository {
  final Dio _client;

  UserRepository(this._client);

  Future<AuthenticationResponse> createAccount(
      String username,
      String email,
      String password,
      String confirmPassword,
      String messagingId,
      String address,
      String phoneNumber) async {
    try {
      var response = await _client.put('jc-member/signup', data: {
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
    } catch (error) {
      throw error;
    }
  }

  Future<AuthenticationResponse> login(
      String identifier, String password, String messagingId) async {
    try {
      var response = await _client.post('jc-member/login', data: {
        "identifier": identifier,
        "password": password,
        "msg_id": messagingId
      });
      var authResponse = AuthenticationResponse.fromJson(response.data);
      return authResponse;
    } on DioError catch (error) {
      throw error;
    } catch (error) {
      throw error;
    }
  }

  Future<Payload> parse() async {
    try {
      var response = await _client.get('jc-member/parse');
      var payLoad = Payload.fromJson(response.data);
      return payLoad;
    } on DioError catch (error) {
      throw error;
    } catch (error) {
      throw error;
    }
  }

  Future<ResponseStatus> resendVerificationEmail() async {
    try {
      var response = await _client.get('jc-member/activation/send');
      return ResponseStatus.fromJson(response.data);
    } on DioError catch (error) {
      throw error;
    } catch (error) {
      throw error;
    }
  }

  Future<AuthenticationResponse> submitActivationCode(String code) async {
    try {
      var response =
          await _client.post('jc-member/activate/account', data: {"code": code});
      return AuthenticationResponse.fromJson(response.data);
    } on DioError catch (error) {
      throw error;
    } catch (error) {
      throw error;
    }
  }

  Future<ResponseStatus> reset(String email) async {
    try {
      var response =
          await _client.post('jc-member/reset', data: {"email": email});
      return ResponseStatus.fromJson(response.data);
    } on DioError catch (error) {
      throw error;
    } catch (error) {
      throw error;
    }
  }
}
