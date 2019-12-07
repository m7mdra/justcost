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

  Ad(
      {this.id,
        this.adTitle,
        this.adDescription,
        this.mobile,
        this.customerId,
        this.cityId,
        this.status,
        this.approvedBy,
        this.lat,
        this.lng,
        this.iswholesale,
        this.deletedAt,
        this.createdAt,
        this.updatedAt});

  Ad.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    adTitle = json['ad_title'];
    adDescription = json['ad_description'];
    mobile = json['mobile'];
    customerId = json['customerId']['id'];
    cityId = json['cityId']['id'];
    status = json['status']['id'];
    approvedBy = json['approved_by'];
    lat = json['lat'];
    lng = json['lng'];
    iswholesale = json['iswholesale'];
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
    data['cityId'] = this.cityId;
    data['status'] = this.status;
    data['approved_by'] = this.approvedBy;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['iswholesale'] = this.iswholesale;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
