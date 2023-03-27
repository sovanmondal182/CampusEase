// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../../notifiers/authNotifier.dart';
// import '../admin/adminHome.dart';
// import '../navigationBar.dart';
// import 'login.dart';

// class AppSplashScreen extends StatelessWidget {
//   // final ProfileController profileController = Get.find<ProfileController>();
//   // final WatchListController watchlistController =
//   //     Get.find<WatchListController>();
//   // final OverviewController overviewController = Get.find<OverviewController>();

//   AppSplashScreen({Key? key}) : super(key: key) {
//     // profileController.syncProfile(true);
//     // watchlistController.getStocksList(true, "");
//     // watchlistController.syncOverview(false);
//     //  overviewController.getUserHoldings(true);
//   }

//   @override
//   Widget build(BuildContext context) {
//     AuthNotifier authNotifier = Provider.of<AuthNotifier>(context);
//     return StreamBuilder<User?>(
//       stream: FirebaseAuth.instance.authStateChanges(),
//       builder: (context, snapshot) {
//         // User is not signed in
//         if (snapshot.hasData) {
//           (authNotifier.userDetails != null &&
//                   authNotifier.userDetails!.role == 'admin')
//               ? Navigator.pushReplacement(context, MaterialPageRoute(
//                   builder: (BuildContext context) {
//                     return AdminHomePage();
//                   },
//                 ))
//               : Navigator.pushReplacement(context, MaterialPageRoute(
//                   builder: (BuildContext context) {
//                     return NavigationBarPage(selectedIndex: 1);
//                   },
//                 ));
//         }
//         return LoginPage();
//       },
//     );
//   }
// }
