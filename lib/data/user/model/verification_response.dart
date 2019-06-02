import 'package:justcost/data/user/model/user.dart';

class VerificationResponse {
  bool success;
  User data;
  String message;

  VerificationResponse({this.success, this.data, this.message});

  VerificationResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new User.fromJson(json['data']) : null;
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
