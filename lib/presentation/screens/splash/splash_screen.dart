/* This is Splash Screen*/
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:selby/core/ui.dart';
import 'package:selby/presentation/auth/login_screen.dart';
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
      if (phone != null) {
        Navigator.pushAndRemoveUntil(
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(builder: (context) => const LocationScreen()),
            (route) => false);
      } else {
        Navigator.pushAndRemoveUntil(
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false);
      }
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
