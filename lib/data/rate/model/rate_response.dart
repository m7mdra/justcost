class RateResponse {
  bool success;
  Rate rate;
  String message;

  RateResponse({this.success, this.rate, this.message});

  RateResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    rate = json['data'] != null ? new Rate.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.rate != null) {
      data['data'] = this.rate.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class Rate {
  int rate;
  int count;

  Rate({this.rate, this.count});

  Rate.fromJson(Map<String, dynamic> json) {
    rate = json['rate'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rate'] = this.rate;
    data['count'] = this.count;
    return data;
  }
}
