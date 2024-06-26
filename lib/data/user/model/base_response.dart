class ResponseStatus {
  final String message;
  final bool status;

  ResponseStatus(this.message, this.status);

  factory ResponseStatus.fromJson(Map<String, dynamic> json) {
    return ResponseStatus(json['message'], json['success']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['success'] = this.status;
    return data;
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
