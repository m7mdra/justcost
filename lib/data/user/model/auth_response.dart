class AuthenticationResponse {
  bool success;
  Data data;
  String message;

  AuthenticationResponse({this.success, this.data, this.message});

  AuthenticationResponse.fromJson(Map<String, dynamic> json) {
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
  String token;
  Payload payload;

  Data({this.token, this.payload});

  Data.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    payload = json['userInfo'] != null
        ? new Payload.fromJson(json['userInfo'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    if (this.payload != null) {
      data['userInfo'] = this.payload.toJson();
    }
    return data;
  }
}

class Payload {
  int id;
  String email;
  String username;
  String name;
  String mobile;
  int city;
  int gender;
  bool isVerified;
  String firebaseToken;
  String createdAt;
  String updatedAt;
  String deletedAt;

  Payload(
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

  Payload.fromJson(Map<String, dynamic> json) {
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
