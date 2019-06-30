import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:justcost/data/city/model/country.dart';

import 'model/city.dart';

class CityRepository {
  final Dio _client;

  CityRepository(this._client);

  Future<CityResponse> getCites() async {
    try {
      var response = await _client.get('cities');
      return CityResponse.fromJson(response.data);
    } catch (error) {
      throw error;
    }
  }

  Future<Countries> getCountries() async {
    var json = await rootBundle.loadString('assets/countries.json');
    return Countries.fromJson(jsonDecode(json));
  }
}
