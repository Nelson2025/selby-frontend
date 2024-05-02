import 'dart:async';

import 'package:flutter/material.dart';
import 'package:selby/api_services/userApi.dart';
import 'package:selby/core/ui.dart';
import 'package:selby/presentation/auth/login_screen.dart';
import 'package:selby/presentation/home/home_screen.dart';
import 'package:selby/presentation/location/location_screen.dart';
import 'package:selby/presentation/widgets/gap_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 2000), () async {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      final phone = preferences.getString('phone');
      print(phone);
      // UserApi.userAccount(phone!);
      // if (phone != null) {
      //   UserApi.userAccount(phone!).then((res) {
      //     if (res.success == true) {
      //       Navigator.pushAndRemoveUntil(
      //           context,
      //           MaterialPageRoute(builder: (context) => HomeScreen()),
      //           (route) => false);
      //     }
      //   });
      // } else {
      if (phone != null) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LocationScreen()),
            (route) => false);
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
            (route) => false);
      }

      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.main,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/selby_logo.png',
              width: MediaQuery.of(context).size.width / 2,
            ),
            const GapWidget(),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
