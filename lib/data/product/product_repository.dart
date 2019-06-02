import 'package:dio/dio.dart';
import 'package:justcost/data/exception/exceptions.dart';
import 'package:justcost/data/product/model/like.dart';
import 'package:justcost/data/product/model/product_details.dart';

import 'model/post_ad.dart';
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

  Future<ProductResponse> findProductsByName(String name) async {
    try {
      var response =
          await _client.get('products', queryParameters: {'search': name});
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

  Future<PostAdResponse> postAd(PostAd ad) async {
    try {
      var data = FormData.from({
        'title': ad.title,
        'category_id': ad.category.id,
        'description': ad.description,
        'keywordsId': 1,
        'reg_price': ad.regularPrice,
        'sale_price': ad.salePrice,
        'cityId': ad.city.id,
        'brand_id': ad.brandId,
        'ispaided': 1,
        'iswholesale': 1,
        'status': 1,
        'lat': ad.lat,
        'lng': ad.lng,
        'media[]': ad.media.map((f) => UploadFileInfo(f, "${f.path}")).toList()
      });
      print(data.toString());
      var response = await _client.post('products', data: data);
      return PostAdResponse.fromJson(response.data);
    } on DioError catch (error) {
      if (error.response.statusCode == 401)
        throw SessionExpired();
      else
        throw error;
    } catch (error) {
      throw error;
    }
  }

  Future<LikeResponse> likeProductById(int id) async {
    try {
      var response = await _client.post('likes', data: {'product_id': id});
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

  Future<LikeResponse> unlikeProductById(int id) async {
    try {
      var response = await _client.delete('likes', data: {'product_id': id});
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
}
