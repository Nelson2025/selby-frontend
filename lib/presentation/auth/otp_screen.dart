/*This is the OTP Screen*/
// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:selby/api_services/otpApi.dart';
import 'package:selby/api_services/userApi.dart';
import 'package:selby/core/ui.dart';
import 'package:selby/presentation/home/home_screen.dart';
import 'package:selby/presentation/location/location_screen.dart';
import 'package:selby/presentation/widgets/gap_widget.dart';
import 'package:selby/presentation/widgets/link_button.dart';
import 'package:selby/presentation/widgets/logo_widget.dart';
import 'package:selby/presentation/widgets/primary_button.dart';
import 'package:selby/presentation/widgets/primary_textfield.dart';

class OtpScreen extends StatefulWidget {
  static const routeName = 'otp';

  final String otp;
  final String phone;
  final String hash;
  const OtpScreen({
    Key? key,
    required this.otp,
    required this.phone,
    required this.hash,
  }) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  TextEditingController otpController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final String error = "";

  final bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    // final provider = Provider.of<OtpProvider>(context).otpModel;

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
                  size: MediaQuery.of(context).size.height * 0.06,
                ),
                Image.asset(
                  'assets/images/banner.png',
                  width: MediaQuery.of(context).size.width / 1.3,
                ),
                GapWidget(
                  size: MediaQuery.of(context).size.height * 0.06,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * .06),
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "VERIFY OTP",
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
                (error != "")
                    ? Text(
                        error,
                        style: const TextStyle(color: Colors.red),
                      )
                    : const SizedBox(),
                const GapWidget(),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * .06),
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "6 Digit code has been sent to +91-${widget.phone}",
                      style: TextStyles.body3,
                    ),
                  ),
                ),
                const GapWidget(),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * .05),
                  child: PrimaryTextField(
                    controller: otpController,
                    maxLength: 4,
                    keyboardType: TextInputType.number,
                    icon: const Icon(Ionicons.keypad_outline),
                    labelText: "Enter 6 Digit OTP Code",
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "OTP is Required";
                      } else if (value != widget.otp) {
                        return "Invalid OTP";
                      }

                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * .06),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Didn't receive the code ? "),
                      LinkButton(
                        text: " RESEND",
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                ),
                GapWidget(
                  size: MediaQuery.of(context).size.height * 0.01,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * .05),
                  child: PrimaryButton(
                    text: "Submit",
                    onPressed: () {
                      if (!formKey.currentState!.validate()) return;
                      OtpApi.verifyOtp(
                              widget.phone, widget.hash, otpController.text)
                          .then((response) async {
                        if (response.success == true &&
                            response.message == 'Success') {
                          UserApi.userAccount(response.phone!).then((res) {
                            if (response.success == true) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const LocationScreen()),
                              );
                            }
                          });
                        }
                      });
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
