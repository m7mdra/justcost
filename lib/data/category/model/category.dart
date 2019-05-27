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
  int lastDescendant;
  String image;
  int order;
  int parentId;

  Category(
      {this.id,
      this.name,
      this.lastDescendant,
      this.image,
      this.order,
      this.parentId});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    lastDescendant = json['flag'];
    image = json['image'];
    order = json['sort_order'];
    parentId = json['parent_id'];
  }

  bool hasDescendants() => lastDescendant != 0;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['flag'] = this.lastDescendant;
    data['image'] = this.image;
    data['sort_order'] = this.order;
    data['parent_id'] = this.parentId;
    return data;
  }
  @override
  String toString() {
    return toJson().toString();
  }
}
