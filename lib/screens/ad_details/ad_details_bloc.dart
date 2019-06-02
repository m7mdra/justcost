import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:justcost/data/product/model/product_details.dart';
import 'package:justcost/data/product/product_repository.dart';

abstract class AdDetailsEvent {}

abstract class AdDetailsState {}

class LoadEvent extends AdDetailsEvent {
  final int id;

  LoadEvent(this.id);
}

class AdsDetailsLoading extends AdDetailsState {}

class AdsDetailsError extends AdDetailsState {}

class AdsDetailsNetworkError extends AdDetailsState {}

class AdsDetailsLoaded extends AdDetailsState {
  final ProductDeatils details;

  AdsDetailsLoaded(this.details);
}

class AdsDetailsIdle extends AdDetailsState {}

class AdDetailsBloc extends Bloc<AdDetailsEvent, AdDetailsState> {
  final ProductRepository repository;

  AdDetailsBloc(this.repository);

  @override
  AdDetailsState get initialState => AdsDetailsLoading();

  @override
  Stream<AdDetailsState> mapEventToState(AdDetailsEvent event) async* {
    if (event is LoadEvent) {
      yield AdsDetailsLoading();
      try {
        var response = await repository.getProductDetails(event.id);
        if (response.success)
          yield AdsDetailsLoaded(response.data[0]);
        else
          yield AdsDetailsError();
      } on DioError catch (e) {
        yield AdsDetailsNetworkError();
      } catch (e) {
        yield AdsDetailsNetworkError();
      }
    }
  }
}
