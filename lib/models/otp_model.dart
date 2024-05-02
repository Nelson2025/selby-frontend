// import 'dart:convert';

// class OtpModel {
//   String? fullHash;
//   String? otp;

//   String? phone;

//   OtpModel({
//     this.fullHash,
//     this.otp,
//     this.phone,
//   });

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'fullHash': fullHash,
//       'otp': otp,
//       'phone': phone,
//     };
//   }

//   factory OtpModel.fromMap(Map<String, dynamic> map) {
//     return OtpModel(
//       fullHash: map['fullHash'] ?? '',
//       otp: map['otp'] ?? '',
//       phone: map['phone'] ?? '',
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory OtpModel.fromJson(String source) =>
//       OtpModel.fromMap(json.decode(source) as Map<String, dynamic>);
// }

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
