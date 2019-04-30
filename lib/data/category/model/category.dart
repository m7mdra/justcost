class CategoryResponse {
  String message;
  bool status;
  List<Category> content;

  CategoryResponse({this.message, this.status, this.content});

  CategoryResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    if (json['content'] != null) {
      content = new List<Category>();
      json['content'].forEach((v) {
        content.add(new Category.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    if (this.content != null) {
      data['content'] = this.content.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Category {
  String id;
  String name;
  int lastDescendant;
  String image;
  int order;
  String added;

  Category(
      {this.id,
      this.name,
      this.lastDescendant,
      this.image,
      this.order,
      this.added});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    lastDescendant = json['final'];
    image = json['image'];
    order = json['order'];
    added = json['added'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['final'] = this.lastDescendant;
    data['image'] = this.image;
    data['order'] = this.order;
    data['added'] = this.added;
    return data;
  }
}
