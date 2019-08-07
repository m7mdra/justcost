import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:justcost/data/accept_interceptor.dart';
import 'package:justcost/data/ad/ad_repository.dart';
import 'package:justcost/data/attribute/attribute_repository.dart';
import 'package:justcost/data/category/category_repository.dart';
import 'package:justcost/data/city/city_repository.dart';
import 'package:justcost/data/comment/comment_repository.dart';
import 'package:justcost/data/home/home_repository.dart';
import 'package:justcost/data/product/product_repository.dart';
import 'package:justcost/data/token_interceptor.dart';
import 'package:justcost/data/user/user_repository.dart';
import 'package:justcost/data/user_sessions.dart';
import 'package:justcost/screens/settings/setting_bloc.dart';

import 'data/brand/brand_repository.dart';

GetIt getIt = GetIt();

class DependenciesProvider {
  DependenciesProvider._();

  static void build() {
    final Dio client = Dio();
    final UserSession userSession = UserSession();
    final String _baseUrl = "http://192.168.1.76:8000/api/";
    client.options = BaseOptions(
      baseUrl: _baseUrl,
      responseType: ResponseType.json,
    );
    client.interceptors.add(LogInterceptor(
      request: true,
      responseBody: true,
      requestHeader: true,
      error: true,
      requestBody: true,
      responseHeader: true,
    ));
    client.interceptors.add(TokenInterceptor(userSession));
    client.interceptors.add(AcceptInterceptor());

    getIt.registerSingleton<UserSession>(userSession);
    getIt.registerSingleton<Dio>(client);
    getIt.registerFactory<UserRepository>(() {
      return UserRepository(client);
    });

    getIt.registerFactory<CategoryRepository>(() {
      return CategoryRepository(client);
    });
    getIt.registerFactory<ProductRepository>(() {
      return ProductRepository(client);
    });
    getIt.registerFactory<HomeRepository>(() {
      return HomeRepository(client);
    });
    getIt.registerFactory<CityRepository>(() {
      return CityRepository(client);
    });
    getIt.registerFactory<CommentRepository>(() {
      return CommentRepository(client);
    });
    getIt.registerFactory<BrandRepository>(() {
      return BrandRepository(client);
    });
    getIt.registerFactory<AttributeRepository>(() {
      return AttributeRepository(client);
    });
    getIt.registerFactory<AdRepository>(() {
      return AdRepository(client);
    });
  var bloc= SettingBloc(userSession);
    getIt.registerSingleton<SettingBloc>((bloc));
  }

  static T provide<T>() {
    return getIt.get<T>();
  }
}
