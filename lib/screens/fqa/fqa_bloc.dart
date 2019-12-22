import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:justcost/data/ad/ad_repository.dart';
import 'package:justcost/data/product/model/product.dart';
import 'package:justcost/data/exception/exceptions.dart';
import 'package:justcost/model/fqa.dart';

class GetFQADataEvent {}

class LoadFQAData extends GetFQADataEvent {}

class GetFQADataState {}

class IdleState extends GetFQADataState {}

class LoadingState extends GetFQADataState {}

class NetworkErrorState extends GetFQADataState {}

class ErrorState extends GetFQADataState {}

class SessionExpiredState extends GetFQADataState {}

class FQADataLoadedState extends GetFQADataState {
  List<FQA> fqaList;

  FQADataLoadedState({this.fqaList});
}


class FQABloc extends Bloc<GetFQADataEvent, GetFQADataState> {
  final AdRepository _repository;
  List<FQA> fqa;

  FQABloc(this._repository);

  @override
  GetFQADataState get initialState => IdleState();
  @override
  void onError(Object error, StackTrace stacktrace) {
    super.onError(error, stacktrace);
    print(error);
    print(stacktrace);
  }
  @override
  Stream<GetFQADataState> mapEventToState(GetFQADataEvent event) async* {
    if (event is LoadFQAData) {
      yield LoadingState();
      try {
        var response = await _repository.getFQAData();
        if (response['success']) {

          if (response['data'] != null) {
            fqa = new List<FQA>();
            response['data'].forEach((v) {
              fqa.add(new FQA.fromJson(v));
            });
          }

          yield FQADataLoadedState(fqaList: fqa);

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

