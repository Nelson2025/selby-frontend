/* This is Categories Provider*/
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:selby/core/configuration.dart';
import 'package:selby/models/category_model.dart';

class CategoryProvider extends ChangeNotifier {
  final bool _loading = false;
  bool get loading => _loading;

  fetchAllCategories() async {
    List<CategoryModel> categories = [];
    try {
      final response = await http.get(
        Uri.parse(
            '${Configuration.baseUrl}${Configuration.fetchAllCategoriesUrl}'),
      );

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
    } catch (ex) {
      log(ex.toString());
    }
  }
}
