import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:justcost/data/product/model/product.dart';
import 'package:justcost/data/product/product_repository.dart';
import 'package:rxdart/rxdart.dart';

abstract class SearchEvent {}

class SearchProductByName extends SearchEvent {
  final String name;

  SearchProductByName(this.name);
}

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
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    if (event is SearchProductByName) {
      yield SearchLoading();
      try {
        var response = await _repository.findProductsByName(event.name);
        if (response.success) {
          if (response.data.isEmpty)
            yield SearchNoResult();
          else
            yield SearchFound(response.data);
        } else {
          yield SearchError();
        }
      } on DioError {
        yield SearchNetworkError();
      } catch (error) {
        yield SearchError();
      }
    }
  }
}
