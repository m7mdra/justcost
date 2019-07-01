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

class SortByRateDescending extends SearchEvent {}

class SortByRateAscending extends SearchEvent {}

abstract class SearchState {}

class SearchLoading extends SearchState {}

class SearchError extends SearchState {}

class SearchNetworkError extends SearchState {}

class SearchNoResult extends SearchState {}

class SearchFound extends SearchState {
  final List<Product> products;

  SearchFound(this.products);
}

class SearchIdle extends SearchState {}

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final ProductRepository _repository;

  SearchBloc(this._repository);

  @override
  SearchState get initialState => SearchIdle();

  @override
  Stream<SearchEvent> transform(Stream<SearchEvent> events) {
    return super.transform((events as Observable<SearchEvent>).debounce(
      Duration(milliseconds: 500),
    ));
  }

  @override
  void onTransition(Transition<SearchEvent, SearchState> transition) {
    super.onTransition(transition);
    print(transition);
  }

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    if (event is SearchProductByName) {
      yield SearchLoading();
      try {
        var response =
            await _repository.findProductsByName(event.name, event.cityId);
        if (response.success) {
          if (response.data.isEmpty)
            yield SearchNoResult();
          else {
            yield SearchFound(response.data);
          }
        } else {
          yield SearchError();
        }
      } on DioError {
        yield SearchNetworkError();
      } catch (error) {
        yield SearchError();
      }
    }
    if (event is SortByRateAscending) {}
    if (event is SortByRateDescending) {}
    if (event is SortByDiscountDescending) {
      if (currentState is SearchFound) {
        var products = (currentState as SearchFound).products;
        products.sort((p1, p2) =>
            p2.calculateDiscount().compareTo(p1.calculateDiscount()));

        yield SearchFound(products);
      }
    }
    if (event is SortByDiscountAscending) {
      if (currentState is SearchFound) {
        var products = (currentState as SearchFound).products;
        products.sort((p1, p2) =>
            p1.calculateDiscount().compareTo(p2.calculateDiscount()));

        yield SearchFound(products);
      }
    }
    if (event is SortByNameAscending) {
      if (currentState is SearchFound) {
        var products = (currentState as SearchFound).products;
        products.sort((p1, p2) => p1.title.compareTo(p2.title));

        yield SearchFound(products);
      }
    }
    if (event is SortByNameDescending) {
      if (currentState is SearchFound) {
        var products = (currentState as SearchFound).products;
        products.sort((p1, p2) => p2.title.compareTo(p1.title));

        yield SearchFound(products);
      }
    }
    if (event is SortByPriceAscending) {
      if (currentState is SearchFound) {
        var products = (currentState as SearchFound).products;
        products.sort((p1, p2) => p1.salePrice.compareTo(p2.salePrice));

        yield SearchFound(products);
      }
    }
    if (event is SortByPriceDescending) {
      if (currentState is SearchFound) {
        var products = (currentState as SearchFound).products;
        products.sort((p1, p2) => p2.salePrice.compareTo(p1.salePrice));

        yield SearchFound(products);
      }
    }
  }
}
