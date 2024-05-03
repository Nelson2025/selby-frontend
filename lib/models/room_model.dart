/*This is the model of Room for messaging*/
import 'dart:convert';

import './user_model.dart';

RoomModel roomModel(String str) => RoomModel.fromJson(jsonDecode(str));

class RoomModel {
  String? sId;
  List? users;
  dynamic results;
  dynamic senderDetails;
  dynamic receiverDetails;
  String? msgStatus;
  String? lastUser;
  String? createdAt;
  String? updatedAt;
  int? iV;

  RoomModel(
      {this.sId,
      this.users,
      this.results,
      this.senderDetails,
      this.receiverDetails,
      this.msgStatus,
      this.lastUser,
      this.createdAt,
      this.updatedAt,
      this.iV});

  RoomModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'] ?? '';
    if (json['users'] != null) {
      users = <UserModel>[];
      json['users'].forEach((v) {
        users!.add(new UserModel.fromJson(v));
      });
    }
    if (json['senderDetails'] != null) {
      senderDetails = <UserModel>[];
      json['senderDetails'].forEach((v) {
        senderDetails!.add(new UserModel.fromJson(v));
      });
    }
    if (json['receiverDetails'] != null) {
      receiverDetails = <UserModel>[];
      json['receiverDetails'].forEach((v) {
        receiverDetails!.add(new UserModel.fromJson(v));
      });
    }
    msgStatus = json['msgStatus'];
    lastUser = json['lastUser'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.users != null) {
      data['users'] = this.users!.map((v) => v.toJson()).toList();
    }
    if (this.results != null) {
      data['results'] = this.results!.map((v) => v.toJson()).toList();
    }
    data['msgStatus'] = this.msgStatus;
    data['lastUser'] = this.lastUser;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
