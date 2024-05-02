import 'dart:convert';

import 'package:selby/models/category_model.dart';

ProductModel productModel(String str) => ProductModel.fromJson(jsonDecode(str));

class ProductModel {
  String? sId;
  dynamic categoryId;
  String? subcategoryId;
  String? userId;
  List? features;
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
  int? iV;

  ProductModel(
      {this.sId,
      this.categoryId,
      this.subcategoryId,
      this.userId,
      this.features,
      this.title,
      this.description,
      this.price,
      this.image,
      this.favourite,
      this.city,
      this.state,
      this.status,
      this.updatedOn,
      this.createdOn,
      this.iV});

  ProductModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    if (json['categoryId'] != null) {
      categoryId = <CategoryModel>[];
      json['categoryId'].forEach((v) {
        categoryId!.add(new CategoryModel.fromJson(v));
      });
    }
    subcategoryId = json['subcategoryId'];
    userId = json['userId'];
    features = json['features'].cast<String>();
    title = json['title'];
    description = json['description'];
    price = json['price'];
    image = json['image'].cast<String>();
    favourite = json['favourite'];
    city = json['city'];
    state = json['state'];
    status = json['status'];
    updatedOn = json['updatedOn'];
    createdOn = json['createdOn'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['categoryId'] = this.categoryId;
    data['subcategoryId'] = this.subcategoryId;
    data['userId'] = this.userId;
    data['features'] = this.features;
    data['title'] = this.title;
    data['description'] = this.description;
    data['price'] = this.price;
    data['image'] = this.image;
    data['favourite'] = this.favourite;
    data['city'] = this.city;
    data['state'] = this.state;
    data['status'] = this.status;
    data['updatedOn'] = this.updatedOn;
    data['createdOn'] = this.createdOn;
    data['__v'] = this.iV;
    return data;
  }
}
