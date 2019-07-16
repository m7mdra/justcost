import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:justcost/data/comment/comment_repository.dart';
import 'package:justcost/data/comment/model/comment.dart';
import 'package:justcost/data/exception/exceptions.dart';

abstract class CommentsEvent {}

abstract class CommentsState {}

class LoadComments extends CommentsEvent {
  final int id;

  LoadComments(this.id);
}

class CommentsLoading extends CommentsState {}

class CommentsError extends CommentsState {}

class CommentsNetworkError extends CommentsState {}

class NoComments extends CommentsState {}

class CommentsLoaded extends CommentsState {
  final List<Comment> comments;

  CommentsLoaded(this.comments);
}

class CommentsBloc extends Bloc<CommentsEvent, CommentsState> {
  final CommentRepository repository;

  CommentsBloc(this.repository);

  @override
  CommentsState get initialState => CommentsLoading();
  @override
  void onError(Object error, StackTrace stacktrace) {
    super.onError(error, stacktrace);
    print(error);
    print(stacktrace);
  }

  @override
  Stream<CommentsState> mapEventToState(CommentsEvent event) async* {
    if (event is LoadComments) {
      yield CommentsLoading();
      try {
        var response = await repository.getCommentsByProduct(event.id);
        if (response.success) {
          var comments = response.data;
          if (comments != null && comments.isNotEmpty) {
            yield CommentsLoaded(comments);
          } else
            yield NoComments();
        } else {
          yield CommentsError();
        }
      } on DioError catch (e) {
        yield CommentsNetworkError();
      } catch (e) {
        yield CommentsError();
      }
    }
  }
}
