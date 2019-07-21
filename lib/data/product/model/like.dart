class LikeResponse {
  bool success;
  Data data;
  String message;

  LikeResponse({this.success, this.data, this.message});

  LikeResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}
class DisLikeResponse {
  bool success;
  bool data;
  String message;

  DisLikeResponse({this.success, this.data, this.message});

  DisLikeResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['data'] = this.data;
    data['message'] = this.message;
    return data;
  }
}

class LikeStatus {
  bool success;
  String message;
  bool liked;

  LikeStatus.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    liked = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    data['data'] = this.liked;
    return data;
  }
}

class Data {
  int productId;
  int customerId;
  String updatedAt;
  String createdAt;
  int id;

  Data(
      {this.productId,
      this.customerId,
      this.updatedAt,
      this.createdAt,
      this.id});

  Data.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    customerId = json['customer_id'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['customer_id'] = this.customerId;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }
}
