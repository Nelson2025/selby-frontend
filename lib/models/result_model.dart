import 'dart:convert';

ResultModel resultModel(String str) => ResultModel.fromJson(jsonDecode(str));

class ResultModel {
  ResultModel({
    this.title,
    this.description,
  });

  late final String? title;
  late final String? description;

  ResultModel.fromJson(Map<String, dynamic> json) {
    title = json['data']['title'];
    description = json['data']['description'];
  }

  // Map<String, dynamic> toMap() {
  //   return <String, dynamic>{

  //     'sId': sId,
  //     'name': name,
  //     'email': email,
  //     'isEmailVerified': isEmailVerified,
  //     'password': password,
  //     'phone': phone,
  //     'isPhoneVerified': isPhoneVerified,
  //     'about': about,
  //     'avatar': avatar,
  //     'address': address,
  //     'city': city,
  //     'state': state,
  //     'pincode': pincode,
  //     'profileProgress': profileProgress,
  //     'id': id,
  //     'updatedOn': updatedOn,
  //     'createdOn': createdOn,
  //   };
  // }

  // factory ResultModel.fromMap(Map<String, dynamic> map) {
  //   return ResultModel(

  //     sId: map['sId'] ?? '',
  //     name: map['name'] ?? '',
  //     email: map['email'] ?? '',
  //     isEmailVerified: map['isEmailVerified'] ?? '',
  //     password: map['password'] ?? '',
  //     phone: map['phone'] ?? '',
  //     isPhoneVerified: map['isPhoneVerified'] ?? '',
  //     about: map['about'] ?? '',
  //     avatar: map['avatar'] ?? '',
  //     address: map['address'] ?? '',
  //     city: map['city'] ?? '',
  //     state: map['state'] ?? '',
  //     pincode: map['pincode'] ?? '',
  //     profileProgress: map['profileProgress'] ?? '',
  //     id: map['_id'] ?? '',
  //     updatedOn: map['updatedOn'] ?? '',
  //     createdOn: map['createdOn'] ?? '',
  //   );
  // }

  // String toJson() => json.encode(toMap());

  // factory ResultModel.fromJson(String source) =>
  //     ResultModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
