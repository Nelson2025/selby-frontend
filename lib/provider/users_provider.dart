/* This is Users & Create OTP Provider*/
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:selby/core/configuration.dart';
import 'package:selby/models/otp_model.dart';
import 'package:selby/models/user_model.dart';
import 'package:selby/services/auth_services.dart';

class UsersProvider extends ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  String phoneNumber = "";
  String hash = "";
  String otp = "";

  UserModel userModel = UserModel();
  List<UserModel> usersList = [];

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  allUsers({required BuildContext context}) async {
    log('message initiated');
    AuthService authServices = AuthService();

    await authServices
        .getAllUser(userid: userModel.sId.toString(), context: context)
        .then((value) {
      usersList.assignAll(value);

      notifyListeners();
    });
  }

  fetchUsersById(String id) async {
    List<UserModel> usersList = [];
    try {
      final response = await http.get(
        Uri.parse(
            '${Configuration.baseUrl}${Configuration.fetchUserByIdUrl}$id'),
      );

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        print(result);
        result['data'].forEach((value) => {
              usersList.add(
                UserModel(
                  sId: value['_id'],
                  name: value['name'],
                  email: value['email'],
                  isEmailVerified: value['isEmailVerified'],
                  password: value['password'],
                  phone: value['phone'],
                  isPhoneVerified: value['isPhoneVerified'],
                  about: value['about'],
                  avatar: value['avatar'],
                  address: value['address'],
                  city: value['city'],
                  state: value['state'],
                  pincode: value['pincode'],
                  profileProgress: 0,
                  id: value['id'],
                  updatedOn: value['updatedOn'],
                  createdOn: value['createdOn'],
                ),
              ),
            });
        return usersList;
      } else {
        return [];
      }
    } catch (ex) {
      log(ex.toString());
    }
  }

  void createOtp({required String phone}) async {
    setLoading(true);
    notifyListeners();

    final body = {"phone": phone};
    try {
      http.Response request = await http.post(
          Uri.parse('${Configuration.baseUrl}${Configuration.createOtpUrl}'),
          body: jsonEncode(body));

      if (request.statusCode == 200 || request.statusCode == 201) {
        final response = jsonDecode(request.body);
        otpModel(response.body);
        setLoading(false);
        notifyListeners();
      } else {
        final response = jsonDecode(request.body);
        log(response);
        setLoading(false);
        notifyListeners();
      }
    } on SocketException catch (ex) {
      setLoading(false);
      log(ex.toString());
      notifyListeners();
    } catch (ex) {
      setLoading(false);
      log(ex.toString());
      notifyListeners();
    }
  }
}
