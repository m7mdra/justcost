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

  CategoryProductsLoaded(this.products);
}

class LoadDataEvent extends CategoryProductsEvent {
  final int categoryId;
  final List<int> attributes;
  final String keyword;

  LoadDataEvent(this.categoryId, this.attributes, this.keyword);
}

class RetryEvent extends CategoryProductsEvent {
  final int categoryId;

  RetryEvent(this.categoryId);
}

class CategoryProductsBloc
    extends Bloc<CategoryProductsEvent, CategoryProductsState> {
  final ProductRepository repository;

  CategoryProductsBloc(this.repository);

  @override
  CategoryProductsState get initialState => LoadingState();

  @override
  Stream<CategoryProductsState> mapEventToState(
      CategoryProductsEvent event) async* {
    if (event is LoadDataEvent) {
      yield LoadingState();
      try {
        var response = await repository.getProductsFromCategory(
            event.categoryId,
            keyword: event.keyword,
            attributes: event.attributes);
        if (response.success) {
          if (response.data != null && response.data.isNotEmpty)
            yield CategoryProductsLoaded(response.data);
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
  }
}
