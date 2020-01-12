import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:justcost/data/exception/exceptions.dart';
import 'package:justcost/data/product/model/like.dart';
import 'package:justcost/data/product/model/product.dart';
import 'package:justcost/data/product/product_repository.dart';
import 'package:justcost/data/user_sessions.dart';

abstract class LikeEvent {}

abstract class LikeState {}

class ToggleLike extends LikeEvent {
  final int productId;

  ToggleLike(this.productId);
}

class CheckLikeEvent extends LikeEvent {
  final int productId;

  CheckLikeEvent(this.productId);
}

class LikeLoading extends LikeState {}

class LikeError extends LikeState {}


class LikeToggled extends LikeState {
  final bool isLiked;

  LikeToggled(this.isLiked);
}
class GoatUserState extends LikeState{

}

class UserSessionExpired extends LikeState {}

class LikeIdle extends LikeState {}

class LikeLoaded extends LikeState {
  final bool isLiked;

  LikeLoaded(this.isLiked);
}

class LikeProductBloc extends Bloc<LikeEvent, LikeState> {
  final ProductRepository _repository;
  bool isLiked;
  final UserSession _session;

  LikeProductBloc(this._repository, this._session);

  @override
  LikeState get initialState => LikeIdle();

  @override
  Stream<LikeState> mapEventToState(LikeEvent event) async* {
    if (event is CheckLikeEvent) {
      if (await _session.isUserAGoat()) {
        yield GoatUserState();
      } else {
        yield LikeLoading();
        try {
          LikeStatus response = await _repository.checkLiked(event.productId);

          if (response.success) {
            isLiked = response.liked;
            yield LikeLoaded(response.liked);
          } else
            yield LikeError();
        } on SessionExpired {
          yield UserSessionExpired();
        } on DioError {
          yield LikeError();
        } catch (error) {
          yield LikeError();
        }
      }
    }
    if (event is ToggleLike) {
      yield LikeLoading();
      try {
        if (isLiked) {
          var response = await _repository.unlikeProductById(event.productId);
          if (response.success) {
            yield LikeToggled(true);
            add(CheckLikeEvent(event.productId));
          } else
            yield LikeError();
        } else {
          var response = await _repository.likeProductById(event.productId);

          if (response.success) {
            add(CheckLikeEvent(event.productId));

            yield LikeToggled(false);
          } else
            yield LikeError();
        }
      } on SessionExpired {

        yield UserSessionExpired();
      } on DioError {
        yield LikeError();
      } catch (error) {
        yield LikeError();
      }
    }
  }
}
