import 'package:justcost/data/attribute/model/attribute.dart';

class CategoryResponse {
  String message;
  bool status;
  List<Category> content;

  CategoryResponse({this.message, this.status, this.content});

  CategoryResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['success'];
    if (json['data'] != null) {
      content = new List<Category>();
      json['data'].forEach((v) {
        content.add(new Category.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['success'] = this.status;
    if (this.content != null) {
      data['data'] = this.content.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Category {
  int id;
  String name;
  String arName;
  int lastDescendant;
  String image;
  int order;
  int parentId;
  List<Attribute> attributes;

  Category(
      {this.id,
      this.name,
      this.arName,
      this.lastDescendant,
      this.image,
      this.order,
      this.parentId,
      this.attributes,
      });

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    arName = json['name_ar'];
    lastDescendant = json['flag'];
    image = json['image'];
    order = json['sort_order'];
    parentId = json['parent_id'];
//    if (json['attributes_group'] != null) {
//      attributes = new List<Attribute>();
//      json['attributes_group'].forEach((v) {
//        attributes.add(new Attribute.fromJson(v));
//      });
//    }
  }

  bool hasDescendants() => lastDescendant != 0;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['name_ar'] = this.arName;
    data['flag'] = this.lastDescendant;
    data['image'] = this.image;
    data['sort_order'] = this.order;
    data['parent_id'] = this.parentId;
    if (this.attributes != null) {
      data['attributes_group'] = this.attributes.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
