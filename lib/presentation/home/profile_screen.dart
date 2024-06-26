/*This is the Profile Screen*/
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:selby/core/configuration.dart';
import 'package:selby/core/ui.dart';
import 'package:selby/models/user_model.dart';
import 'package:selby/presentation/auth/login_screen.dart';
import 'package:selby/presentation/home/home_screen.dart';
import 'package:selby/presentation/notification_controller.dart';
import 'package:selby/presentation/widgets/gap_widget.dart';
import 'package:selby/presentation/widgets/secondary_textfield.dart';
import 'package:selby/provider/users_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? phone;
  String? userId;
  bool isLoading = false;
  String? notificationUserId;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  getPhone() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    userId = preferences.get('userId').toString();
    phone = preferences.get('phone').toString();
    notificationUserId = preferences.get('userId').toString();
    setState(() {
      phone;
      userId;
      notificationUserId;
    });
  }

  @override
  void initState() {
    getPhone();
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
      onNotificationCreatedMethod:
          NotificationController.onNotificationCreatedMethod,
      onNotificationDisplayedMethod:
          NotificationController.onNotificationDisplayedMethod,
      onDismissActionReceivedMethod:
          NotificationController.onDismissActionReceivedMethod,
    );
    super.initState();
  }

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UsersProvider>(context, listen: false);
    return Scaffold(
      body: Container(
        height: double.infinity,
        padding: const EdgeInsets.all(15.0),
        child: FutureBuilder(
            future: provider.fetchUsersById(userId.toString()),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                List<UserModel>? cdata = snapshot.data;
                if (cdata?[0].name.toString() != '') {
                  nameController.text = cdata![0].name.toString();
                }
                if (cdata?[0].email.toString() != '') {
                  emailController.text = cdata![0].email.toString();
                }
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Account",
                            style: TextStyle(
                              color: Colors.black38,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                          const GapWidget(),
                          Text(
                            "Mobile : +91-******${cdata?[0].phone?.substring(6)}",
                            style: const TextStyle(
                              color: Colors.black38,
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                child: SecondaryTextField(
                                  controller: nameController,
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return "Name is Required";
                                    }
                                    return null;
                                  },
                                  labelText: "Profile Name",
                                  icon: const Icon(
                                    Ionicons.return_down_forward_outline,
                                    color: Colors.black,
                                    size: 18,
                                  ),
                                ),
                              ),
                              const GapWidget(),
                              SizedBox(
                                child: SecondaryTextField(
                                  controller: emailController,
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return "Email is Required";
                                    }
                                    return null;
                                  },
                                  labelText: "Email",
                                  icon: const Icon(
                                    Ionicons.return_down_forward_outline,
                                    color: Colors.black,
                                    size: 18,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              isLoading == true
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator())
                                  : SizedBox(
                                      width: MediaQuery.sizeOf(context).width,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.main),
                                        child: const Text(
                                          "Update",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            isLoading = true;
                                          });
                                          _submit(context);
                                        },
                                      ),
                                    ),
                            ],
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      const Divider(
                        thickness: 0.5,
                        color: Colors.black12,
                      ),
                      Buttontext(
                        text: "Help Center",
                        ontap: () {},
                      ),
                      Buttontext(
                        text: "About",
                        ontap: () {},
                      ),
                      Buttontext(
                        text: "FAQ",
                        ontap: () {},
                      ),
                      Buttontext(
                        text: "Sign Out",
                        ontap: () async {
                          SharedPreferences preferences =
                              await SharedPreferences.getInstance();
                          await preferences.clear();
                          Navigator.pushAndRemoveUntil(
                              // ignore: use_build_context_synchronously
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()),
                              (route) => false);
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Center(
                        child: Text(
                          "version: 1.0",
                          style: TextStyle(color: Colors.black12),
                        ),
                      ),
                    ],
                  ),
                );
              }
            }),
      ),
    );
  }

  Future<void> _submit(BuildContext context) async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    formKey.currentState!.save();

    Dio dio = Dio();
    Response response;
    try {
      response = await dio.put(
        '${Configuration.baseUrl}${Configuration.updateUserUrl}/$userId',
        options: Options(headers: {
          "Accept": "*",
          "content-type": "application/json",
        }),
        data: {
          'name': nameController.text.trim(),
          'email': emailController.text.trim(),
        },
      );

      if (response.statusCode == 200) {
        if (response.data['success'] == true) {
          if (!mounted) return;
          if (userId == notificationUserId) {
            AwesomeNotifications().createNotification(
                content: NotificationContent(
                    id: 1,
                    channelKey: "basic_channel",
                    actionType: ActionType.Default,
                    title: "Great!",
                    body: "You information has been updated."));
          }
          setState(() {
            isLoading = false;
          });
          Navigator.pushAndRemoveUntil(
              // ignore: use_build_context_synchronously
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
              (route) => false);
        } else {
          setState(() {
            isLoading = false;
          });
        }
      }
    } catch (ex) {
      setState(() {
        isLoading = false;
      });
    }
  }
}

class MenuItems extends StatelessWidget {
  final IconData icon;
  final String text;
  final Function() ontap;
  const MenuItems({
    Key? key,
    required this.icon,
    required this.text,
    required this.ontap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: AppColors.main,
      ),
      title: Text(
        text,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 16.0,
        ),
      ),
      onTap: ontap,
    );
  }
}

class Buttontext extends StatelessWidget {
  final String text;
  final Function() ontap;
  const Buttontext({
    Key? key,
    required this.text,
    required this.ontap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: ontap,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.black38,
          ),
        ),
      ),
    );
  }
}
