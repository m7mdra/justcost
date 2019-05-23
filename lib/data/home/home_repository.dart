import 'package:dio/dio.dart';
import 'package:justcost/data/home/%20model/slider_response.dart';

class HomeRepository {
  final Dio _client;

  HomeRepository(this._client);

  Future<SliderResponse> getHomeSlider() async {
    try {
      var response = await _client.get('sliders');
      return SliderResponse.fromJson(response.data);
    } on DioError catch (error) {
      throw error;
    } catch (err) {
      throw err;
    }
  }
}
