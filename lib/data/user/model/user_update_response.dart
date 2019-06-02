import 'package:justcost/data/user/model/user.dart';

class UserUpdateResponse {
  bool success;
  Data data;
  String message;

  UserUpdateResponse({this.success, this.data, this.message});

  UserUpdateResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    success = json['success'] == null ? data.success : json['success'];
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
  User userInfo;
  bool success;

  Data({this.userInfo, this.success});

  Data.fromJson(Map<String, dynamic> json) {
    userInfo =
        json['user info'] != null ? new User.fromJson(json['user info']) : null;
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.userInfo != null) {
      data['user info'] = this.userInfo.toJson();
    }
    success = data['json'];
    return data;
  }
}
