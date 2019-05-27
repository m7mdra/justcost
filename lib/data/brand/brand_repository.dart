import 'package:dio/dio.dart';

import 'model/brand.dart';


class BrandRepository {
  final Dio _client;

  BrandRepository(this._client);

  Future<BrandResponse> getBrandForCategoryWithId(int id) async {
    try {
      var response = await _client.get('brandsogcategory/$id');
      return BrandResponse.fromJson(response.data);
    } catch (error) {
      throw error;
    }
  }
}
