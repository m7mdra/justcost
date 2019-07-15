import 'package:dio/dio.dart';
import 'package:justcost/data/exception/exceptions.dart';
import 'package:justcost/data/product/model/like.dart';
import 'package:justcost/data/product/model/product_details.dart';
import 'package:justcost/screens/ad.dart';

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
      var response = await _client.get('categoryproudects/$categoryId',
          queryParameters: queryParameters);
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
        'lat': ad.lat.toString(),
        'lng': ad.lng.toString(),
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

  void postad(Ad ad) {
    FormData.from({
      "products": ad.adProducts.map((product) {
        var json = product.toJson();
        json.remove("media");
        json['media'] = product.mediaList
            .map((media) => UploadFileInfo(media.file, "${media.file.path}"));
        return json;
      })
    });
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
