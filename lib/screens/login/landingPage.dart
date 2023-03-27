import 'package:campus_ease/apis/foodAPIs.dart';
import 'package:campus_ease/notifiers/authNotifier.dart';
import 'package:campus_ease/screens/canteen/adminHome.dart';
import 'package:campus_ease/screens/login/login.dart';
import 'package:campus_ease/screens/canteen/navigationBar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../dashboard/admin_dashboard.dart';
import '../dashboard/student_dashboard_screen.dart';
// import 'package:foodlab/api/food_api.dart';
// import 'package:foodlab/screens/login_signup_page.dart';
// import 'package:foodlab/notifier/auth_notifier.dart';
// import 'package:foodlab/screens/navigation_bar.dart';
// import 'package:provider/provider.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  @override
  void initState() {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    initializeCurrentUser(authNotifier, context);
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
                    return LoginPage();
                  }))
                : (authNotifier.userDetails == null)
                    ? print('wait')
                    : (authNotifier.userDetails!.role == 'admin')
                        ? Navigator.pushReplacement(context, MaterialPageRoute(
                            builder: (BuildContext context) {
                              return AdminDashboardScreen();
                            },
                          ))
                        : (authNotifier.userDetails!.role == 'faculty')
                            ? Navigator.pushReplacement(context,
                                MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return AdminHomePage();
                                },
                              ))
                            : (authNotifier.userDetails!.role == 'worker')
                                ? Navigator.pushReplacement(context,
                                    MaterialPageRoute(
                                    builder: (BuildContext context) {
                                      return AdminHomePage();
                                    },
                                  ))
                                : (authNotifier.userDetails!.role == 'canteen')
                                    ? Navigator.pushReplacement(context,
                                        MaterialPageRoute(
                                        builder: (BuildContext context) {
                                          return AdminHomePage();
                                        },
                                      ))
                                    : Navigator.pushReplacement(context,
                                        MaterialPageRoute(
                                        builder: (BuildContext context) {
                                          return StudentDashBoardScreen();
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
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context);

    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
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
          children: <Widget>[
            Text(
              'CampusEase',
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'MuseoModerno',
              ),
            ),
            // SizedBox(
            //   height: MediaQuery.of(context).size.height * 0.1,
            // ),
            // GestureDetector(
            //   onTap: () {
            //     (authNotifier.user == null)
            //         ? Navigator.pushReplacement(context,
            //             MaterialPageRoute(builder: (BuildContext context) {
            //             return LoginPage();
            //           }))
            //         : (authNotifier.userDetails == null)
            //             ? print('wait')
            //             : (authNotifier.userDetails!.role == 'admin')
            //                 ? Navigator.pushReplacement(context,
            //                     MaterialPageRoute(
            //                     builder: (BuildContext context) {
            //                       return AdminHomePage();
            //                     },
            //                   ))
            //                 : Navigator.pushReplacement(context,
            //                     MaterialPageRoute(
            //                     builder: (BuildContext context) {
            //                       return NavigationBarPage(selectedIndex: 1);
            //                     },
            //                   ));
            //   },
            //   child: Container(
            //     padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
            //     decoration: BoxDecoration(
            //       color: Colors.white,
            //       borderRadius: BorderRadius.circular(30),
            //     ),
            //     child: Text(
            //       "Explore",
            //       style: TextStyle(
            //         fontSize: 20,
            //         color: Color.fromRGBO(255, 63, 111, 1),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
