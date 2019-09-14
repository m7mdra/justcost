import 'package:dio/dio.dart';
import 'package:justcost/data/rate/model/rate_response.dart';
import 'package:justcost/data/user/model/base_response.dart';

class RateRepository {
  final Dio _client;

  RateRepository(this._client);

  Future<RateResponse> getProductRate(int productId) async {
    try {
      var response = await _client.get('product/$productId/ratings');
      return RateResponse.fromJson(response.data);
    } catch (error) {
      throw error;
    }
  }

  Future<ResponseStatus> rateProduct(int product, int rate) async {
    try {
      var response = await _client.post('ratings', data: {
        'rate': rate,
        'product': product,
      });
      return ResponseStatus.fromJson(response.data);
    } catch (error) {
      throw error;
    }
  }
}
