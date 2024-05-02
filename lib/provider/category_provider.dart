import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:selby/core/configuration.dart';
import 'package:selby/models/category_model.dart';
import 'package:selby/models/otp_model.dart';
import 'package:selby/models/user_model.dart';

class CategoryProvider extends ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;

  // setLoading(bool value) {
  //   _loading = value;
  //   notifyListeners();
  // }

  fetchAllCategories() async {
    List<CategoryModel> categories = [];
    // setLoading(true);
    // notifyListeners();
    try {
      final response = await http.get(
        Uri.parse(
            '${Configuration.baseUrl}${Configuration.fetchAllCategoriesUrl}'),
      );
      // print(response.body);

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        result['data'].forEach((value) => {
              categories.add(
                CategoryModel(
                    sId: value['_id'],
                    title: value['title'],
                    image: value['image'],
                    description: value['description'],
                    subcategories: value['subcategories'],
                    updatedOn: value['updatedOn'],
                    createdOn: value['createdOn']),
              ),
            });
        return categories;
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
}
