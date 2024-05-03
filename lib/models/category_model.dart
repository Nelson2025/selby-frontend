/*This is the model of Category*/
// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

CategoryModel categoryModel(String str) =>
    CategoryModel.fromJson(jsonDecode(str));

class CategoryModel {
  CategoryModel({
    this.sId,
    this.title,
    this.image,
    this.description,
    this.subcategories,
    this.updatedOn,
    this.createdOn,
  });
  late final String? sId;
  late final String? title;
  late final String? image;
  late final String? description;
  late final List? subcategories;
  late final String? updatedOn;
  late final String? createdOn;

  CategoryModel.fromJson(Map<String, dynamic> json) {
    sId = json['data']['_id'];
    title = json['data']['title'];
    image = json['data']["image"];
    description = json['data']['description'];
    subcategories = json['data']['subcategories'];
    updatedOn = json['data']['updatedOn'];
    createdOn = json['data']['createdOn'];
  }
}
