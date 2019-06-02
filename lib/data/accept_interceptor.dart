import 'package:dio/dio.dart';

class AcceptInterceptor extends Interceptor {
  @override
  onRequest(RequestOptions options) {
    options.headers..['Accept'] = 'application/json';
    return options;
  }
}
