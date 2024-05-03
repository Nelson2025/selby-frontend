/* This is user services*/
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:selby/core/configuration.dart';
import 'package:selby/models/user_model.dart';
import 'package:selby/provider/users_provider.dart';

class AuthService {
  Dio dio = Dio();

  Future<List<UserModel>> getAllUser(
      {required String userid, required BuildContext context}) async {
    List<UserModel> users = [];

    return await dio
        .get("${Configuration.baseUrl}/api/user/getAllUsers")
        .then((value) {
      var list = value.data as List;
      for (var element in list) {
        UserModel userModel = UserModel.fromJson(element);

        users.add(userModel);
      }
      return users;
    }).catchError((e) {
      Provider.of<UsersProvider>(context, listen: false).isLoading = false;
      log(e.toString());
    });
  }
}
