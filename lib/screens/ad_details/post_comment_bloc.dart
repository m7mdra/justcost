import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:justcost/data/comment/comment_repository.dart';
import 'package:justcost/data/exception/exceptions.dart';
import 'package:justcost/data/user_sessions.dart';
import 'package:justcost/screens/ad_details/comment_bloc.dart';

class PostCommentBloc extends Bloc<PostEvent, PostState> {
  final CommentRepository _repository;
  final UserSession _session;

  PostCommentBloc(this._repository, this._session);

  @override
  PostState get initialState => PostCommentIdle();

  @override
  Stream<PostState> mapEventToState(PostEvent event) async* {
    if (event is CheckIfUserIsGoat) {
      if (await _session.isUserAGoat()) {
        yield GoatUser();
      } else {
        yield NormalUser();
      }
    }
    if (event is PostComment) {
      try {
        yield PostCommentLoading();
        var response = await _repository.addCommentToProduct(
            event.productId, event.comment, event.parentId);
        if (response.success) {
          yield PostCommentSuccess();
          yield ShowRatingAfterSuccess(response.data.rated);
        } else {
          yield PostCommentFailed();
        }
      } on SessionExpired {
        yield SessionExpiredState();
      } on DioError {
        yield PostCommentFailed();
      } catch (error) {
        yield PostCommentFailed();
      }
    }
  }
}

abstract class PostEvent {}

abstract class PostState {}

class PostComment extends PostEvent {
  final int productId;
  final int parentId;
  final String comment;

  PostComment(this.productId, this.parentId, this.comment);
}

class SessionExpiredState extends PostState {}

class CheckIfUserIsGoat extends PostEvent {}

class NormalUser extends PostState {}

class GoatUser extends PostState {}

class PostCommentIdle extends PostState {}

class PostCommentLoading extends PostState {}

class PostCommentFailed extends PostState {}

class PostCommentSuccess extends PostState {}

class ShowRatingAfterSuccess extends PostState {
  final bool show;

  ShowRatingAfterSuccess(this.show);
}
