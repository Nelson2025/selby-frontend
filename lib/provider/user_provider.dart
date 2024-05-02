// import 'package:flutter/material.dart';
// import 'package:selby/models/user_model.dart';

// class UserProvider extends ChangeNotifier {
//   UserModel _userModel = UserModel(
//     sId: '',
//     name: '',
//     email: '',
//     isEmailVerified: false,
//     password: '',
//     phone: '',
//     isPhoneVerified: false,
//     about: '',
//     avatar: '',
//     address: '',
//     city: '',
//     state: '',
//     pincode: '',
//     profileProgress: 0,
//     id: '',
//     updatedOn: '',
//     createdOn: '',
//   );

//   UserModel get userModel => _userModel;
//   void setUserModel(String userModel) {
//     _userModel = UserModel.fromJson(userModel);
//     notifyListeners();
//   }

//   void setUserModelFromModel(UserModel userModel) {
//     _userModel = userModel;
//     notifyListeners();
//   }
// }
