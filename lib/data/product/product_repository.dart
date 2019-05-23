import 'package:dio/dio.dart';
import 'model/product.dart';

class ProductRepository {
  final Dio _client;

  ProductRepository(this._client);

  Future<ProductResponse> getProductsFromCategory(int categoryId) async {
    try {
      var response = await _client.get('categoryproudects/$categoryId');
      return ProductResponse.fromJson(response.data);
    } catch (error) {
      throw error;
    }
  }

  Future<ProductResponse> getProducts() async {
    try {
      var response = await _client.get('products');
      return ProductResponse.fromJson(response.data);
    } catch (error) {
      throw error;
    }
  }
}
