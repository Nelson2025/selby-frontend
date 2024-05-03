/* This is Products Provider*/
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:selby/core/configuration.dart';
import 'package:selby/models/product_model.dart';

class ProductProvider extends ChangeNotifier {
  final bool _loading = false;
  bool get loading => _loading;

  fetchProductById(String id) async {
    List<ProductModel> product = [];
    try {
      final response = await http.get(
        Uri.parse(
            '${Configuration.baseUrl}${Configuration.fetchProductByIdUrl}$id'),
      );

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        result['data'].forEach((value) => {
              product.add(
                ProductModel(
                    sId: value['_id'],
                    categoryId: value['categoryId'],
                    subcategoryId: value['subcategoryId'],
                    userId: value['userId'],
                    features: value['features'],
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
        return product;
      } else {
        return [];
      }
    } catch (ex) {
      log(ex.toString());
    }
  }

  fetchProductByCategoryId(String id, String subCatId) async {
    List<ProductModel> products = [];

    try {
      final response = await http.get(Uri.parse(
          '${Configuration.baseUrl}${Configuration.fetchProductByCategoryIdIdUrl}$id/$subCatId'));

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        result['data']?.forEach((value) => {
              products.add(
                ProductModel(
                    sId: value['_id'],
                    categoryId: value['categoryId'],
                    subcategoryId: value['subcategoryId'],
                    userId: value['userId'],
                    features: value['features'],
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
        return products;
      } else {
        return [];
      }
    } catch (ex) {
      log(ex.toString());
    }
  }

  fetchAllProductByUserId(String id) async {
    List<ProductModel> products = [];
    try {
      final response = await http.get(
        Uri.parse(
            '${Configuration.baseUrl}${Configuration.fetchAllProductByUserIdIdUrl}$id'),
      );

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        result['data']?.forEach((value) => {
              products.add(
                ProductModel(
                    sId: value['_id'],
                    categoryId: value['categoryId'],
                    subcategoryId: value['subcategoryId'],
                    userId: value['userId'],
                    features: value['features'],
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
        return products;
      } else {
        return [];
      }
    } catch (ex) {
      log(ex.toString());
    }
  }
}
