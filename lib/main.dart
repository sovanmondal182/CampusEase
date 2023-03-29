import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:campus_ease/screens/login/landingPage.dart';

import 'notifiers/authNotifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'CampusEase',
        theme: ThemeData(
          fontFamily: 'Montserrat',
          primaryColor: const Color.fromRGBO(255, 63, 111, 1),
        ),
        home: LandingPage(),
      ),
    );
  }
}
