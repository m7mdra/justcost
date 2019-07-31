class RegisterErrorResponse {
  Error error;

  RegisterErrorResponse({this.error});

  RegisterErrorResponse.fromJson(Map<String, dynamic> json) {
    error = json['data'] != null ? new Error.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.error != null) {
      data['data'] = this.error.toJson();
    }
    return data;
  }
}

class Error {
  ValidationError validationError;

  Error({this.validationError});

  Error.fromJson(Map<String, dynamic> json) {
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
      {this.name = const [],
      this.username = const [],
      this.email = const [],
      this.password = const [],
      this.cPassword = const [],
      this.mobile = const [],
      this.city = const [],
      this.firebaseToken = const []});

  ValidationError.fromJson(Map<String, dynamic> json) {
    if (json['name']!=null) name = json['name'].cast<String>();
    if (json['username']!=null) username = json['username'].cast<String>();
    if (json['email']!=null) email = json['email'].cast<String>();

    if (json['password']!=null)password = json['password'].cast<String>();
    if (json['c_password']!=null) cPassword = json['c_password'].cast<String>();
    if (json['mobile']!=null) mobile = json['mobile'].cast<String>();
    if (json['city']!=null) city = json['city'].cast<String>();
    if (json['firebaseToken']!=null) firebaseToken = json['firebaseToken'].cast<String>();
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
