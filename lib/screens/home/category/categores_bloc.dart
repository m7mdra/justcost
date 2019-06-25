import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:justcost/data/category/category_repository.dart';
import 'package:justcost/data/category/model/category.dart';

abstract class CategoriesEvent extends Equatable {
  CategoriesEvent([List props = const []]) : super(props);
}

abstract class CategoriesState {}

class FetchCategoriesEvent extends CategoriesEvent {}

class FetchCategoriesDescendant extends CategoriesEvent {
  final int categoryId;

  FetchCategoriesDescendant(this.categoryId);
}


class CategoriesLoadingState extends CategoriesState {}

class CategoriesError extends CategoriesState {}

class CategoriesNetworkError extends CategoriesState {}

class NoCategorieState extends CategoriesState {}

class CategoriesLoadedState extends CategoriesState {
  final List<Category> categories;

  CategoriesLoadedState(this.categories);
}

class CategorieIdleState extends CategoriesState {}

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  final CategoryRepository _repository;

  CategoriesBloc(this._repository);

  @override
  CategoriesState get initialState => CategoriesLoadingState();

  @override
  Stream<CategoriesState> mapEventToState(
    CategoriesEvent event,
  ) async* {
    if (event is FetchCategoriesDescendant) {
      yield CategoriesLoadingState();
      try {
        CategoryResponse response =
            await _repository.getCategoryDescendants(event.categoryId);
        if (response.status) {
          if (response.content == null || response.content.isEmpty)
            yield NoCategorieState();
          else
            yield CategoriesLoadedState(response.content);
        } else {
          yield CategoriesError();
        }
      } on DioError catch (error) {
        print(error);
        yield CategoriesNetworkError();
      } catch (error) {
        print("general error: $error");
        yield CategoriesError();
      }
    }
    if (event is FetchCategoriesEvent) {
      yield CategoriesLoadingState();
      try {
        CategoryResponse response = await _repository.getCategories();
        if (response.status) {
          if (response.content == null || response.content.isEmpty)
            yield NoCategorieState();
          else
            yield CategoriesLoadedState(response.content);
        } else {
          yield CategoriesError();
        }
      } on DioError catch (error) {
        yield CategoriesNetworkError();
      } catch (error) {
        yield CategoriesError();
      }
    }
  }
}
