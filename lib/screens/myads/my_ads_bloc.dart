import 'package:bloc/bloc.dart';
import 'package:justcost/data/ad/ad_repository.dart';
import 'package:justcost/data/ad/model/my_ads_response.dart';
import 'package:justcost/data/exception/exceptions.dart';
import 'package:dio/dio.dart';

class MyAdsEvent {}

class LoadMyAds extends MyAdsEvent {}

class MyAdsState {}

class IdleState extends MyAdsState {}

class LoadingState extends MyAdsState {}

class NetworkErrorState extends MyAdsState {}

class EmptyState extends MyAdsState {}

class ErrorState extends MyAdsState {}

class SessionExpiredState extends MyAdsState {}

class MyAdsLoadedState extends MyAdsState {
  final List<Ad> ads;

  MyAdsLoadedState(this.ads);
}

class MyAdsBloc extends Bloc<MyAdsEvent, MyAdsState> {
  final AdRepository _repository;

  MyAdsBloc(this._repository);

  @override
  MyAdsState get initialState => IdleState();

  @override
  Stream<MyAdsState> mapEventToState(MyAdsEvent event) async* {
    if (event is LoadMyAds) {
      yield LoadingState();
      try {
        var response = await _repository.getMyAds();
        if (response.success) {
          if (response.ads.isEmpty)
            yield EmptyState();
          else
            yield MyAdsLoadedState(response.ads);
        } else {
          yield ErrorState();
        }
      } on SessionExpired {
        yield SessionExpiredState();
      } on DioError {
        yield NetworkErrorState();
      } catch (error) {
        yield ErrorState();
      }
    }
  }
}
