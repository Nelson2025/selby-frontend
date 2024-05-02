import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static Future<void> saveUserDetails(
      String phone, bool isPhoneVerified) async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    await instance.setString("phone", phone);
    await instance.setBool("isPhoneVerified", isPhoneVerified);
    log("Details Saved!");
  }

  static Future<Map<String, dynamic>> fetchUserDetails() async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    String? phone = instance.getString("phone");
    String? userId = instance.getString("userId");
    return {"phone": phone, "userId": userId};
  }

  static Future<void> clear() async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    await instance.clear();
  }
}
