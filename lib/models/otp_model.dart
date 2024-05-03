/*This is the model of OTP*/

import 'dart:convert';

OtpModel otpModel(String str) => OtpModel.fromJson(jsonDecode(str));

class OtpModel {
  OtpModel({
    required this.message,
    required this.hash,
  });

  late final bool? success;
  late final String message;
  late final String? hash;
  late final String? otp;
  late final String? phone;

  OtpModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    hash = json['data']['fullHash'];
    otp = json['data']['otp'];
    phone = json['data']['phone'];
  }
}
