import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'package:campus_ease/screens/login/landingPage.dart';

import 'notificationservice/local_notification_service.dart';
import 'notifiers/authNotifier.dart';

Future<void> backgroundHandler(RemoteMessage message) async {}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  LocalNotificationService.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthNotifier>(
          create: (context) => AuthNotifier(),
        ),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'CampusEase',
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
              color: Colors.transparent,
              elevation: 0,
              titleTextStyle: TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
              actionsIconTheme: IconThemeData(color: Colors.black),
              iconTheme: IconThemeData(color: Colors.black)),
          fontFamily: 'Montserrat',
          primaryColor: const Color(0xFF8CBBF1),
        ),
        builder: (BuildContext context, Widget? child) {
          var loader = EasyLoading.init();
          EasyLoading.instance
            ..backgroundColor = Colors.transparent
            ..progressColor = Colors.white
            ..indicatorWidget = const CircularProgressIndicator(
              color: Color(0xFF8CBBF1),
            )
            ..boxShadow = <BoxShadow>[] // removes black background
            ..loadingStyle = EasyLoadingStyle.light
            ..textColor = Colors.black
            ..indicatorColor = Colors.white // color of animated loader
            ..maskColor = Colors.black38
            ..maskType = EasyLoadingMaskType.custom
            ..radius = 180
            ..loadingStyle = EasyLoadingStyle.custom
            ..userInteractions = true
            ..dismissOnTap = true;

          return loader(context, child!);
        },
        home: const LandingPage(),
      ),
    );
  }
}
