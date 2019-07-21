import 'package:dio/dio.dart';
import 'package:justcost/data/exception/exceptions.dart';
import 'package:justcost/data/product/model/like.dart';
import 'package:justcost/data/product/model/product_details.dart';
import 'package:justcost/screens/postad/ad.dart';

import 'model/post_ad.dart';
import 'model/product.dart';

class ProductRepository {
  final Dio _client;

  ProductRepository(this._client);

  Future<ProductResponse> getProductsFromCategory(int categoryId,
      {String keyword, List<int> attributes, List<int> brands}) async {
    try {
      var queryParameters = Map<String, dynamic>();
      if (keyword != null && keyword.isNotEmpty)
        queryParameters['search'] = keyword;
      if (attributes != null && attributes.isNotEmpty)
        queryParameters['selected'] = attributes.join(',');
      if (brands != null && brands.isNotEmpty)
        queryParameters['brands'] = brands.join(',');
      var response = await _client.get('getAllProducts?category=$categoryId',
          queryParameters: queryParameters);
      return ProductResponse.fromJson(response.data);
    } catch (error) {
      throw error;
    }
  }

  Future<ProductResponse> getProducts({int page = 0}) async {
    try {
      var response = await _client.get('getAllProducts?skip=$page');
      return ProductResponse.fromJson(response.data);
    } catch (error) {
      throw error;
    }
  }

  Future<ProductResponse> findProductsByName(String name, int cityId) async {
    try {
      var params = {'search': name};
      if (cityId != -1) params['city'] = cityId.toString();
      var response = await _client.get('products', queryParameters: params);
      return ProductResponse.fromJson(response.data);
    } catch (error) {
      throw error;
    }
  }

  Future<ProductDeatilsResponse> getProductDetails(int id) async {
    try {
      var response = await _client.get('products/$id');
      return ProductDeatilsResponse.fromJson(response.data);
    } catch (error) {
      throw error;
    }
  }

  Future<LikeResponse> likeProductById(int id) async {
    try {
      var response =
          await _client.post('like/addlike', data: {'id': id});
      return LikeResponse.fromJson(response.data);
    } on DioError catch (error) {
      if (error.response.statusCode == 401)
        throw SessionExpired();
      else
        throw error;
    } catch (error) {
      throw error;
    }
  }

  Future<LikeStatus> checkLiked(int id) async {
    try {
      var response = await _client.get(
        'like/islike?id=$id',
      );
      return LikeStatus.fromJson(response.data);
    } on DioError catch (error) {
      if (error.response.statusCode == 401)
        throw SessionExpired();
      else
        throw error;
    } catch (error) {
      throw error;
    }
  }

  Future<DisLikeResponse> unlikeProductById(int id) async {
    try {
      var response =
          await _client.get('like/dislike?id=$id');
      return DisLikeResponse.fromJson(response.data);
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
