class PostCommentResponse {
  bool success;
  Data data;
  String message;

  PostCommentResponse({this.success, this.data, this.message});

  PostCommentResponse.fromJson(Map<String, dynamic> json) {
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

class Data {
  int productid;
  String comment;
  int userId;
  String updatedAt;
  String createdAt;
  int id;
  bool rated;

  Data(
      {this.productid,
        this.comment,
        this.userId,
        this.updatedAt,
        this.createdAt,
        this.id,
        this.rated});

  Data.fromJson(Map<String, dynamic> json) {
    productid = json['productid'];
    comment = json['comment'];
    userId = json['userId'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
    rated = json['rated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productid'] = this.productid;
    data['comment'] = this.comment;
    data['userId'] = this.userId;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    data['rated'] = this.rated;
    return data;
  }
}
