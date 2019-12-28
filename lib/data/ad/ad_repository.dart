import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:justcost/data/ad/model/my_ads_response.dart';
import 'package:justcost/data/ad/model/post_ad_response.dart';
import 'package:justcost/data/attribute/model/category_attribute.dart';
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

  Future<PostAdResponse> updateAd(
      {
        int adId,
        int customerId,
//        int cityId,
        double lng,
        double lat,
        String mobile,
        String title,
        String description,
        }) async {
    try {
      var response = await _client.post('ads/$adId', data: {
        'customerId': customerId,
//        'cityId': cityId,
        'lng': lng,
        'lat': lat,
        'mobile': mobile,
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
      dynamic attributes,
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
        'attributes[]': json.encode(attributes),
        'iswholesale': isWholeSale,
        'title': title,
        'media[]': medias
            .map((media) => UploadFileInfo(media.file, media.file.path))
            .toList()
      });
      print(formData);
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

  Future<ResponseStatus> updateProduct(
      {
        int productId,
        int categoryId,
        String description,
        String regularPrice,
        String salePrice,
        int brandId,
        int isPaid = 0,
        int adId,
        int isWholeSale,
        String title,
        ProgressCallback progressCallback}) async {
    try {
      var formDataWithCategoryAndBrand = FormData.from({
        'category_id': categoryId,
        'description': description,
        'reg_price': regularPrice,
        'sale_price': salePrice,
        'brand_id': brandId,
        'iswholesale': 0,
        'title': title,
      });

      var formData = FormData.from({
        'description': description,
        'reg_price': regularPrice,
        'sale_price': salePrice,
        'iswholesale': 0,
        'title': title,
      });

      print(formData);
      var response = await _client.post('products/$productId',data: categoryId == null || brandId == null ? formData : formDataWithCategoryAndBrand , onSendProgress: progressCallback);
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

  Future<dynamic> getAboutData() async {
    try {
      var response = await _client.get('aboutes');
      return response.data;
    } on DioError catch (error) {
      if (error.response.statusCode == UNAUTHORIZED_CODE)
        throw SessionExpired();
      else
        throw error;
    } catch (error) {
      throw error;
    }
  }

  Future<dynamic> getAboutContactData() async {
    try {
      var response = await _client.get('about_pages');
      return response.data;
    } on DioError catch (error) {
      if (error.response.statusCode == UNAUTHORIZED_CODE)
        throw SessionExpired();
      else
        throw error;
    } catch (error) {
      throw error;
    }
  }

  Future<dynamic> getAboutLinkData() async {
    try {
      var response = await _client.get('links');
      return response.data;
    } on DioError catch (error) {
      if (error.response.statusCode == UNAUTHORIZED_CODE)
        throw SessionExpired();
      else
        throw error;
    } catch (error) {
      throw error;
    }
  }

  Future<dynamic> getTermsData() async {
    try {
      var response = await _client.get('terms');
      return response.data;
    } on DioError catch (error) {
      if (error.response.statusCode == UNAUTHORIZED_CODE)
        throw SessionExpired();
      else
        throw error;
    } catch (error) {
      throw error;
    }
  }

  Future<dynamic> getFQAData() async {
    try {
      var response = await _client.get('fqas');
      return response.data;
    } on DioError catch (error) {
      if (error.response.statusCode == UNAUTHORIZED_CODE)
        throw SessionExpired();
      else
        throw error;
    } catch (error) {
      throw error;
    }
  }

  Future<dynamic> sendReport(String name , String email , String subject , String message) async {
    try {
      var response = await _client.post('contact-us',
      data: {
        "name":name,
        "email":email,
        "subject":subject,
        "message":message
      });
      return response.data;
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
