class AttributeResponse {
  bool success;
  List<Attribute> attributes;
  String message;

  AttributeResponse({this.success, this.attributes, this.message});

  AttributeResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      attributes = new List<Attribute>();
      json['data'].forEach((v) {
        attributes.add(new Attribute.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.attributes != null) {
      data['data'] = this.attributes.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class Attribute {
  String group;
  String val;

  Attribute({this.group, this.val});

  Attribute.fromJson(Map<String, dynamic> json) {
    group = json['group'];
    val = json['attributes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['group'] = this.group;
    data['attributes'] = this.val;
    return data;
  }
}
