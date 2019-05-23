import 'package:dio/dio.dart';
import 'package:justcost/data/category/model/category.dart';

class CategoryRepository {
  final Dio _client;

  CategoryRepository(this._client);

  Future<CategoryResponse> getCategories() async {
    try {
      var response = await _client.get('/categories');
      return CategoryResponse.fromJson(response.data);
    }on DioError catch(error){
      throw error;
    }catch (error) {
      throw error;
    }
  }

  Future<CategoryResponse> getCategoryDescendants(int categoryId) async {
    try {
      var response = await _client.get('/subCategories/$categoryId');
      return CategoryResponse.fromJson(response.data);
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
