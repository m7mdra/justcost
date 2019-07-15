import 'package:justcost/data/city/model/city.dart';
import 'package:justcost/data/city/model/country.dart';

class PersonalInformation {
  final String fullName;
  final int gender;
  final City city;

  const PersonalInformation(this.fullName, this.gender, this.city);

  @override
  String toString() {
    return "fullName: $fullName\ngender: $gender\naddress: $city";
  }
}
