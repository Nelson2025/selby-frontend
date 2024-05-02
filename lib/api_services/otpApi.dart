import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:selby/core/configuration.dart';
import 'package:selby/models/otp_model.dart';

class OtpApi {
  static var client = http.Client();

  static Future<OtpModel> createOtp(String phone) async {
    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};

    var url =
        Uri.parse('${Configuration.baseUrl}${Configuration.createOtpUrl}');

    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(
        {"phone": phone},
      ),
    );

    return otpModel(response.body);
  }

  static Future<OtpModel> verifyOtp(
      String phone, String hash, String otp) async {
    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};

    var url =
        Uri.parse('${Configuration.baseUrl}${Configuration.verifyOtpUrl}');

    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(
        {"phone": phone, "otp": otp, "hash": hash},
      ),
    );

    return otpModel(response.body);
  }
}
