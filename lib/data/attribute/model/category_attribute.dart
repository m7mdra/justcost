class CategoryAttributeResponse {
  bool success;
  List<AttributeGroup> attributeGroupList;
  String message;

  CategoryAttributeResponse(
      {this.success, this.attributeGroupList, this.message});

  CategoryAttributeResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      attributeGroupList = new List<AttributeGroup>();
      json['data'].forEach((v) {
        attributeGroupList.add(new AttributeGroup.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.attributeGroupList != null) {
      data['data'] = this.attributeGroupList.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class AttributeGroup {
  String group;
  List<Attribute> attributeList;

  AttributeGroup({this.group, this.attributeList});

  AttributeGroup.fromJson(Map<String, dynamic> json) {
    group = json['group'];
    if (json['attributes'] != null) {
      attributeList = new List<Attribute>();
      json['attributes'].forEach((v) {
        attributeList.add(new Attribute.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['group'] = this.group;
    if (this.attributeList != null) {
      data['attributes'] = this.attributeList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Attribute {
  int id;
  String name;
  int groupId;

  Attribute({
    this.id,
    this.name,
    this.groupId,
  });

  Attribute.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    groupId = json['group_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['group_id'] = this.groupId;
    return data;
  }
}
