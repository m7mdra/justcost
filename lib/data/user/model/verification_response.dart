class VerificationResponse {
  bool success;
  Data data;
  String message;

  VerificationResponse({this.success, this.data, this.message});

  VerificationResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['Message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['Message'] = this.message;
    return data;
  }
}

class Data {
  int id;
  String email;
  String username;
  String name;
  String mobile;
  int city;
  bool gender;
  bool isVerified;
  String firebaseToken;
  String createdAt;
  String updatedAt;
  String deletedAt;

  Data(
      {this.id,
      this.email,
      this.username,
      this.name,
      this.mobile,
      this.city,
      this.gender,
      this.isVerified,
      this.firebaseToken,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    username = json['username'];
    name = json['name'];
    mobile = json['mobile'];
    city = json['city'];
    gender = json['gender'];
    isVerified = json['isVerified'];
    firebaseToken = json['firebaseToken'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['username'] = this.username;
    data['name'] = this.name;
    data['mobile'] = this.mobile;
    data['city'] = this.city;
    data['gender'] = this.gender;
    data['isVerified'] = this.isVerified;
    data['firebaseToken'] = this.firebaseToken;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}
