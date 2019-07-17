import 'package:dio/dio.dart';
import 'package:justcost/data/ad/post_ad_response.dart';
import 'package:justcost/data/exception/exceptions.dart';
import 'package:justcost/data/user/user_repository.dart';
import 'package:justcost/data/user_sessions.dart';
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
      String title,
      String description,
      int isWholeSale,
      ProgressCallback progressCallback}) async {
    try {
      var response = await _client.post('ads',
          data: {
            'customerId': customerId,
            'cityId': cityId,
            'lng': lng,
            'lat': lat,
            'mobile': mobile,
            'iswholesale': isWholeSale,
            'ad_title': title,
            'ad_description': description
          },
          onSendProgress: progressCallback);

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
}
