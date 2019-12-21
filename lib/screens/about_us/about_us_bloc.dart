import 'package:bloc/bloc.dart';
import 'package:justcost/data/ad/ad_repository.dart';
import 'package:justcost/data/exception/exceptions.dart';
import 'package:dio/dio.dart';
import 'package:justcost/data/product/model/product.dart';

class GetAboutDataEvent {}

class LoadAboutData extends GetAboutDataEvent {}

class GetAboutDataState {}

class IdleState extends GetAboutDataState {}

class LoadingState extends GetAboutDataState {}

class NetworkErrorState extends GetAboutDataState {}

class ErrorState extends GetAboutDataState {}

class SessionExpiredState extends GetAboutDataState {}

class AboutDataLoadedState extends GetAboutDataState {
  dynamic response;

  AboutDataLoadedState({this.response});
}


class AboutBloc extends Bloc<GetAboutDataEvent, GetAboutDataState> {
  final AdRepository _repository;
  List<Product> products;

  AboutBloc(this._repository,{this.products});

  @override
  GetAboutDataState get initialState => IdleState();
  @override
  void onError(Object error, StackTrace stacktrace) {
    super.onError(error, stacktrace);
    print(error);
    print(stacktrace);
  }
  @override
  Stream<GetAboutDataState> mapEventToState(GetAboutDataEvent event) async* {
    if (event is LoadAboutData) {
      yield LoadingState();
      try {
        var response = await _repository.getAboutData();
        if (response['success']) {
            yield AboutDataLoadedState(response: response['data']);
        } else {
          yield ErrorState();
        }
      } on SessionExpired {
        yield SessionExpiredState();
      } on DioError catch(error){
        yield NetworkErrorState();
        print(error);
      } catch (error) {
        print(error);
        yield ErrorState();
      }
    }
  }
}
