import 'dart:io';

import 'package:dio/dio.dart';
import 'package:justcost/data/exception/exceptions.dart';
import 'package:justcost/data/user/model/auth_response.dart';
import 'package:justcost/data/user/model/base_response.dart';
import 'package:justcost/data/user/model/verification_response.dart';

const UNAUTHORIZED_CODE = 401;

class UserRepository {
  final Dio _client;

  UserRepository(this._client);

  Future<AuthenticationResponse> createAccount(
      String name,
      String username,
      String email,
      String password,
      String confirmPassword,
      String messagingId,
      String phoneNumber,
      int city) async {
    try {
      var response = await _client.post('customer/register', data: {
        "username": username,
        "name": name,
        "email": email,
        "password": password,
        "mobile": phoneNumber,
        'city': city,
        "c_password": password,
        "firebaseToken": messagingId,
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
      var response = await _client.post('customer/login', data: {
        "username": identifier,
        "password": password,
        "firebaseToken": messagingId
      });
      var authResponse = AuthenticationResponse.fromJson(response.data);
      return authResponse;
    } on DioError catch (error) {
      print(error);
      throw error;
    } catch (error) {
      print(error);

      throw error;
    }
  }

  Future<Payload> parse() async {
    try {
      var response = await _client.get('user-by-token');
      var payLoad = Payload.fromJson(response.data);
      return payLoad;
    } on DioError catch (error) {
      if (error.response.statusCode == UNAUTHORIZED_CODE)
        throw SessionExpired();
      else
        throw error;
    } catch (error) {
      throw error;
    }
  }

  Future<ResponseStatus> resendVerificationEmail() async {
    try {
      var response = await _client.post('customer/verificationresend');
      return ResponseStatus.fromJson(response.data);
    } on DioError catch (error) {
      if (error.response.statusCode == UNAUTHORIZED_CODE)
        throw SessionExpired();
      else
        throw error;
    } catch (error) {
      throw error;
    }
  }

  Future<VerificationResponse> submitActivationCode(String code) async {
    try {
      var response = await _client
          .post('customer/verificationcode', data: {"verificationCode": code});
      return VerificationResponse.fromJson(response.data);
    } on DioError catch (error) {
      if (error.response.statusCode == UNAUTHORIZED_CODE)
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
      File originalFile, File downSampledFile) async {
    try {
      var response = await _client.post('jc-member/mpi/update',
          data: FormData.from({
            "upload": UploadFileInfo(
                originalFile, "${DateTime.now()}_image_original"),
            "upload_2": UploadFileInfo(
                downSampledFile, "${DateTime.now()}_image_downsampled"),
          }));
      return AuthenticationResponse.fromJson(response.data);
    } on DioError catch (error) {
      if (error.response.statusCode == UNAUTHORIZED_CODE)
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
      var response = await _client.post('customer/password', data: {
        "now_password": oldPassword,
        "new_password": newPassword,
        "c_new_password": confirmNewPassword
      });
      return ResponseStatus.fromJson(response.data);
    } on DioError catch (error) {
      if (error.response.statusCode == UNAUTHORIZED_CODE)
        throw SessionExpired();
      else
        throw error;
    } catch (error) {
      throw error;
    }
  }

  Future<AuthenticationResponse> updatePersonalInformation(
      fullName, gender, address) async {
    try {
      var response = await _client.post('jc-member/update/profile',
          data: {"full_name": fullName, "gender": gender, "address": address});
      return AuthenticationResponse.fromJson(response.data);
    } on DioError catch (error) {
      if (error.response.statusCode == UNAUTHORIZED_CODE)
        throw SessionExpired();
      else
        throw error;
    } catch (error) {
      throw error;
    }
  }

  Future<AuthenticationResponse> updateAccountInformation(
      username, email, password) async {
    try {
      var response = await _client.post('jc-member/update/account',
          data: {"username": username, "email": email, "password": password});
      return AuthenticationResponse.fromJson(response.data);
    } on DioError catch (error) {
      if (error.response.statusCode == UNAUTHORIZED_CODE)
        throw SessionExpired();
      else
        throw error;
    } catch (error) {
      throw error;
    }
  }

  Future<ResponseStatus> logout() async {
    var response = await _client.post('customer/logout');
    return ResponseStatus.fromJson(response.data);
  }

  Future<ResponseStatus> updateMessagingId(String newToken) async {
    var response = await _client
        .post('jc-member/update/msg-token', data: {'msg_id': newToken});
    return ResponseStatus.fromJson(response.data);
  }
}
