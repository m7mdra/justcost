import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:justcost/data/exception/exceptions.dart';
import 'package:justcost/data/product/model/post_ad.dart';
import 'package:justcost/data/product/product_repository.dart';
import 'package:justcost/data/user_sessions.dart';

abstract class PostAdEvent {}

abstract class PostAdStatus {}

class SubmitAd extends PostAdEvent {
  final PostAd ad;

  SubmitAd(this.ad);
}

class CheckIfUserIsNotAGoat extends PostAdEvent {}

class PostAdLoading extends PostAdStatus {}

class PostAdError extends PostAdStatus {}

class PostAdNetworkError extends PostAdStatus {}

class PostAdFailed extends PostAdStatus {}

class PostAdSuccess extends PostAdStatus {}

class UserSessionExpired extends PostAdStatus {}

class GoatUser extends PostAdStatus {}

class NormalUser extends PostAdStatus {}

class PostAdBloc extends Bloc<PostAdEvent, PostAdStatus> {
  final ProductRepository _repository;
  final UserSession _session;

  PostAdBloc(this._repository, this._session);

  @override
  PostAdStatus get initialState => NormalUser();

  @override
  Stream<PostAdStatus> mapEventToState(PostAdEvent event) async* {
    if (event is CheckIfUserIsNotAGoat) if (await _session.isUserAGoat())
      yield GoatUser();
    if (event is SubmitAd) {
      yield PostAdLoading();
      try {
        var response = await _repository.postAd(event.ad);
        if (response.success)
          yield PostAdSuccess();
        else
          yield PostAdFailed();
      } on DioError {
        yield PostAdNetworkError();
      } on SessionExpired {
        yield UserSessionExpired();
      } catch (error) {
        yield PostAdError();
      }
    }
  }
}
