import 'dart:io';

import 'package:justcost/data/category/model/category.dart';
import 'package:justcost/data/city/model/city.dart';

class PostAd {
  final File image;
  final List<File> media;
  final Category category;
  final City city;
  final String description;
  final double salePrice;
  final double regularPrice;
  final int brandId;
  final int isPaid;
  final int isWholeSale;
  final int status;
  final String keyword;
  final String title;

  PostAd(
      {this.image,
      this.media,
      this.category,
      this.city,
      this.description,
      this.salePrice,
      this.regularPrice,
      this.brandId,
      this.isPaid,
      this.isWholeSale,
      this.status,
      this.keyword,
      this.title});
}
class PostAdResponse {
  bool success;
  String message;

  PostAdResponse({this.success, this.message});

  PostAdResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    return data;
  }
}

