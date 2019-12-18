import 'package:justcost/data/product/model/product.dart';

class MyAdsResponse {
  bool success;
  List<Ad> ads;
  String message;

  MyAdsResponse({this.success, this.ads, this.message});

  MyAdsResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      ads = new List<Ad>();
      json['data'].forEach((v) {
        ads.add(new Ad.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.ads != null) {
      data['data'] = this.ads.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class Ad {
  int id;
  String adTitle;
  String adDescription;
  String mobile;
  int customerId;
  int cityId;
  String cityName;
  String cityNameAr;
  ///1 pending
  ///2 rejected
  ///3 approved
  int status;
  int approvedBy;
  String lat;
  String lng;
  bool iswholesale;
  String deletedAt;
  String createdAt;
  String updatedAt;
  List<Product> products;

  Ad(
      {this.id,
        this.adTitle,
        this.adDescription,
        this.mobile,
        this.customerId,
        this.cityId,
        this.cityName,
        this.cityNameAr,
        this.status,
        this.approvedBy,
        this.lat,
        this.lng,
        this.iswholesale,
        this.deletedAt,
        this.createdAt,
        this.updatedAt,
        this.products
      });

  Ad.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    adTitle = json['ad_title'];
    adDescription = json['ad_description'];
    mobile = json['mobile'];
    customerId = json['customerId']['id'];
    if(json['cityId'] != null){
      cityId = json['cityId']['id'];
      cityName = json['cityId']['name'];
      cityNameAr = json['cityId']['arName'];
    }
    status = json['status']['id'];
    approvedBy = json['approved_by'];
    lat = json['lat'];
    lng = json['lng'];
    iswholesale = json['iswholesale'];
    if (json['products'] != null) {
      products = new List<Product>();
      json['products'].forEach((v) {
        products.add(new Product.fromJson(v));
      });
    }
//    deletedAt = json['deleted_at'];
//    createdAt = json['created_at'];
//    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['ad_title'] = this.adTitle;
    data['ad_description'] = this.adDescription;
    data['mobile'] = this.mobile;
    data['customerId'] = this.customerId;
    data['cityId']['id'] = this.cityId;
    data['cityId']['name'] = this.cityName;
    data['cityId']['arName'] = this.cityNameAr;
    data['status'] = this.status;
    data['approved_by'] = this.approvedBy;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['iswholesale'] = this.iswholesale;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.products != null) {
      data['products'] = this.products.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
