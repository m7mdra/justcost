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

class LoadNextPage extends FeaturedAdsEvent {}

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
        var response = await repository.getFeaturedProducts(page: _currentPage);
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
  }
}
