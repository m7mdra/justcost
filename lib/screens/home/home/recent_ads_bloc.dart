import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:justcost/data/product/model/product.dart';
import 'package:justcost/data/product/product_repository.dart';

abstract class RecentAdsEvent {}

class LoadRecentAds extends RecentAdsEvent {}

class RecentAdsLoaded extends RecentAdsState {
  final List<Product> products;
  final bool hasReachedMax;

  RecentAdsLoaded(this.products, this.hasReachedMax);

  RecentAdsLoaded copyWith({
    List<Product> products,
    bool hasReachedMax,
  }) {
    return RecentAdsLoaded(
      products ?? this.products,
      hasReachedMax ?? this.hasReachedMax,
    );
  }
}

class RecentAdsError extends RecentAdsState {}

class RecentAdsLoading extends RecentAdsState {}

class RecentAdsNetworkError extends RecentAdsState {}

class RecentAdsIdle extends RecentAdsState {}

class LoadNextPage extends RecentAdsEvent {}

abstract class RecentAdsState {}

class RecentAdsBloc extends Bloc<RecentAdsEvent, RecentAdsState> {
  final ProductRepository repository;
  int _currentPage = 0;
  bool lasPage = false;

  RecentAdsBloc(this.repository);

  @override
  RecentAdsState get initialState => RecentAdsIdle();

  @override
  Stream<RecentAdsState> mapEventToState(RecentAdsEvent event) async* {
    if (event is LoadRecentAds) {
      try {
        yield RecentAdsLoading();
        var response = await repository.getProducts(page: _currentPage);
        if (response.success){
          yield RecentAdsLoaded(response.data, true);
          print(response.data);
        }
        else
          yield RecentAdsError();
      } on DioError catch (e) {
        print('error $e');
        yield RecentAdsNetworkError();
      } catch (e) {
        print('error $e');
        yield RecentAdsError();
      }
    }
    if (event is LoadNextPage) {
      try {
        if (lasPage) return;
        _currentPage += 1;
        var response = await repository.getProducts(page: _currentPage);
        if (response.success) {
          lasPage = response.data.isEmpty;
          yield RecentAdsLoaded(
              (currentState as RecentAdsLoaded).products..addAll(response.data),
              response.data.isEmpty);
        } else
          yield RecentAdsError();
      } on DioError catch (e) {
        print('error $e');
        yield RecentAdsNetworkError();
      } catch (e) {
        print('error $e');
        yield RecentAdsError();
      }
    }
  }
}
