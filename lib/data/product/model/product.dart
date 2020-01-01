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
  String categoryAr;
  int customerId;
  String customerName;
  String description;
  String mobile;
  String location;
  int regPrice;
  int salePrice;
  String city;
  String cityAr;
  String brand;
  dynamic rating;
  List<Media> media;
  List<Attributes> attributes;
  int postedOn;

  Product(
      {this.productId,
      this.title,
      this.category,
      this.categoryAr,
      this.customerId,
      this.customerName,
      this.description,
      this.mobile,
      this.location,
      this.regPrice,
      this.salePrice,
      this.city,
      this.cityAr,
      this.brand,
      this.rating,
      this.media,
      this.postedOn,
      this.attributes
      });

  Product.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    title = json['title'];
    category = json['category']['name'];
    categoryAr = json['category']['name_ar'];
    customerId = json['customerId'];
    customerName = json['customerName'];
    description = json['description'];
    mobile = json['mobile'];
    location = json['location']['long'] + json['location']['lat'];
    regPrice = json['reg_price'];
    salePrice = json['sale_price'];
    if(json['city'] != null){
      city = json['city']['name'];
      cityAr = json['city']['arName'];
    }
    brand = json['brand']['name'];

    rating = json['ratings'];

    if (json['media'] != null) {
      media = new List<Media>();
      json['media'].forEach((v) {
        media.add(new Media.fromJson(v));
      });
    }
    postedOn = json['postedOn'];

    if (json['attributes'] != null) {
      attributes = new List<Attributes>();
      json['attributes'].forEach((v) {
        attributes.add(new Attributes.fromJson(v));
      });
    }
  }
  int calculateDiscount() {
    var discount = ((regPrice - salePrice) / regPrice * 100).round();
    print(discount);
    return discount;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productId'] = this.productId;
    data['title'] = this.title;
    data['category']['name'] = this.category;
    data['category']['name_ar'] = this.categoryAr;
    data['customerId'] = this.customerId;
    data['customerName'] = this.customerName;
    data['description'] = this.description;
    data['mobile'] = this.mobile;
    data['location'] = this.location;
    data['reg_price'] = this.regPrice;
    data['sale_price'] = this.salePrice;
    data['city']['name'] = this.city;
    data['city']['arName'] = this.city;
    data['brand']['name'] = this.brand;
    data['ratings'] = this.rating;

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
  int productId;
  int userId;
  String comment;
  String date;
  String createdAt;
  String updatedAt;
  String deletedAt;

  Comments(
      {this.id,
      this.parentId,
      this.productId,
      this.userId,
      this.comment,
      this.date,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  Comments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parentId = json['parent_id'];
    productId = json['productid'];
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
    data['productid'] = this.productId;
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

class Attributes {
  int id;
  ProductAttribute attribute;
  AttributesGroup attributesGroup;
  int productId;
  String value;

  Attributes(
      {this.id,
        this.attribute,
        this.attributesGroup,
        this.productId,
        this.value});

  Attributes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    attribute = json['attribute'] != null
        ? new ProductAttribute.fromJson(json['attribute'])
        : null;
    attributesGroup = json['attributes_group'] != null
        ? new AttributesGroup.fromJson(json['attributes_group'])
        : null;
    productId = json['product_id'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.attribute != null) {
      data['attribute'] = this.attribute.toJson();
    }
    if (this.attributesGroup != null) {
      data['attributes_group'] = this.attributesGroup.toJson();
    }
    data['product_id'] = this.productId;
    data['value'] = this.value;
    return data;
  }
}

class ProductAttribute {
  int id;
  String name;
  int groupId;
  String createdAt;
  String deletedAt;
  String updatedAt;

  ProductAttribute(
      {this.id,
        this.name,
        this.groupId,
        this.createdAt,
        this.deletedAt,
        this.updatedAt});

  ProductAttribute.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    groupId = json['group_id'];
    createdAt = json['created_at'];
    deletedAt = json['deleted_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['group_id'] = this.groupId;
    data['created_at'] = this.createdAt;
    data['deleted_at'] = this.deletedAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class AttributesGroup {
  int id;
  String name;
  String nameAr;
  int categoryId;
  String createdAt;
  String deletedAt;
  String updatedAt;

  AttributesGroup(
      {this.id,
        this.name,
        this.nameAr,
        this.categoryId,
        this.createdAt,
        this.deletedAt,
        this.updatedAt});

  AttributesGroup.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    nameAr = json['name_ar'];
    categoryId = json['category_id'];
    createdAt = json['created_at'];
    deletedAt = json['deleted_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['name_ar'] = this.nameAr;
    data['category_id'] = this.categoryId;
    data['created_at'] = this.createdAt;
    data['deleted_at'] = this.deletedAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}