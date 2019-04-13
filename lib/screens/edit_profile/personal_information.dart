class PersonalInformation {
  final String fullName;
  final String gender;
  final String address;

  const PersonalInformation(this.fullName, this.gender, this.address);

  @override
  String toString() {
    return "fullName: $fullName\ngender: $gender\naddress: $address";
  }
}
