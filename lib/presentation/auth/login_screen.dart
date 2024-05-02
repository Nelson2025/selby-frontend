import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:selby/api_services/otpApi.dart';
import 'package:selby/core/ui.dart';
import 'package:selby/presentation/auth/otp_screen.dart';
import 'package:selby/presentation/widgets/gap_widget.dart';
import 'package:selby/presentation/widgets/logo_widget.dart';
import 'package:selby/presentation/widgets/primary_button.dart';
import 'package:selby/presentation/widgets/primary_textfield.dart';
import 'package:selby/provider/auth_provider.dart';
import 'package:selby/services/auth_services.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = 'login';
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController phoneController = TextEditingController();

  // final AuthService authService = AuthService();

  final String error = "";

  final bool isLoading = false;

  // void createOtp() {
  //   authService.createOtp(context: context, phone: phoneController.text);
  // }

  @override
  Widget build(BuildContext context) {
    // final provider = Provider.of<AuthProvider>(context, listen: false);
    // print('build');
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const LogoWidget(
                  size: 1.9,
                ),
                GapWidget(
                  size: MediaQuery.of(context).size.height * 0.08,
                ),
                Image.asset(
                  'assets/images/banner.png',
                  width: MediaQuery.of(context).size.width / 1.3,
                ),
                GapWidget(
                  size: MediaQuery.of(context).size.height * 0.08,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * .06),
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "SIGN UP / LOGIN",
                      style: TextStyles.heading4,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * .06),
                  child: const Divider(
                    color: Colors.grey,
                  ),
                ),
                const GapWidget(
                  size: -10,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * .06),
                  child: Container(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      "6 Digit OTP will be sent via SMS to verify your phone number",
                      style: TextStyles.body3,
                    ),
                  ),
                ),
                const GapWidget(
                  size: -10,
                ),
                (error != "")
                    ? Text(
                        error,
                        style: const TextStyle(color: Colors.red),
                      )
                    : const SizedBox(),
                const GapWidget(),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * .05),
                  child: PrimaryTextField(
                    controller: phoneController,
                    maxLength: 10,
                    keyboardType: TextInputType.number,
                    prefixText: "+91",
                    icon: const Icon(Ionicons.call_outline),
                    labelText: "Enter 10 Digit Mobile Number",
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Phone Number is Required";
                      } else if (value.length < 10) {
                        return "Phone Number must be 10 Digit";
                      }
                      return null;
                    },
                  ),
                ),
                const GapWidget(),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * .05),
                  child: PrimaryButton(
                    // text: (provider.isLoading) ? "..." : "Send OTP",
                    text: isLoading ? "..." : "Send OTP",
                    onPressed: () {
                      if (!formKey.currentState!.validate()) return;
                      OtpApi.createOtp(phoneController.text)
                          .then((response) async {
                        print(response.hash);
                        if (response.hash != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OtpScreen(
                                    hash: response.hash!,
                                    otp: response.otp!,
                                    phone: phoneController.text)),
                          );
                        }
                      });
                      // createOtp();
                      // provider.createOtp(phone: phoneController.text.trim());
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) =>
                      //             OtpScreen(phone: phoneController.text)));
                      // provider.logIn();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
