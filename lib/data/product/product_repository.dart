import 'package:dio/dio.dart';
import 'package:justcost/data/exception/exceptions.dart';
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

  Future<ProductDeatilsResponse> getProductDetails(int id) async {
    try {
      var response = await _client.get('products/$id');
      return ProductDeatilsResponse.fromJson(response.data);
    } catch (error) {
      throw error;
    }
  }

  Future postAd(PostAd ad) async {
    try {
      var data = FormData.from({
        'image': UploadFileInfo(
            ad.image, "${ad.title}-${ad.category.id}-${ad.category.name}"),
        'category_id': ad.category.id,
        'description': ad.description,
        'keywordsId': ad.keyword,
        'reg_price': ad.regularPrice,
        'sale_price': ad.salePrice,
        'cityId': ad.city.id,
        'brand_id': ad.brandId,
        'ispaided':1,
        'iswholesale':1,
        'status':1,
        'media':ad.media.map((f)=>UploadFileInfo(f,"${f.path}"))
      });
      var response = await _client.post('products', data: data);
    } on DioError catch (error) {
      if (error.response.statusCode == 401) throw SessionExpired();
    } catch (error) {
      throw error;
    }
  }
}
