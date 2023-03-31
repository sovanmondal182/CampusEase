// ignore_for_file: file_names, avoid_print

import 'package:campus_ease/apis/allAPIs.dart';
import 'package:campus_ease/notifiers/authNotifier.dart';
import 'package:campus_ease/screens/canteen/canteen_adminhomepage.dart';

import 'package:campus_ease/screens/login/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../dashboard/admin_dashboard.dart';

import '../dashboard/faculty_dashboard.dart';
import '../dashboard/student_dashboard_screen.dart';
import '../outing/outing_admin.dart';
import '../service/service_admin_screen.dart';

// import 'package:foodlab/api/food_api.dart';
// import 'package:foodlab/screens/login_signup_page.dart';
// import 'package:foodlab/notifier/auth_notifier.dart';
// import 'package:foodlab/screens/navigation_bar.dart';
// import 'package:provider/provider.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  @override
  void initState() {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    initializeCurrentUser(authNotifier, context);
    initilizeFirebaseMessage(context);
    animationController = AnimationController(
      /// [AnimationController]s can be created with `vsync: this` because of
      /// [TickerProviderStateMixin].
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..addListener(() {
        setState(() {
          if (animationController.isCompleted) {
            (authNotifier.user == null)
                ? Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                    return const LoginPage();
                  }))
                : (authNotifier.userDetails == null)
                    ? print('wait')
                    : (authNotifier.userDetails!.role == 'admin')
                        ? Navigator.pushReplacement(context, MaterialPageRoute(
                            builder: (BuildContext context) {
                              return const AdminDashboardScreen();
                            },
                          ))
                        : (authNotifier.userDetails!.role == 'faculty')
                            ? Navigator.pushReplacement(context,
                                MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return const FacultyDashboardScreen();
                                },
                              ))
                            : (authNotifier.userDetails!.role == 'worker')
                                ? Navigator.pushReplacement(context,
                                    MaterialPageRoute(
                                    builder: (BuildContext context) {
                                      return const ServiceAdminScreen();
                                    },
                                  ))
                                : (authNotifier.userDetails!.role == 'canteen')
                                    ? Navigator.pushReplacement(context,
                                        MaterialPageRoute(
                                        builder: (BuildContext context) {
                                          return const AdminHomePage();
                                        },
                                      ))
                                    : (authNotifier.userDetails!.role ==
                                            'warden')
                                        ? Navigator.pushReplacement(context,
                                            MaterialPageRoute(
                                            builder: (BuildContext context) {
                                              return const FacultyDashboardScreen();
                                            },
                                          ))
                                        : (authNotifier.userDetails!.role ==
                                                'librarian')
                                            ? Navigator.pushReplacement(context,
                                                MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) {
                                                  return const FacultyDashboardScreen();
                                                },
                                              ))
                                            : (authNotifier.userDetails!.role ==
                                                    'guard')
                                                ? Navigator.pushReplacement(
                                                    context, MaterialPageRoute(
                                                    builder:
                                                        (BuildContext context) {
                                                      return const OutingAdmin();
                                                    },
                                                  ))
                                                : Navigator.pushReplacement(
                                                    context, MaterialPageRoute(
                                                    builder:
                                                        (BuildContext context) {
                                                      return const StudentDashBoardScreen();
                                                    },
                                                  ));
          }
        });
      });
    animationController.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(255, 138, 120, 1),
              Color.fromRGBO(255, 114, 117, 1),
              Color.fromRGBO(255, 63, 111, 1),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              'CampusEase',
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'MuseoModerno',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
