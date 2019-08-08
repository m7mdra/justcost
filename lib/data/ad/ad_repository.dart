import 'package:dio/dio.dart';
import 'package:justcost/data/ad/model/my_ads_response.dart';
import 'package:justcost/data/ad/model/post_ad_response.dart';
import 'package:justcost/data/exception/exceptions.dart';
import 'package:justcost/data/user/model/base_response.dart';
import 'package:justcost/data/user/user_repository.dart';
import 'package:justcost/data/user_sessions.dart';
import 'package:justcost/model/media.dart';
import 'package:justcost/screens/postad/ad.dart';

class AdRepository {
  final Dio _client;

  AdRepository(this._client);

  Future<PostAdResponse> postAd(
      {int customerId,
      int cityId,
      double lng,
      double lat,
      String mobile,
      String facebookAccount,
      String twitterAccount,
      String instagramAccount,
      String snapchatAccount,
      String title,
      String description,
      int isWholeSale}) async {
    try {
      var response = await _client.post('ads', data: {
        'customerId': customerId,
        'cityId': cityId,
        'lng': lng,
        'lat': lat,
        'facebookAccount': facebookAccount,
        'twitterAccount': twitterAccount,
        'instagramAccount': instagramAccount,
        'snapchatAccount': snapchatAccount,
        'mobile': mobile,
        'iswholesale': isWholeSale,
        'ad_title': title,
        'ad_description': description
      });

      return PostAdResponse.fromJson(response.data);
    } on DioError catch (error) {
      if (error.response.statusCode == UNAUTHORIZED_CODE)
        throw SessionExpired();
      else
        throw error;
    } catch (error) {
      throw error;
    }
  }

  Future<ResponseStatus> postProduct(
      {int categoryId,
      String description,
      String regularPrice,
      String salePrice,
      int brandId,
      int isPaid = 0,
      int adId,
      String quantity = "0",
      int isWholeSale,
      String title,
      List<int> attributes,
      List<Media> medias,
      ProgressCallback progressCallback}) async {
    try {
      var formData = FormData.from({
        'category_id': categoryId,
        'description': description,
        'reg_price': regularPrice,
        'sale_price': salePrice,
        'brand_id': brandId,
        'ispaided': isPaid,
        'ad_id': adId,
        'qty': quantity,
        'attributes': attributes,
        'iswholesale': isWholeSale,
        'title': title,
        'media[]': medias
            .map((media) => UploadFileInfo(media.file, media.file.path))
            .toList()
      });
      var response = await _client.post('products',
          data: formData, onSendProgress: progressCallback);
      return ResponseStatus.fromJson(response.data);
    } on DioError catch (error) {
      if (error.response.statusCode == UNAUTHORIZED_CODE)
        throw SessionExpired();
      else
        throw error;
    } catch (error) {
      throw error;
    }
  }

  Future<MyAdsResponse> getMyAds() async {
    try {
      var response = await _client.get('myads');
      return MyAdsResponse.fromJson(response.data);
    } on DioError catch (error) {
      if (error.response.statusCode == UNAUTHORIZED_CODE)
        throw SessionExpired();
      else
        throw error;
    } catch (error) {
      throw error;
    }
  }
}
