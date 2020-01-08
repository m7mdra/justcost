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

  Future<ProductResponse> getProductsFromCategory(int categoryId, int page,
      {String keyword, List<int> attributes, List<int> brands}) async {
    try {
      var queryParameters = Map<String, dynamic>();
      if (keyword != null && keyword.isNotEmpty)
        queryParameters['Search'] = keyword;
      if (attributes != null && attributes.isNotEmpty)
        queryParameters['selected'] = attributes.join(',');
      if (brands != null && brands.isNotEmpty)
        queryParameters['brands'] = brands.join(',');
      queryParameters['skip'] = page;
      var response = await _client.get('categoryproudects/$categoryId', queryParameters: queryParameters);
      return ProductResponse.fromJson(response.data);
    } catch (error) {
      throw error;
    }
  }

  Future<ProductResponse> getProducts({int page = 0}) async {
    try {
      var response =
          await _client.get('getAllProducts', queryParameters: {'skip': page});
      return ProductResponse.fromJson(response.data);
    } catch (error) {
      throw error;
    }
  }

  Future<ProductResponse> getFeaturedProducts({int page = 0}) async {
    try {
      var response =
          await _client.get('getfeaturedProducts', queryParameters: {'skip': page});
      return ProductResponse.fromJson(response.data);
    } catch (error) {
      throw error;
    }
  }


  Future<ProductResponse> findProductsByName(
      String name, int cityId, int page) async {
    try {
      var params = {'Search': name};
      if (cityId != -1) params['city'] = cityId.toString();
      params['skip'] = page.toString();
      var response =
          await _client.get('search', queryParameters: params);
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
      var response = await _client.post('like/addlike', data: {'id': id});
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
      var response = await _client.post('like/dislike',queryParameters: {'id': id});
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

  Future<ProductResponse> getLikedProduct() async {
    try {
      var response = await _client.get('like/likedProducts');
      return ProductResponse.fromJson(response.data);
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
