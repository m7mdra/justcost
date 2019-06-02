import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:justcost/data/exception/exceptions.dart';
import 'package:justcost/data/product/model/like.dart';
import 'package:justcost/data/product/model/product.dart';
import 'package:justcost/data/product/product_repository.dart';

abstract class LikeEvent {}

abstract class LikeState {}

class ToggleLike extends LikeEvent {
  final Product product;

  ToggleLike(this.product);
}

class LikeLoading extends LikeState {}

class LikeError extends LikeState {}

class LikeNetworkError extends LikeState {}

class LikeToggled extends LikeState {}

class UserSessionExpired extends LikeState {}
class LikeIdle extends LikeState{}

class LikeProductBloc extends Bloc<LikeEvent, LikeState> {
  final ProductRepository _repository;


  LikeProductBloc(this._repository);

  @override
  LikeState get initialState => LikeIdle();

  @override
  Stream<LikeState> mapEventToState(LikeEvent event) async* {
    if (event is ToggleLike) {
      yield LikeLoading();
      try {
        LikeResponse response;
        if (event.product.liked)
          response =
              await _repository.unlikeProductById(event.product.productId);
        else
          response = await _repository.likeProductById(event.product.productId);
        if (response.success)
          yield LikeToggled();
        else
          yield LikeError();
      } on SessionExpired {
        yield UserSessionExpired();
      } on DioError {
        yield LikeNetworkError();
      } catch (error) {
        yield LikeError();
      }
    }
  }
}
