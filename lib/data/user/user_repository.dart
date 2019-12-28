import 'dart:io';

import 'package:dio/dio.dart';
import 'package:justcost/data/exception/exceptions.dart';
import 'package:justcost/data/user/model/auth_response.dart';
import 'package:justcost/data/user/model/base_response.dart';
import 'package:justcost/data/user/model/user_update_response.dart';
import 'package:justcost/data/user/model/user.dart';

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
      print(response.data);
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
      if (error.response.statusCode == UNAUTHORIZED_CODE)
        throw SessionExpired();
      else
        throw error;
    } catch (error) {
      print(error);

      throw error;
    }
  }

  Future<AuthenticationResponse> parse() async {
    try {
      var response = await _client.get('customer/user-by-token');
      var payLoad = AuthenticationResponse.fromJson(response.data);
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

  Future<AuthenticationResponse> submitActivationCode(String code) async {
    try {
      var response = await _client
          .post('customer/verificationcode', data: {"verificationCode": code});
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

  Future<ResponseStatus> resetPhoneRequest(String phone) async {
    try {
      var response =
          await _client.post('password_resets', data: {"accountKey": phone});
      print('RESET PHONE NUMBER  : ${response.data}');
      return ResponseStatus.fromJson(response.data);
    } on DioError catch (error) {
      throw error;
    } catch (error) {
      throw error;
    }
  }

  Future<dynamic> sendCodeRequest(String code,String mobile) async {
    try {
      var response =
      await _client.post('password_resets_cheack',
          data: {
            'activation_code': code,
            'mobile' : mobile
          });
      print('RESET PHONE NUMBER CODE  : ${response.data}');
      return response.data;
    } on DioError catch (error) {
      throw error;
    } catch (error) {
      throw error;
    }
  }

  Future<ResponseStatus> sendNewPasswordRequest(String password,String token) async {
    try {
      var response =
      await _client.post('resets',
          data: {
        'password': password,
        'token': token,

      });
      print('RESET PHONE NUMBER CODE  : ${response.data}');
      return ResponseStatus.fromJson(response.data);
    } on DioError catch (error) {
      throw error;
    } catch (error) {
      throw error;
    }
  }


  Future<dynamic> resetEmailRequest(String email) async {
    try {
      var response =
      await _client.post('password_resets',
          data:
          {
            "accountKey": email,
            "FromWeb" : 1
          });
      return response.data;
    } on DioError catch (error) {
      throw error;
    } catch (error) {
      throw error;
    }
  }

  Future<AuthenticationResponse> updateProfileImage(
      File originalFile, File downSampledFile) async {
    try {
      final fileName = "image_${DateTime
          .now()
          .millisecondsSinceEpoch}";
      print("");
      print("");
      print(fileName);
      print(downSampledFile.path);
      print("");
      print("");
      var response = await _client.post('customer/uploadImage',
          data: FormData.from({
            "image": UploadFileInfo(
                downSampledFile, downSampledFile.path),
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
      fullName, gender, city) async {
    try {
      var response = await _client.post('customer/setPersonal',
          data: {"name": fullName, "gender": gender, "city": city});
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
      var response = await _client.post('customer/setProfile',
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

  Future<dynamic> loadNotificationState(String firebaseToken) async {
    try {
      var response = await _client.post('check_firebase_tokens',
          data: {
            "firebaseToken": firebaseToken
          });
      return response.data;
    } on DioError catch (error) {
      if (error.response.statusCode == UNAUTHORIZED_CODE)
        throw SessionExpired();
      else
        throw error;
    } catch (error) {
      print(error);

      throw error;
    }
  }

  Future<dynamic> registerFirebaseToken(String firebaseToken) async {
    try {
      var response = await _client.post('firebase_tokens',
          data: {
            "firebaseToken": firebaseToken
          });
      return response.data;
    } on DioError catch (error) {
      if (error.response.statusCode == UNAUTHORIZED_CODE)
        throw SessionExpired();
      else
        throw error;
    } catch (error) {
      print(error);

      throw error;
    }
  }

  Future<dynamic> removeFirebaseToken(String firebaseToken) async {
    try {
      var response = await _client.post('remove_firebase_tokens',
          data: {
            "firebaseToken": firebaseToken
          });
      return response.data;
    } on DioError catch (error) {
      if (error.response.statusCode == UNAUTHORIZED_CODE)
        throw SessionExpired();
      else
        throw error;
    } catch (error) {
      print(error);

      throw error;
    }
  }
}
