import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:selby/core/configuration.dart';
import 'package:selby/models/autos_model.dart';

import 'package:selby/models/product_model.dart';

class AutosProvider extends ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;

  // setLoading(bool value) {
  //   _loading = value;
  //   notifyListeners();
  // }

  fetchAllAutos() async {
    List<AutosModel> autos = [];
    // setLoading(true);
    // notifyListeners();
    try {
      final response = await http.get(
        Uri.parse('${Configuration.baseUrl}${Configuration.fetchAllAutosUrl}'),
      );
      // print(response.body);

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        print(result);
        result['data']?.forEach((value) => {
              autos.add(
                AutosModel(
                    sId: value['_id'],
                    categoryId: value['categoryId'],
                    userId: value['userId'],
                    brand: value['brand'],
                    model: value['model'],
                    variant: value['variant'],
                    year: value['year'],
                    fuel: value['fuel'],
                    transmission: value['transmission'],
                    kms: value['kms'],
                    owner: value['owner'],
                    title: value['title'],
                    description: value['description'],
                    price: value['price'],
                    image: value['image'],
                    // city: value['city'],
                    // state: value['state'],
                    updatedOn: value['updatedOn'],
                    createdOn: value['createdOn']),
              ),
            });
        return autos;
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

  fetchAutosById(String id) async {
    List<AutosModel> autos = [];
    // setLoading(true);
    // notifyListeners();
    try {
      final response = await http.get(
        Uri.parse(
            '${Configuration.baseUrl}${Configuration.fetchAutosByIdUrl}$id'),
      );
      // print(response.body);

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        print(result);
        result['data']?.forEach((value) => {
              autos.add(
                AutosModel(
                    sId: value['_id'],
                    categoryId: value['categoryId'],
                    userId: value['userId'],
                    brand: value['brand'],
                    model: value['model'],
                    variant: value['variant'],
                    year: value['year'],
                    fuel: value['fuel'],
                    transmission: value['transmission'],
                    kms: value['kms'],
                    owner: value['owner'],
                    title: value['title'],
                    description: value['description'],
                    price: value['price'],
                    image: value['image'],
                    updatedOn: value['updatedOn'],
                    createdOn: value['createdOn']),
              ),
            });
        return autos;
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

  fetchProductByCategoryId(String id, String subCatId) async {
    List<ProductModel> products = [];
    // setLoading(true);
    // notifyListeners();
    try {
      final response = await http.get(Uri.parse(
              '${Configuration.baseUrl}${Configuration.fetchProductByCategoryIdIdUrl}$id/$subCatId')
          //     .resolveUri(Uri(queryParameters: {
          //   "id": {id},
          //   "subCatId": {subCatId}
          // }
          // )),
          );
      // print(response.body);

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        print(result);
        result['data']?.forEach((value) => {
              products.add(
                ProductModel(
                    sId: value['_id'],
                    categoryId: value['categoryId'],
                    subcategoryId: value['subcategoryId'],
                    userId: value['userId'],
                    features: value['features'],
                    // brand: value['brand'],
                    // model: value['model'],
                    // variant: value['variant'],
                    // year: value['year'],
                    // fuel: value['fuel'],
                    // transmission: value['transmission'],
                    // kms: value['kms'],
                    // owner: value['owner'],
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
      // setLoading(false);
      // print(ex.toString());
      // notifyListeners();
      print(ex.toString());
      //rethrow;
    }
  }

  fetchAllProductByUserId(String id) async {
    List<ProductModel> products = [];
    // setLoading(true);
    // notifyListeners();
    try {
      final response = await http.get(
        Uri.parse(
            '${Configuration.baseUrl}${Configuration.fetchAllProductByUserIdIdUrl}$id'),
      );
      // print(response.body);

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        print(result);
        result['data']?.forEach((value) => {
              products.add(
                ProductModel(
                    sId: value['_id'],
                    categoryId: value['categoryId'],
                    subcategoryId: value['subcategoryId'],
                    userId: value['userId'],
                    features: value['features'],
                    // brand: value['brand'],
                    // model: value['model'],
                    // variant: value['variant'],
                    // year: value['year'],
                    // fuel: value['fuel'],
                    // transmission: value['transmission'],
                    // kms: value['kms'],
                    // owner: value['owner'],
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
      // setLoading(false);
      // print(ex.toString());
      // notifyListeners();
      print(ex.toString());
      //rethrow;
    }
  }
}
