class PersonalInformation {
  final String fullName;
  final bool gender;
  final int city;

  const PersonalInformation(this.fullName, this.gender, this.city);

  @override
  String toString() {
    return "fullName: $fullName\ngender: $gender\naddress: $city";
  }
}
