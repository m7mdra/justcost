import 'package:dio/dio.dart';

class AcceptInterceptor extends Interceptor {
  @override
  onRequest(RequestOptions options) async {
    options.headers..['Accept'] = 'application/json';
    return await options;
  }
}
