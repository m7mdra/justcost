class RegisterErrorResponse {
  Response response;

  RegisterErrorResponse({this.response});

  RegisterErrorResponse.fromJson(Map<String, dynamic> json) {
    response =
        json['data'] != null ? new Response.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.response != null) {
      data['data'] = this.response.toJson();
    }
    return data;
  }
}

class Response {
  ValidationError validationError;

  Response({this.validationError});

  Response.fromJson(Map<String, dynamic> json) {
    validationError = json['Validation Error'] != null
        ? new ValidationError.fromJson(json['Validation Error'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.validationError != null) {
      data['Validation Error'] = this.validationError.toJson();
    }
    return data;
  }
}

class ValidationError {
  List<String> name;
  List<String> username;
  List<String> email;
  List<String> password;
  List<String> cPassword;
  List<String> mobile;
  List<String> city;
  List<String> firebaseToken;

  ValidationError(
      {this.name,
      this.username,
      this.email,
      this.password,
      this.cPassword,
      this.mobile,
      this.city,
      this.firebaseToken});

  ValidationError.fromJson(Map<String, dynamic> json) {
    name = json['name'] != null ? json['name'].cast<String>() : null;
    username =
        json['username'] != null ? json['username'].cast<String>() : null;
    email = json['email'] != null ? json['email'].cast<String>() : null;
    password = json['password'] ? json['password'].cast<String>() : null;
    cPassword = json['c_password'] ? json['c_password'].cast<String>() : null;
    mobile = json['mobile'] ? json['mobile'].cast<String>() : null;
    city = json['city'] ? json['city'].cast<String>() : null;
    firebaseToken =
        json['firebaseToken'] ? json['firebaseToken'].cast<String>() : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['username'] = this.username;
    data['email'] = this.email;
    data['password'] = this.password;
    data['c_password'] = this.cPassword;
    data['mobile'] = this.mobile;
    data['city'] = this.city;
    data['firebaseToken'] = this.firebaseToken;
    return data;
  }
}
