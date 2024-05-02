import 'dart:convert';

import 'package:selby/models/category_model.dart';

AutosModel autosModel(String str) => AutosModel.fromJson(jsonDecode(str));

class AutosModel {
  AutosModel({
    this.categoryId,
    this.userId,
    this.brand,
    this.model,
    this.variant,
    this.year,
    this.fuel,
    this.transmission,
    this.kms,
    this.owner,
    this.title,
    this.description,
    this.price,
    this.image,
    this.favourite,
    this.city,
    this.state,
    this.sId,
    this.status,
    this.updatedOn,
    this.createdOn,
  });

  dynamic categoryId;
  String? sId;
  String? userId;
  String? brand;
  String? model;
  String? variant;
  String? year;
  String? fuel;
  String? transmission;
  String? kms;
  String? owner;
  String? title;
  String? description;
  String? price;
  List? image;
  String? favourite;
  String? city;
  String? state;
  bool? status;
  String? updatedOn;
  String? createdOn;

  AutosModel.fromJson(Map<String, dynamic> json) {
    // categoryId = json['data']['categoryId'];
    if (json['categoryId'] != null) {
      categoryId = <CategoryModel>[];
      json['categoryId'].forEach((v) {
        categoryId!.add(new CategoryModel.fromJson(v));
      });
    }
    userId = json['data']['userId'];
    brand = json['data']['brand'];
    model = json['data']['model'];
    variant = json['data']['variant'];
    year = json['data']['year'];
    fuel = json['data']['fuel'];
    transmission = json['data']['transmission'];
    kms = json['data']['kms'];
    owner = json['data']['owner'];
    title = json['data']['title'];
    description = json['data']['description'];
    price = json['data']['price'];
    image = json['data']['image'].cast<String>();
    favourite = json['data']['favourite'];
    city = json['data']['city'];
    state = json['data']['state'];
    sId = json['data']['_id'];
    status = json['data']['status'];
    updatedOn = json['data']['updatedOn'];
    createdOn = json['data']['createdOn'];
  }
}
