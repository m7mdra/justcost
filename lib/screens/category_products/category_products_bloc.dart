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
  final int categoryId;
  final List<int> attributes;
  final List<int> brands;
  final String keyword;
  final List<Product> products;

  LoadDataEvent(this.categoryId, this.attributes, this.keyword, this.brands,{this.products});
}

class FilteredCategoryProductsLoaded extends CategoryProductsState {
  final List<Product> filterProducts;
  final bool hasReachedMax;

  FilteredCategoryProductsLoaded(this.filterProducts, this.hasReachedMax);
}

class FilteredDataEvent extends CategoryProductsEvent {
  final int categoryId;
  final List<int> attributes;
  final List<int> brands;
  final String keyword;
  final List<Product> products;

  FilteredDataEvent(this.categoryId, this.attributes, this.keyword, this.brands,{this.products});
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
    if (event is FilteredDataEvent) {
//      yield LoadingState();
      var filterdProducts = new List<Product>();

      if (event.products.isNotEmpty) {
        event.products.forEach((pro) {
          if (event.attributes.length > 0) {
            event.attributes.forEach((attr) {
              pro.attributes.forEach((proAttr) {
                if (attr == proAttr.attribute.id) {
                  filterdProducts.add(pro);
                }
              });
            });
          }

          if (event.brands.length > 0) {
            event.brands.forEach((bran) {
              if (bran.toString() == pro.brand) {
                var product = filterdProducts.firstWhere((item) =>
                int.parse(item.brand) == bran);

                if (product == null) {
                  filterdProducts.add(product);
                }
              }
            });
          }
        });
      }

      if (filterdProducts.length > 0) {
        yield FilteredCategoryProductsLoaded(filterdProducts, true);
      }
      else {
        yield EmptyState();
      }
    }

    if (event is LoadDataEvent) {
      yield LoadingState();
      try {
        int _currentPage = 0;
        var response = await repository.getProductsFromCategory(
            event.categoryId, _currentPage,
            keyword: event.keyword,
            attributes: event.attributes,
            brands: event.brands);
        if (response.success) {
          if (response.data != null && response.data.isNotEmpty) {
            yield CategoryProductsLoaded(response.data, true);
          }
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
            int.parse(event.category), _currentPage,
            keyword: event.keyword,
            attributes: event.attributes,
            brands: event.brands);
        if (response.success) {
          lasPage = response.data.isEmpty;
          yield CategoryProductsLoaded(
              (state as CategoryProductsLoaded).products
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
