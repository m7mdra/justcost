import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:justcost/data/token_interceptor.dart';
import 'package:justcost/data/user/user_repository.dart';
import 'package:justcost/data/user_sessions.dart';

GetIt getIt = GetIt();

class DependenciesProvide {
  static void build() {
    final Dio client = Dio();
    final UserSession userSession = UserSession();
    final String _baseUrl = "http://192.168.8.100:330/api/";
    client.options = BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: 10000,
      receiveTimeout: 10000,
      responseType: ResponseType.json,
    );
    client.interceptors.add(LogInterceptor(
        request: true,
        responseBody: true,
        requestHeader: true,
        error: true,
        requestBody: true,
        responseHeader: true));
    client.interceptors.add(TokenInterceptor(userSession));

    getIt.registerSingleton<UserSession>(userSession);
    getIt.registerSingleton<Dio>(client);
    getIt.registerFactory(() {
      return UserRepository(client);
    });
  }

  static T provide<T>() {
    return getIt.get<T>();
  }
}
