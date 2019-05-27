import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:justcost/data/brand/brand_repository.dart';
import 'package:justcost/data/brand/model/brand.dart';

abstract class BrandEvent {}

abstract class BrandState {}

class LoadBrands extends BrandEvent {
  final int categoryId;

  LoadBrands(this.categoryId);
}

class BrandsLoading extends BrandState {}

class BrandsError extends BrandState {}

class BrandsEmpty extends BrandState {}

class BrandsNetworkError extends BrandState {}

class BrandsLoaded extends BrandState {
  final List<Brand> brands;

  BrandsLoaded(this.brands);
}

class BrandBloc extends Bloc<BrandEvent, BrandState> {
  final BrandRepository _repository;

  BrandBloc(this._repository);

  @override
  BrandState get initialState => BrandsLoading();

  @override
  Stream<BrandState> mapEventToState(BrandEvent event) async* {
    if (event is LoadBrands) {
      yield BrandsLoading();

      try {
        var response =
            await _repository.getBrandForCategoryWithId(event.categoryId);
        if (response.success) {
          if (response.data.isEmpty)
            yield BrandsEmpty();
          else
            yield BrandsLoaded(response.data);
        } else {
          yield BrandsError();
        }
      } on DioError {
        yield BrandsNetworkError();
      } catch (error) {
        yield BrandsError();
      }
    }
  }
}
