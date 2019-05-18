import 'package:dio/dio.dart';
import 'model/product.dart';

class ProductRepository {
  final Dio _client;

  ProductRepository(this._client);

  Future<ProductResponse> getProductsFromCategory(int categoryId) async {
    try {
      var response = await _client.get('/categoryproudects/7');
      return ProductResponse.fromJson(response.data);
    } catch (error) {
      throw error;
    }
  }
  
}
