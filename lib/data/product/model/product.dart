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
  int customerId;
  String customerName;
  String description;
  String mobile;
  String location;
  int regPrice;
  int salePrice;
  String city;
  int postedOn;
  bool isFavorite;

  Product(
      {this.productId,
      this.title,
      this.customerId,
      this.customerName,
      this.description,
      this.mobile,
      this.location,
      this.regPrice,
      this.salePrice,
      this.city,
      this.postedOn,
      this.isFavorite});

  Product.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    title = json['title'];
    customerId = json['customerId'];
    customerName = json['customerName'];
    description = json['description'];
    mobile = json['mobile'];
    location = json['location'];
    regPrice = json['reg_price'];
    salePrice = json['sale_price'];
    city = json['city'];
    postedOn = json['postedOn'];
    isFavorite = json['isFavorite'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productId'] = this.productId;
    data['title'] = this.title;
    data['customerId'] = this.customerId;
    data['customerName'] = this.customerName;
    data['description'] = this.description;
    data['mobile'] = this.mobile;
    data['location'] = this.location;
    data['reg_price'] = this.regPrice;
    data['sale_price'] = this.salePrice;
    data['city'] = this.city;
    data['postedOn'] = this.postedOn;
    data['isFavorite'] = this.isFavorite;
    return data;
  }
}
