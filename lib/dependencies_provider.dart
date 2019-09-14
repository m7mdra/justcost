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
import 'data/rate/rate_repository.dart';

GetIt getIt = GetIt();

class DependenciesProvider {
  DependenciesProvider._();

  static void build() {
    final Dio client = Dio();
    final UserSession userSession = UserSession();
    final String _baseUrl = "http://skilledtechuae-001-site3.htempurl.com/api/";
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
    getIt.registerFactory<UserRepository>(() => UserRepository(client));
    getIt.registerFactory<RateRepository>(() => RateRepository(client));

    getIt.registerFactory<CategoryRepository>(() => CategoryRepository(client));
    getIt.registerFactory<ProductRepository>(() => ProductRepository(client));
    getIt.registerFactory<HomeRepository>(() => HomeRepository(client));
    getIt.registerFactory<CityRepository>(() => CityRepository(client));
    getIt.registerFactory<CommentRepository>(() => CommentRepository(client));
    getIt.registerFactory<BrandRepository>(() => BrandRepository(client));
    getIt.registerFactory<AttributeRepository>(
        () => AttributeRepository(client));
    getIt.registerFactory<AdRepository>(() => AdRepository(client));
    var bloc = SettingBloc(userSession);
    getIt.registerSingleton<SettingBloc>((bloc));
  }

  static T provide<T>() {
    return getIt.get<T>();
  }
}
