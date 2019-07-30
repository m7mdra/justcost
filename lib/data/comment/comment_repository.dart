import 'package:dio/dio.dart';
import 'package:justcost/data/comment/model/comment.dart';
import 'package:justcost/data/exception/exceptions.dart';

import 'model/post_comment_response.dart';

class CommentRepository {
  final Dio _client;

  CommentRepository(this._client);

  Future<CommentResponse> getCommentsByProduct(int productId) async {
    try {
      var response = await _client.get('productcomments/$productId');
      return CommentResponse.fromJson(response.data);
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<PostCommentResponse> addCommentToProduct(
      int productId, String comment, int parentId,) async {
    try {
      var data = {};
      if (productId != null) data['productid'] = productId;
      if (comment != null) data['comment'] = comment;
      if (parentId != null) data['parent_id'] = parentId;

      var response = await _client.post('comments', data: data);
      return PostCommentResponse.fromJson(response.data);
    } on DioError catch (error) {
      if (error.response.statusCode == 401)
        throw SessionExpired();
      else
        throw error;
    } catch (error) {
      throw error;
    }
  }
}
