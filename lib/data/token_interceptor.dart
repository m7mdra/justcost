import 'package:dio/dio.dart';
import 'package:justcost/data/user_sessions.dart';

class TokenInterceptor extends Interceptor {
  final UserSession userSession;

  TokenInterceptor(this.userSession);

  @override
  onRequest(RequestOptions options) async {
    if (await userSession.hasToken()) {
      var token = await userSession.token();
      if (token != null && token.isNotEmpty)
        options.headers['authorization'] = 'Bearer $token';
    } else
      print("token not found,ignored.");
    return options;
  }
}
