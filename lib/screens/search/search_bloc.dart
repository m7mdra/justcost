import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:justcost/data/product/model/product.dart';
import 'package:justcost/data/product/product_repository.dart';
import 'package:rxdart/rxdart.dart';

abstract class SearchEvent {}

class SearchProductByName extends SearchEvent {
  final String name;
  final int cityId;

  SearchProductByName(this.name, this.cityId);
}

class SortByNameAscending extends SearchEvent {}

class SortByDiscountAscending extends SearchEvent {}

class SortByDiscountDescending extends SearchEvent {}

class SortByNameDescending extends SearchEvent {}

class SortByPriceAscending extends SearchEvent {}

class SortByPriceDescending extends SearchEvent {}

abstract class SearchState {}

class SearchLoading extends SearchState {}

class SearchError extends SearchState {}

class SearchNetworkError extends SearchState {}

class SearchNoResult extends SearchState {}

class LoadNextPage extends SearchEvent {
  final String name;
  final int cityId;

  LoadNextPage(this.name, this.cityId);
}

class SearchFound extends SearchState {
  final List<Product> products;
  final bool hasReachedMax;

  SearchFound(this.products, this.hasReachedMax);
}

class SearchIdle extends SearchState {}

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final ProductRepository _repository;
  int _currentPage = 0;
  bool lasPage = false;

  SearchBloc(this._repository);

  @override
  SearchState get initialState => SearchIdle();

  @override
  Stream<SearchState> transform(Stream<SearchEvent> events,
      Stream<SearchState> Function(SearchEvent event) next) {
    return super.transform(
      (events as Observable<SearchEvent>).debounceTime(
        Duration(milliseconds: 500),
      ),
      next,
    );
  }

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    if (event is SearchProductByName) {
      yield SearchLoading();
      try {
        var response = await _repository.findProductsByName(
            event.name, event.cityId, _currentPage);
        if (response.success) {
          yield SearchFound(response.data, true);
        } else {
          yield SearchError();
        }
      } on DioError {
        yield SearchNetworkError();
      } catch (error) {
        yield SearchError();
      }
    }
    if (event is LoadNextPage) {
      try {
        if (lasPage) return;
        _currentPage += 1;
        var response = await _repository.findProductsByName(
            event.name, event.cityId, _currentPage);
        if (response.success) {
          lasPage = response.data.isEmpty;
          yield SearchFound(
              (currentState as SearchFound).products..addAll(response.data),
              response.data.isEmpty);
        } else {
          yield SearchError();
        }
      } on DioError {
        yield SearchNetworkError();
      } catch (error) {
        yield SearchError();
      }
    }

    if (event is SortByDiscountDescending) {
      if (currentState is SearchFound) {
        var products = (currentState as SearchFound).products;
        products.sort((p1, p2) =>
            p2.calculateDiscount().compareTo(p1.calculateDiscount()));

        yield SearchFound(products, products.isEmpty);
      }
    }
    if (event is SortByDiscountAscending) {
      if (currentState is SearchFound) {
        var products = (currentState as SearchFound).products;
        products.sort((p1, p2) =>
            p1.calculateDiscount().compareTo(p2.calculateDiscount()));

        yield SearchFound(products, products.isEmpty);
      }
    }
    if (event is SortByNameAscending) {
      if (currentState is SearchFound) {
        var products = (currentState as SearchFound).products;
        products.sort((p1, p2) => p1.title.compareTo(p2.title));

        yield SearchFound(products, products.isEmpty);
      }
    }
    if (event is SortByNameDescending) {
      if (currentState is SearchFound) {
        var products = (currentState as SearchFound).products;
        products.sort((p1, p2) => p2.title.compareTo(p1.title));

        yield SearchFound(products, products.isEmpty);
      }
    }
    if (event is SortByPriceAscending) {
      if (currentState is SearchFound) {
        var products = (currentState as SearchFound).products;
        products.sort((p1, p2) => p1.salePrice.compareTo(p2.salePrice));

        yield SearchFound(products, products.isEmpty);
      }
    }
    if (event is SortByPriceDescending) {
      if (currentState is SearchFound) {
        var products = (currentState as SearchFound).products;
        products.sort((p1, p2) => p2.salePrice.compareTo(p1.salePrice));

        yield SearchFound(products, products.isEmpty);
      }
    }
  }
}
