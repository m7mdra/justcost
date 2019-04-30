import 'dart:io';

import 'package:dio/dio.dart';
import 'package:justcost/data/exception/exceptions.dart';
import 'package:justcost/data/user/model/auth_response.dart';
import 'package:justcost/data/user/model/base_response.dart';
import 'package:justcost/data/user/model/user_response.dart';
class UserRepository {
  final Dio _client;

  UserRepository(this._client);

  Future<AuthenticationResponse> createAccount(
      String username,
      String email,
      String password,
      String confirmPassword,
      String messagingId,
      String phoneNumber) async {
    try {
      var response = await _client.put('jc-member/signup', data: {
        "username": username,
        "email": email,
        "password": password,
        "cnf-password": password,
        "msg_id": messagingId,
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
      if (error.response.statusCode == 550)
        throw SessionExpired();
      else
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
      if (error.response.statusCode == 550)
        throw SessionExpired();
      else
        throw error;
    } catch (error) {
      throw error;
    }
  }

  Future<AuthenticationResponse> submitActivationCode(String code) async {
    try {
      var response = await _client
          .post('jc-member/activate/account', data: {"code": code});
      return AuthenticationResponse.fromJson(response.data);
    } on DioError catch (error) {
      if (error.response.statusCode == 550)
        throw SessionExpired();
      else
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

  Future<AuthenticationResponse> updateProfileImage(
      File originalFile, File downsampledFile) async {
    try {
      var response = await _client.post('jc-member/mpi/update',
          data: FormData.from({
            "upload": UploadFileInfo(
                originalFile, "${DateTime.now()}_image_original"),
            "upload_2": UploadFileInfo(
                downsampledFile, "${DateTime.now()}_image_downsampled"),
          }));
      return AuthenticationResponse.fromJson(response.data);
    } on DioError catch (error) {
      if (error.response.statusCode == 550)
        throw SessionExpired();
      else
        throw error;
    } catch (error) {
      throw error;
    }
  }

  Future<ResponseStatus> updatePassword(
      String newPassword, String confirmNewPassword, String oldPassword) async {
    try {
      var response = await _client.post('jc-member/update/password', data: {
        "old_password": oldPassword,
        "new_password": newPassword,
        "confirm_password": confirmNewPassword
      });
      return ResponseStatus.fromJson(response.data);
    } on DioError catch (error) {
      if (error.response.statusCode == 550)
        throw SessionExpired();
      else
        throw error;
    } catch (error) {
      throw error;
    }
  }

  Future<AuthenticationResponse> updatePersonalInformation(fullName, gender, address) async {
    try {
      var response = await _client.post('jc-member/update/profile',
          data: {"full_name": fullName, "gender": gender, "address": address});
      return AuthenticationResponse.fromJson(response.data);
    } on DioError catch (error) {
      if (error.response.statusCode == 550)
        throw SessionExpired();
      else
        throw error;
    } catch (error) {
      throw error;
    }
  }

  Future<AuthenticationResponse> updateAccountInformation(username, email, password) async {
    try {
      var response = await _client.post('jc-member/update/account',
          data: {"username": username, "email": email, "password": password});
      return AuthenticationResponse.fromJson(response.data);
    } on DioError catch (error) {
      if (error.response.statusCode == 550)
        throw SessionExpired();
      else
        throw error;
    } catch (error) {
      throw error;
    }
  }

  Future<ResponseStatus> logout() async {
    var response = await _client.get('jc-member/logout');
    return ResponseStatus.fromJson(response.data);
  }

  Future<ResponseStatus> updateMessagingId(String newToken) async {
    var response = await _client
        .post('jc-member/update/msg-token', data: {'msg_id': newToken});
    return ResponseStatus.fromJson(response.data);
  }
}
