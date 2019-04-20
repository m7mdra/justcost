abstract class Validator<T> {
  bool validate(T value);
}

class EmailValidator extends Validator<String>{
 static  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp _regex =RegExp(pattern);
  @override
  bool validate(String value) {
    return _regex.hasMatch(value);
  }

}