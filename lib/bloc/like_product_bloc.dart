import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:justcost/data/exception/exceptions.dart';
import 'package:justcost/data/product/model/like.dart';
import 'package:justcost/data/product/model/product.dart';
import 'package:justcost/data/product/product_repository.dart';

abstract class LikeEvent {}

abstract class LikeState {}

class Like extends LikeEvent {
  final int productId;

  Like(this.productId);
}

class Unlike extends LikeEvent {
  final int productId;

  Unlike(this.productId);

}

class CheckLikeEvent extends LikeEvent {
  final int productId;

  CheckLikeEvent(this.productId);
}

class LikeLoading extends LikeState {}

class LikeError extends LikeState {}

class LikeNetworkError extends LikeState {}

class LikeToggled extends LikeState {}

class UserSessionExpired extends LikeState {}

class LikeIdle extends LikeState {}

class LikeProductBloc extends Bloc<LikeEvent, LikeState> {
  final ProductRepository _repository;

  LikeProductBloc(this._repository);

  @override
  LikeState get initialState => LikeIdle();

  @override
  Stream<LikeState> mapEventToState(LikeEvent event) async* {
    if (event is CheckLikeEvent) {}
    if (event is Like) {
      yield LikeLoading();
      try {
        LikeResponse response =
            await _repository.likeProductById(event.productId);

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
    if (event is Unlike) {
      try {
        LikeResponse response =
            await _repository.likeProductById(event.productId);

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
