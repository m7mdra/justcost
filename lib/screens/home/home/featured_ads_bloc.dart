import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:justcost/data/product/model/product.dart';
import 'package:justcost/data/product/product_repository.dart';

abstract class FeaturedAdsEvent {}

class LoadFeaturedAds extends FeaturedAdsEvent {}

class FeaturedAdsLoaded extends FeaturedAdsState {
  final List<Product> products;
  final bool hasReachedMax;

  FeaturedAdsLoaded(this.products, this.hasReachedMax);

  FeaturedAdsLoaded copyWith({
    List<Product> products,
    bool hasReachedMax,
  }) {
    return FeaturedAdsLoaded(
      products ?? this.products,
      hasReachedMax ?? this.hasReachedMax,
    );
  }

}

class FeaturedAdsError extends FeaturedAdsState {}

class FeaturedAdsLoading extends FeaturedAdsState {}

class FeaturedAdsNetworkError extends FeaturedAdsState {}

class FeaturedAdsIdle extends FeaturedAdsState {}

class LoadFeaturedNextPage extends FeaturedAdsEvent {

}

abstract class FeaturedAdsState {}

class FeaturedAdsBloc extends Bloc<FeaturedAdsEvent, FeaturedAdsState> {
  final ProductRepository repository;
  int _currentPage = 0;
  bool lasPage = false;

  FeaturedAdsBloc(this.repository);

  @override
  FeaturedAdsState get initialState => FeaturedAdsIdle();

  @override
  Stream<FeaturedAdsState> mapEventToState(FeaturedAdsEvent event) async* {
    if (event is LoadFeaturedAds) {
      try {
        yield FeaturedAdsLoading();
        var response = await repository.getFeaturedProducts(skip: 0,limit: 15);
        if (response.success) {
          yield FeaturedAdsLoaded(response.data, true);
          print(response.data);
        }
        else
          yield FeaturedAdsError();
      } on DioError catch (e) {
        print('error $e');
        yield FeaturedAdsNetworkError();
      } catch (e) {
        print('error $e');
        yield FeaturedAdsError();
      }
    }
    if (event is LoadFeaturedNextPage) {
      try {
        if (lasPage) {
          print('end');
          return;
        }
        _currentPage += 1;
        var response = await repository.getFeaturedProducts(skip: (state as FeaturedAdsLoaded).products.length,limit: 15);
        if (response.success) {
          lasPage = response.data.isEmpty;
          yield FeaturedAdsLoaded(
              (state as FeaturedAdsLoaded).products..addAll(response.data),
              response.data.isEmpty);
        } else
          yield FeaturedAdsError();
      } on DioError catch (e) {
        print('error $e');
        yield FeaturedAdsNetworkError();
      } catch (e) {
        print('error $e');
        yield FeaturedAdsError();
      }
    }
  }
}
