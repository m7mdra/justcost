class ProductDeatilsResponse {
  bool success;
  List<ProductDeatils> data;
  String message;

  ProductDeatilsResponse({this.success, this.data, this.message});

  ProductDeatilsResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = new List<ProductDeatils>();
      json['data'].forEach((v) {
        data.add(new ProductDeatils.fromJson(v));
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

class ProductDeatils {
  int customerId;
  String customerName;
  String customerMobile;
  String customerLocation;
  int productId;
  String title;
  String description;
  String location;
  int regPrice;
  int salePrice;
  String city;
  String postedOn;
  double rating;
  String brand;
  String brandImage;
  List<String> media;

  ProductDeatils(
      {this.customerId,
      this.customerName,
      this.customerMobile,
      this.customerLocation,
      this.productId,
      this.title,
      this.description,
      this.location,
      this.regPrice,
      this.salePrice,
      this.city,
      this.postedOn,
      this.rating,
      this.brand,
      this.brandImage,
      this.media});

  ProductDeatils.fromJson(Map<String, dynamic> json) {
    customerId = json['customerId'];
    customerName = json['customerName'];
    customerMobile = json['customerMobile'];
    customerLocation = json['customerLocation'];
    productId = json['productId'];
    title = json['title'];
    description = json['description'];
    location = json['location'];
    regPrice = json['reg_price'];
    salePrice = json['sale_price'];
    city = json['city'];
    postedOn = json['postedOn'];
    rating = json['rating'];
    brand = json['brand'];
    brandImage = json['brand_image'];
    if (json['media'] != null) {
      media =  List();
      json['media'].forEach((v) {
        media.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customerId'] = this.customerId;
    data['customerName'] = this.customerName;
    data['customerMobile'] = this.customerMobile;
    data['customerLocation'] = this.customerLocation;
    data['productId'] = this.productId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['location'] = this.location;
    data['reg_price'] = this.regPrice;
    data['sale_price'] = this.salePrice;
    data['city'] = this.city;
    data['postedOn'] = this.postedOn;
    data['rating'] = this.rating;
    data['brand'] = this.brand;
    data['brand_image'] = this.brandImage;
    if (this.media != null) {
      data['media'] = this.media;
    }
    return data;
  }
}
