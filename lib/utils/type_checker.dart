import 'package:filebytestore/widgets.dart';

class EmailChecker {
  static bool isValid(String keyword, {bool showSnackbar = true}) {
    if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(keyword)) {
      if (showSnackbar) {
        customSnackBar("Given email address is not in a valid format");
      }
      return false;
    }
    return true;
  }
}
