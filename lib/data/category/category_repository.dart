import 'package:dio/dio.dart';
import 'package:justcost/data/category/model/category.dart';

class CategoryRepository {
  final Dio _client;

  CategoryRepository(this._client);
  Future<CategoryResponse> getCategories() async {
    try {
      var response = await _client.get('jc-category/category/all');
      return CategoryResponse.fromJson(response.data);
    } catch (error) {
      throw error;
    }
  }

  Future<CategoryResponse> getCategoryDescendant(String categoryId) async {
    try {
      var response = await _client.get('jc-category/category/$categoryId');
      return CategoryResponse.fromJson(response.data);
    } on DioError catch (error) {
      throw error;
    } catch (error) {
      throw error;
    }
  }
}
