import 'package:bloc/bloc.dart';
import 'package:justcost/data/ad/ad_repository.dart';
import 'package:justcost/data/exception/exceptions.dart';
import 'package:dio/dio.dart';
import 'package:justcost/data/product/model/product.dart';

class GetTermDataEvent {}

class LoadTermsData extends GetTermDataEvent {}

class GetTermDataState {}

class IdleState extends GetTermDataState {}

class LoadingState extends GetTermDataState {}

class NetworkErrorState extends GetTermDataState {}

class ErrorState extends GetTermDataState {}

class SessionExpiredState extends GetTermDataState {}

class TermsDataLoadedState extends GetTermDataState {
  dynamic response;

  TermsDataLoadedState({this.response});
}


class TermsBloc extends Bloc<GetTermDataEvent, GetTermDataState> {
  final AdRepository _repository;
  List<Product> products;

  TermsBloc(this._repository,{this.products});

  @override
  GetTermDataState get initialState => IdleState();
  @override
  void onError(Object error, StackTrace stacktrace) {
    super.onError(error, stacktrace);
    print(error);
    print(stacktrace);
  }
  @override
  Stream<GetTermDataState> mapEventToState(GetTermDataEvent event) async* {
    if (event is LoadTermsData) {
      yield LoadingState();
      try {
        var response = await _repository.getTermsData();
        if (response['success']) {
          yield TermsDataLoadedState(response: response['data']);
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
