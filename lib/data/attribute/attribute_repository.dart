import 'package:dio/dio.dart';
import 'package:justcost/data/attribute/model/attribute.dart';

class AttributeRepository {
  final Dio _client;

  AttributeRepository(this._client);

  Future<AttributeResponse> getAttributesForProduct(int productId) async {
    try {
      var response = await _client.get('products/attributes/$productId');
      return AttributeResponse.fromJson(response.data);
    } on DioError catch (error) {
      throw error;
    }
  }
}
