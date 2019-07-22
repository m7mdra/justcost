import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:justcost/data/product/model/product.dart';
import 'package:justcost/data/product/product_repository.dart';

abstract class CategoryProductsEvent extends Equatable {}

abstract class CategoryProductsState {}

class LoadingState extends CategoryProductsState {}

class EmptyState extends CategoryProductsState {}

class NetworkErrorState extends CategoryProductsState {}

class ErrorState extends CategoryProductsState {}

class IdleState extends CategoryProductsState {}

class CategoryProductsLoaded extends CategoryProductsState {
  final List<Product> products;
  final bool hasReachedMax;

  CategoryProductsLoaded(this.products, this.hasReachedMax);
}

class LoadDataEvent extends CategoryProductsEvent {
  final String category;
  final List<int> attributes;
  final List<int> brands;
  final String keyword;

  LoadDataEvent(this.category, this.attributes, this.keyword, this.brands);
}

class LoadNextPage extends CategoryProductsEvent {
  final String category;
  final List<int> attributes;
  final List<int> brands;
  final String keyword;

  LoadNextPage(this.category, this.attributes, this.brands, this.keyword);
}

class RetryEvent extends CategoryProductsEvent {
  final int categoryId;

  RetryEvent(this.categoryId);
}

class CategoryProductsBloc
    extends Bloc<CategoryProductsEvent, CategoryProductsState> {
  final ProductRepository repository;
  int _currentPage = 0;
  bool lasPage = false;

  CategoryProductsBloc(this.repository);

  @override
  CategoryProductsState get initialState => LoadingState();

  @override
  Stream<CategoryProductsState> mapEventToState(
      CategoryProductsEvent event) async* {
    if (event is LoadDataEvent) {
      yield LoadingState();
      try {
        int _currentPage = 0;
        var response = await repository.getProductsFromCategory(
            event.category, _currentPage,
            keyword: event.keyword,
            attributes: event.attributes,
            brands: event.brands);
        if (response.success) {
          if (response.data != null && response.data.isNotEmpty)
            yield CategoryProductsLoaded(response.data, false);
          else
            yield EmptyState();
        } else {
          yield ErrorState();
        }
      } on DioError catch (error) {
        print(error);

        yield NetworkErrorState();
      } catch (error) {
        yield ErrorState();
        print(error);
      }
    }
    if (event is LoadNextPage) {
      try {
        if (lasPage) return;
        _currentPage += 1;
        var response = await repository.getProductsFromCategory(
            event.category, _currentPage,
            keyword: event.keyword,
            attributes: event.attributes,
            brands: event.brands);
        if (response.success) {
          lasPage = response.data.isEmpty;
          yield CategoryProductsLoaded(
              (currentState as CategoryProductsLoaded).products
                ..addAll(response.data),
              response.data.isEmpty);
        } else
          yield ErrorState();
      } on DioError catch (e) {
        print('error $e');
        yield NetworkErrorState();
      } catch (e) {
        print('error $e');
        yield ErrorState();
      }
    }
  }
}
