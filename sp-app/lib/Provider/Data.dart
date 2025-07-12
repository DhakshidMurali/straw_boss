import 'package:shared_preferences/shared_preferences.dart';

import '../Services/Network.dart';
import 'package:flutter/cupertino.dart';

class Data extends ChangeNotifier {
  var data = [];

  String id = '';

  Future<dynamic> login(body) async {
    NetworkHelper networkHelper = NetworkHelper();

    var response = await networkHelper.postMethod('auth/login', body);

    print(response);
    if (response['code'] == "500") return response;
    print('asd');
    this.id = response['id'];

    final SharedPreferences sharedpref = await SharedPreferences.getInstance();
    sharedpref.setString('id', response['id']);
    sharedpref.setString('email', response['email']);
    sharedpref.setString('name', response['name']);
    sharedpref.setString('role', response['role']);
    if (response['role'] == 'staff') {
      List<String> classes = [];
      for (int i = 0; i < response['class'].length; i++) {
        classes.add(response['class'][i]);
      }
      sharedpref.setStringList('classes', classes);
    } else {
      sharedpref.setString('class', response['class']);
    }
    return response;
  }

  Future<void> getWorks() async {
    final SharedPreferences sharedpref = await SharedPreferences.getInstance();
    NetworkHelper networkHelper = NetworkHelper();
    var response;
    print(sharedpref.getString('role'));
    if (sharedpref.getString('role') == 'staff') {
      response = await networkHelper.postMethod('work/get-works',
          {"role": "staff", "id": sharedpref.getString('id'), "class": ""});
    } else {
      response = await networkHelper.postMethod('work/get-works', {
        "role": "student",
        "id": sharedpref.getString('id'),
        "class": sharedpref.getString('class')
      });
    }
    print(sharedpref.getString('class'));
    if (response['data'] != null) {
      this.data = new List.from(response['data'].reversed);
    }
  }

  Future<List> getMaterialBySuject(body) async {
    NetworkHelper networkHelper = NetworkHelper();
    var response =
        await networkHelper.postMethod('material/get-materials', body);
    if (response['data'] != null) {
      return response['data'];
    }
    return [];
  }

  Future<List> addMaterialBySuject(body) async {
    NetworkHelper networkHelper = NetworkHelper();
    var response =
        await networkHelper.postMethod('material/add-material', body);
    if (response['data'] != null) {
      return response['data'];
    }
    return [];
  }

  Future<dynamic> addWork(body) async {
    print(body);
    NetworkHelper networkHelper = NetworkHelper();
    var response = await networkHelper.postMethod('work/create-work', body);
    print(response);
    return response;
  }

  Future<dynamic> updateMaterialStatus(body) async {
    print(body);
    NetworkHelper networkHelper = NetworkHelper();
    var response = await networkHelper.postMethod('material/edit-status', body);
    print(response);
    return response;
  }

  Future<dynamic> completeWork(body) async {
    print(body);
    NetworkHelper networkHelper = NetworkHelper();
    var response = await networkHelper.postMethod('work/complete-work', body);
    print(response);
    return response;
  }

  Future<dynamic> sendMail(body) async {
    print(body);
    NetworkHelper networkHelper = NetworkHelper();
    var response = await networkHelper.postMethod('work/send-mail', body);
    print(response);
    return response;
  }

  Future<String> linkGoogle(body) async {
    print(body);
    NetworkHelper networkHelper = NetworkHelper();
    var response = await networkHelper.postMethod('auth/link-google', body);
    print(response);
    return response['code'];
  }

  Future<dynamic> loginGoogle(body) async {
    print(body);
    NetworkHelper networkHelper = NetworkHelper();
    var response = await networkHelper.postMethod('auth/login-google', body);
    print(response);
    if (response['code'] == "500") return response;

    this.id = response['id'];
    final SharedPreferences sharedpref = await SharedPreferences.getInstance();

    sharedpref.setString('id', response['id']);
    sharedpref.setString('email', response['email']);
    sharedpref.setString('name', response['name']);
    sharedpref.setString('role', response['role']);
    if (response['role'] == 'staff') {
      List<String> classes = [];
      for (int i = 0; i < response['class'].length; i++) {
        classes.add(response['class'][i]);
      }
      sharedpref.setStringList('classes', classes);
    } else {
      sharedpref.setString('class', response['class']);
    }
    return response;
  }

  Future<dynamic> changePassword(body) async {
    print(body);
    NetworkHelper networkHelper = NetworkHelper();
    var response = await networkHelper.postMethod('auth/change-password', body);
    print(response);
    return response;
  }

  Future<dynamic> getUserByNumber(body) async {
    print(body);
    NetworkHelper networkHelper = NetworkHelper();
    var response = await networkHelper.postMethod('auth/get-user', body);
    print(response);
    return response;
  }
}
