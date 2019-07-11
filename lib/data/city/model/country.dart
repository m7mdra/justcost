class Countries {
  List<Country> data;

  Countries({this.data});

  Countries.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<Country>();
      json['data'].forEach((v) {
        data.add(new Country.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Country {
  int id;
  String name;
  String arName;
  String code;
  List<City> cities;

  Country({this.id, this.name, this.arName, this.code, this.cities});

  Country.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    arName = json['arName'];
    code = json['code'];
    if (json['cities'] != null) {
      cities = new List<City>();
      json['cities'].forEach((v) {
        cities.add(new City.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['arName'] = this.arName;
    data['code'] = this.code;
    if (this.cities != null) {
      data['cities'] = this.cities.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    return 'Country{id: $id, name: $name, arName: $arName, code: $code, cities: $cities}';
  }

}

class City {
  int id;
  String name;
  String arName;
  int countryId;

  City({this.id, this.name, this.arName, this.countryId});

  City.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    arName = json['arName'];
    countryId = json['countryId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['arName'] = this.arName;
    data['countryId'] = this.countryId;
    return data;
  }

  @override
  String toString() {
    return 'City{id: $id, name: $name, arName: $arName, countryId: $countryId}';
  }

}
