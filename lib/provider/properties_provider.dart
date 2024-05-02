import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:selby/core/configuration.dart';
import 'package:selby/models/properties_model.dart';
import 'package:selby/models/category_model.dart';
import 'package:selby/models/otp_model.dart';
import 'package:selby/models/user_model.dart';

class PropertiesProvider extends ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;

  // setLoading(bool value) {
  //   _loading = value;
  //   notifyListeners();
  // }

  fetchAllProperties() async {
    List<PropertiesModel> properties = [];
    // setLoading(true);
    // notifyListeners();
    try {
      final response = await http.get(
        Uri.parse(
            '${Configuration.baseUrl}${Configuration.fetchAllPropertiesUrl}'),
      );
      // print(response.body);

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        print(result);
        result['data'].forEach((value) => {
              properties.add(
                PropertiesModel(
                    sId: value['_id'],
                    categoryId: value['categoryId'],
                    subcategoryId: value['subcategoryId'],
                    userId: value['userId'],
                    type: value['type'],
                    bedrooms: value['bedrooms'],
                    bathrooms: value['bathrooms'],
                    furnishing: value['furnishing'],
                    constructionStatus: value['constructionStatus'],
                    listedBy: value['listedBy'],
                    superBuiltupArea: value['superBuiltupArea'],
                    carpetArea: value['carpetArea'],
                    maintenanceMonthly: value['maintenanceMonthly'],
                    totalFloors: value['totalFloors'],
                    floorNo: value['floorNo'],
                    carParking: value['carParking'],
                    facing: value['facing'],
                    projectName: value['projectName'],
                    title: value['title'],
                    description: value['description'],
                    price: value['price'],
                    image: value['image'],
                    favourite: value['favourite'],
                    city: value['city'],
                    state: value['state'],
                    status: value['status'],
                    updatedOn: value['updatedOn'],
                    createdOn: value['createdOn']),
              ),
            });
        return properties;
      } else {
        return [];
      }
      // final jsondata = jsonDecode(response.body) as List;
      // if (request.statusCode == 200 || request.statusCode == 201) {
      // final response = jsonDecode(request.body);
      //print(request);
      //print(response['data']);
      // print(response['data']['phone'])
      //categoryModel(response.body);
      // setLoading(false);
      // notifyListeners();
      // categories = (request.body as List<dynamic>)
      //     .map((json) => CategoryModel.fromJson(json))
      //     .toList();

      // categories = request.body;
      // print(jsondata);

      // }
    } catch (ex) {
      // setLoading(false);
      // print(ex.toString());
      // notifyListeners();
      print(ex.toString());
      //rethrow;
    }
  }

  fetchPropertiesById(String id) async {
    List<PropertiesModel> properties = [];
    // setLoading(true);
    // notifyListeners();
    try {
      final response = await http.get(
        Uri.parse(
            '${Configuration.baseUrl}${Configuration.fetchPropertiesByIdUrl}$id'),
      );
      // print(response.body);

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        print(result);
        result['data'].forEach((value) => {
              properties.add(
                PropertiesModel(
                    sId: value['_id'],
                    categoryId: value['categoryId'],
                    subcategoryId: value['subcategoryId'],
                    userId: value['userId'],
                    features: value['features'],
                    //type: value['type'],
                    // bedrooms: value['bedrooms'],
                    // bathrooms: value['bathrooms'],
                    // furnishing: value['furnishing'],
                    // constructionStatus: value['constructionStatus'],
                    // listedBy: value['listedBy'],
                    // superBuiltupArea: value['superBuiltupArea'],
                    // carpetArea: value['carpetArea'],
                    // maintenanceMonthly: value['maintenanceMonthly'],
                    // totalFloors: value['totalFloors'],
                    // floorNo: value['floorNo'],
                    // carParking: value['carParking'],
                    // facing: value['facing'],
                    // projectName: value['projectName'],
                    title: value['title'],
                    description: value['description'],
                    price: value['price'],
                    image: value['image'],
                    favourite: value['favourite'],
                    city: value['city'],
                    state: value['state'],
                    updatedOn: value['updatedOn'],
                    createdOn: value['createdOn']),
              ),
            });
        return properties;
      } else {
        return [];
      }
    } catch (ex) {
      // setLoading(false);
      // print(ex.toString());
      // notifyListeners();
      print(ex.toString());
      //rethrow;
    }
  }
}
