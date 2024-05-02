import 'dart:convert';

import 'package:selby/models/category_model.dart';

PropertiesModel propertiesModel(String str) =>
    PropertiesModel.fromJson(jsonDecode(str));

class PropertiesModel {
  String? sId;
  dynamic categoryId;
  String? subcategoryId;
  String? userId;
  List? features;
  String? type;
  String? bedrooms;
  String? bathrooms;
  String? furnishing;
  String? constructionStatus;
  String? listedBy;
  String? superBuiltupArea;
  String? carpetArea;
  String? maintenanceMonthly;
  String? totalFloors;
  String? floorNo;
  String? carParking;
  String? facing;
  String? projectName;
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

  PropertiesModel(
      {this.sId,
      this.categoryId,
      this.subcategoryId,
      this.userId,
      this.features,
      this.type,
      this.bedrooms,
      this.bathrooms,
      this.furnishing,
      this.constructionStatus,
      this.listedBy,
      this.superBuiltupArea,
      this.carpetArea,
      this.maintenanceMonthly,
      this.totalFloors,
      this.floorNo,
      this.carParking,
      this.facing,
      this.projectName,
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

  PropertiesModel.fromJson(Map<String, dynamic> json) {
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
    type = json['type'];
    bedrooms = json['bedrooms'];
    bathrooms = json['bathrooms'];
    furnishing = json['furnishing'];
    constructionStatus = json['constructionStatus'];
    listedBy = json['listedBy'];
    superBuiltupArea = json['superBuiltupArea'];
    carpetArea = json['carpetArea'];
    maintenanceMonthly = json['maintenanceMonthly'];
    totalFloors = json['totalFloors'];
    floorNo = json['floorNo'];
    carParking = json['carParking'];
    facing = json['facing'];
    projectName = json['projectName'];
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
    data['type'] = this.type;
    data['bedrooms'] = this.bedrooms;
    data['bathrooms'] = this.bathrooms;
    data['furnishing'] = this.furnishing;
    data['constructionStatus'] = this.constructionStatus;
    data['listedBy'] = this.listedBy;
    data['superBuiltupArea'] = this.superBuiltupArea;
    data['carpetArea'] = this.carpetArea;
    data['maintenanceMonthly'] = this.maintenanceMonthly;
    data['totalFloors'] = this.totalFloors;
    data['floorNo'] = this.floorNo;
    data['carParking'] = this.carParking;
    data['facing'] = this.facing;
    data['projectName'] = this.projectName;
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
