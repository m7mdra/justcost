import 'package:dio/dio.dart';

class Http {
  static String baseUrl = "http://jc-api.skilledtech.ae/";
  static Dio CLIENT = Dio()
    ..options = BaseOptions(
        baseUrl: baseUrl)
    ..interceptors.add(LogInterceptor(
        request: true,
        responseBody: true,
        requestHeader: true,
        error: true,
        requestBody: true,
        responseHeader: true));
}
