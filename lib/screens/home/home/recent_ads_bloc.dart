import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:justcost/data/product/model/product.dart';
import 'package:justcost/data/product/product_repository.dart';

abstract class RecentAdsEvent {}

class LoadRecentAds extends RecentAdsEvent {}

class RecentAdsLoaded extends RecentAdsState {
  final List<Product> products;

  RecentAdsLoaded(this.products);
}

class LikeToggledForProductWithId extends RecentAdsEvent {
  final int id;

  LikeToggledForProductWithId(this.id);
}

class RecentAdsError extends RecentAdsState {}

class RecentAdsIdle extends RecentAdsState {}

abstract class RecentAdsState {}

class RecentAdsBloc extends Bloc<RecentAdsEvent, RecentAdsState> {
  final ProductRepository repository;

  RecentAdsBloc(this.repository);

  @override
  RecentAdsState get initialState => RecentAdsIdle();

  @override
  Stream<RecentAdsState> mapEventToState(RecentAdsEvent event) async* {
    if (event is LoadRecentAds) {
      try {
        var response = await repository.getProducts();
        if (response.success)
          yield RecentAdsLoaded(response.data);
        else
          yield RecentAdsError();
      } on DioError catch (e) {
        print('error $e');
        yield RecentAdsError();
      } catch (e) {
        print('error $e');
        yield RecentAdsError();
      }
    }

  }
}
