/*This is the model of User*/
import 'dart:convert';

UserModel userModel(String str) => UserModel.fromJson(jsonDecode(str));

class UserModel {
  UserModel(
      {this.sId,
      this.name,
      this.email,
      this.isEmailVerified,
      this.password,
      this.phone,
      this.isPhoneVerified,
      this.about,
      this.avatar,
      this.address,
      this.city,
      this.state,
      this.pincode,
      this.profileProgress,
      this.id,
      this.updatedOn,
      this.createdOn});

  late final String? sId;
  late final String? name;
  late final String? email;
  late final bool? isEmailVerified;
  late final String? password;
  late final String? phone;
  late final bool? isPhoneVerified;
  late final String? about;
  late final String? avatar;
  late final String? address;
  late final String? city;
  late final String? state;
  late final String? pincode;
  late final int? profileProgress;
  late final String? id;
  late final String? updatedOn;
  late final String? createdOn;

  UserModel.fromJson(Map<String, dynamic> json) {
    sId = json['data']['_id'];
    name = json['data']['name'];
    email = json['data']['email'];
    isEmailVerified = json['data']['isEmailVerified'];
    password = json['data']['password'];
    phone = json['data']['phone'];
    isPhoneVerified = json['data']['isPhoneVerified'];
    about = json['data']['about'];
    avatar = json['data']['avatar'];
    address = json['data']['address'];
    city = json['data']['city'];
    state = json['data']['state'];
    pincode = json['data']['pincode'];
    profileProgress = json['data']['profileProgress'];
    id = json['data']['id'];
    updatedOn = json['data']['updatedOn'];
    createdOn = json['data']['createdOn'];
  }
}
