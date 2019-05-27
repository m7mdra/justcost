import 'package:dio/dio.dart';
import 'package:justcost/data/comment/model/comment.dart';

class CommentRepository {
  final Dio _client;

  CommentRepository(this._client);

  Future<CommentResponse> getCommentsByProduct(int productId) async {
    try {
      var response = await _client.get('productcomments/$productId');
      return CommentResponse.fromJson(response.data);
    } catch (error) {
      throw error;
    }
  }
}
