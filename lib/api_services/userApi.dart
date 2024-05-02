import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:selby/core/configuration.dart';
import 'package:selby/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserApi {
  static var client = http.Client();

  static Future<UserModel> userAccount(String phone) async {
    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};

    var url =
        Uri.parse('${Configuration.baseUrl}${Configuration.userAccountUrl}');

    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(
        {"phone": phone},
      ),
    );

    print(response.body);

    if (jsonDecode(response.body)['success'] == true) {
      SharedPreferences preferences = await SharedPreferences.getInstance();

      await preferences.setString(
          'phone', jsonDecode(response.body)['data']['phone']);
      await preferences.setString(
          'userId', jsonDecode(response.body)['data']['_id']);
    }
    return userModel(response.body);
  }
}
