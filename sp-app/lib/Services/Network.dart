import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkHelper {
  final String url = 'https://sp-dbserver.herokuapp.com/';
  var client = http.Client();

  Future postMethod(String api, body) async {
    var response = await client.post(
      Uri.parse('$url$api'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(body),
    );
    var data = response.body;
    print(data);
    return jsonDecode(data);
  }

  Future getMethod(String api) async {
    var response = await http.get(Uri.parse('$url$api'));

    if (response.statusCode == 200) {
      var data = response.body;

      return jsonDecode(data);
    } else {
      print(response.statusCode);
    }
  }
}
