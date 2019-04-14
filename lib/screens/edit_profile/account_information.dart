class AccountInformation {
  final String username;
  final String email;
  final String currentPassword;

  const AccountInformation(this.username, this.email, {this.currentPassword});
  @override
  String toString() {
    return "password: $username\nemai: $email\ncurrent password: $currentPassword";
  }
}
