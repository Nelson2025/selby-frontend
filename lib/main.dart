import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:selby/core/ui.dart';
import 'package:selby/presentation/auth/login_screen.dart';
import 'package:selby/presentation/auth/otp_screen.dart';
import 'package:selby/presentation/screens/splash/splash_screen.dart';
import 'package:selby/provider/auth_provider.dart';
import 'package:selby/provider/autos_provider.dart';
import 'package:selby/provider/category_provider.dart';
import 'package:selby/provider/csc_provider.dart';
import 'package:selby/provider/msg_provider.dart';
import 'package:selby/provider/properties_provider.dart';
import 'package:selby/provider/user_provider.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

void main() async {
  AwesomeNotifications().initialize(
      // set the icon to null if you want to use the default app icon
      // 'resource://assets/images/selby_logo.png',
      null,
      [
        NotificationChannel(
            channelGroupKey: 'basic_channel_group',
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: Color(0xFF9D50DD),
            ledColor: Colors.white)
      ],
      // Channel groups are only visual and are not required
      channelGroups: [
        NotificationChannelGroup(
            channelGroupKey: 'basic_channel_group',
            channelGroupName: 'Basic group')
      ],
      debug: true);
  bool isAllowedToSendNotification =
      await AwesomeNotifications().isNotificationAllowed();
  if (!isAllowedToSendNotification) {
    AwesomeNotifications().requestPermissionToSendNotifications();
  }
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((value) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => AutosProvider()),
        ChangeNotifierProvider(create: (_) => PropertiesProvider()),
        ChangeNotifierProvider(create: (_) => MessageProvider()),
        ChangeNotifierProvider(create: (_) => CscProvider()),
        // ChangeNotifierProvider(create: (_) => OtpProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: Themes.defaultTheme,
        initialRoute: '/',
        routes: {
          '/': (context) => SplashScreen(),
          LoginScreen.routeName: (context) => LoginScreen(),
          // OtpScreen.routeName: (context) => OtpScreen(),
        },
      ),
    );
  }
}
