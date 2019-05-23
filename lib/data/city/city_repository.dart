import 'package:dio/dio.dart';

import 'model/city.dart';

class CityRepository {
  final Dio _client;

  CityRepository(this._client);

  Future<CityResponse> getCites() async {
    try {
      var response = await _client.get('cities');
      return CityResponse.fromJson(response.data);
    } catch (error) {
      throw error;
    }
  }
}
