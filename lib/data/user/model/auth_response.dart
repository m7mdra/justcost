class AuthenticationResponse {
  String message;
  Content content;
  bool status;

  AuthenticationResponse({this.message, this.content, this.status});

  AuthenticationResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    content =
        json['content'] != null ? new Content.fromJson(json['content']) : null;
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.content != null) {
      data['content'] = this.content.toJson();
    }
    data['status'] = this.status;
    return data;
  }

  @override
  String toString() {
    return toJson().toString();
  }

  bool isAccountVerified() => content.payload.accountStatus == 1;
}

class Content {
  String token;
  Payload payload;

  Content({this.token, this.payload});

  Content.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    payload =
        json['payload'] != null ? new Payload.fromJson(json['payload']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    if (this.payload != null) {
      data['payload'] = this.payload.toJson();
    }
    return data;
  }

  @override
  String toString() {
    return toJson().toString();
  }
}

class Payload {
  String uid;
  String fullName;
  String gender;
  String email;
  String username;
  String photo;
  String msgTokenId;
  int accountStatus;
  int notBefore;
  int expiration;

  Payload(
      {this.uid,
      this.fullName,
      this.gender,
      this.email,
      this.username,
      this.photo,
      this.msgTokenId,
      this.accountStatus,
      this.notBefore,
      this.expiration});

  Payload.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    fullName = json['full_name'];
    gender = json['gender'];
    email = json['email'];
    username = json['username'];
    photo = json['photo'];
    msgTokenId = json['msg_token_id'];
    accountStatus = json['account_status'];
    notBefore = json['notBefore'];
    expiration = json['Expiration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['full_name'] = this.fullName;
    data['gender'] = this.gender;
    data['email'] = this.email;
    data['username'] = this.username;
    data['photo'] = this.photo;
    data['msg_token_id'] = this.msgTokenId;
    data['account_status'] = this.accountStatus;
    data['notBefore'] = this.notBefore;
    data['Expiration'] = this.expiration;
    return data;
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
