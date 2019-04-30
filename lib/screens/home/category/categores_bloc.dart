import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:justcost/data/category/category_repository.dart';
import 'package:justcost/data/category/model/category.dart';
import 'package:dio/dio.dart';

abstract class CategriesEvent extends Equatable {
  CategriesEvent([List props = const []]) : super(props);
}

abstract class CategoriesState {}

class FetchCategoriesEvent extends CategriesEvent {}

class CategoriesLoadingState extends CategoriesState {}

class CategoriesError extends CategoriesState {}

class NoCategorieState extends CategoriesState {}

class CategoriesLoadedState extends CategoriesState {
  final List<Category> categories;

  CategoriesLoadedState(this.categories);
}

class CategorieIdleState extends CategoriesState {}

class CategoriesBloc extends Bloc<CategriesEvent, CategoriesState> {
  final CategoryRepository _repository;

  CategoriesBloc(this._repository);
  @override
  CategoriesState get initialState => CategoriesLoadingState();

  @override
  Stream<CategoriesState> mapEventToState(
    CategriesEvent event,
  ) async* {
    if (event is FetchCategoriesEvent) {
      yield CategoriesLoadingState();
      try {
        CategoryResponse response = await _repository.getCategories();
        if (response.status) {
          if (response.content != null || response.content.isEmpty)
            yield NoCategorieState();
          else
            yield CategoriesLoadedState(response.content);
        } else {
          yield CategoriesError();
        }
      } on DioError catch (error) {
        yield CategoriesError();
      } catch (error) {
        yield CategoriesError();
      }
    }
  }
}
