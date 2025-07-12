import '../Services/Network.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth extends ChangeNotifier {
  String id = '';

  Future<String> login(String id, String pass, bool remember) async {
    NetworkHelper networkHelper = NetworkHelper();

    var response = await networkHelper
        .postMethod('login.php', {"user_id": id, "password": pass});

    print(response);
    this.id = id;
    if (remember) {
      id = response['user_id'];

      final SharedPreferences sharedpref =
          await SharedPreferences.getInstance();
      sharedpref.setString('uid', id);
    }

    return response['code'];
  }

  Future<String> forgotPassword(String email) async {
    NetworkHelper networkHelper = NetworkHelper();

    var response = await networkHelper
        .postMethod('2_forgot_password.php', {"email": email});

    return response['code'];
  }
}
