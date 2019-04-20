import 'auth_response.dart';

class UpdateResponse {
  final Payload payload;
  final String message;
  final bool status;

  UpdateResponse(this.payload, this.message, this.status);
  factory UpdateResponse.fromJson(Map<String, dynamic> json) {
    return UpdateResponse(
        Payload.fromJson(json['payload']), json['message'], json['status']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}
