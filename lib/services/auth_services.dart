import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:selby/core/configuration.dart';
import 'package:selby/models/user_model.dart';
import 'package:selby/provider/auth_provider.dart';

class AuthService {
  Dio dio = Dio();

  Future<List<UserModel>> getAllUser(
      {required String userid, required BuildContext context}) async {
    List<UserModel> users = [];
    // log(userid.toString() + 'GGGGGGGGGGGGGGG');

    return await dio
        .get(Configuration.baseUrl + "/api/user/getAllUsers")
        .then((value) {
      var list = value.data as List;
      print(list);
      for (var element in list) {
        UserModel userModel = UserModel.fromJson(element);

        users.add(userModel);
      }
      return users;
    }).catchError((e) {
      Provider.of<AuthProvider>(context, listen: false).isLoading = false;
      log(e.toString());
      //  throw Exception('error');
    });
  }
}
