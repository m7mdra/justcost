class ProductResponse {
  bool success;
  List<Product> data;
  String message;

  ProductResponse({this.success, this.data, this.message});

  ProductResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = new List<Product>();
      json['data'].forEach((v) {
        data.add(new Product.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class Product {
  int productId;
  String title;
  String category;
  int customerId;
  String customerName;
  String description;
  String mobile;
  String location;
  int regPrice;
  int salePrice;
  String city;
  String brand;
  List<Comments> comments;
  List<Media> media;
  String postedOn;

  Product(
      {this.productId,
      this.title,
      this.category,
      this.customerId,
      this.customerName,
      this.description,
      this.mobile,
      this.location,
      this.regPrice,
      this.salePrice,
      this.city,
      this.brand,
      this.comments,
      this.media,
      this.postedOn});

  Product.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    title = json['title'];
    category = json['category'];
    customerId = json['customerId'];
    customerName = json['customerName'];
    description = json['description'];
    mobile = json['mobile'];
    location = json['location'];
    regPrice = json['reg_price'];
    salePrice = json['sale_price'];
    city = json['city'];
    brand = json['brand'];
    if (json['comments'] != null) {
      comments = new List<Comments>();
      json['comments'].forEach((v) {
        comments.add(new Comments.fromJson(v));
      });
    }
    if (json['media'] != null) {
      media = new List<Media>();
      json['media'].forEach((v) {
        media.add(new Media.fromJson(v));
      });
    }
    postedOn = json['postedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productId'] = this.productId;
    data['title'] = this.title;
    data['category'] = this.category;
    data['customerId'] = this.customerId;
    data['customerName'] = this.customerName;
    data['description'] = this.description;
    data['mobile'] = this.mobile;
    data['location'] = this.location;
    data['reg_price'] = this.regPrice;
    data['sale_price'] = this.salePrice;
    data['city'] = this.city;
    data['brand'] = this.brand;
    if (this.comments != null) {
      data['comments'] = this.comments.map((v) => v.toJson()).toList();
    }
    if (this.media != null) {
      data['media'] = this.media.map((v) => v.toJson()).toList();
    }
    data['postedOn'] = this.postedOn;
    return data;
  }
}

class Comments {
  int id;
  int parentId;
  int productid;
  int userId;
  String comment;
  String date;
  String createdAt;
  String updatedAt;
  String deletedAt;

  Comments(
      {this.id,
      this.parentId,
      this.productid,
      this.userId,
      this.comment,
      this.date,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  Comments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parentId = json['parent_id'];
    productid = json['productid'];
    userId = json['userId'];
    comment = json['comment'];
    date = json['date'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['parent_id'] = this.parentId;
    data['productid'] = this.productid;
    data['userId'] = this.userId;
    data['comment'] = this.comment;
    data['date'] = this.date;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}

class Media {
  int id;
  int productId;
  String url;
  int flag;
  String type;

  Media({this.id, this.productId, this.url, this.flag, this.type});

  Media.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    url = json['url'];
    flag = json['flag'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_id'] = this.productId;
    data['url'] = this.url;
    data['flag'] = this.flag;
    data['type'] = this.type;
    return data;
  }
}
