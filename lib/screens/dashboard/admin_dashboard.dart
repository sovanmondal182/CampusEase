import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:campus_ease/screens/mess/mess_admin_screen.dart';
import 'package:campus_ease/screens/outing/outing_admin.dart';
import 'package:campus_ease/screens/profile/user_profile.dart';

import '../../notifiers/authNotifier.dart';
import '../../widgets/dashboard_item.dart';
import '../canteen/canteen_navigationBar.dart';
import '../faculty_details/faculty_admin_screen.dart';
import '../library/library_admin.dart';
import '../profile/all_user_screen.dart';
import '../service/service_admin_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const UserProfileScreen()));
              },
              icon: (authNotifier.userDetails!.photoUrl != null)
                  ? CircleAvatar(
                      backgroundImage:
                          NetworkImage(authNotifier.userDetails!.photoUrl!),
                    )
                  : const Icon(Icons.account_circle)),
        ],
      ),
      body: SafeArea(
        child: GridView(
            padding: const EdgeInsets.all(10.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.0,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
            ),
            children: [
              DashBoardItem(
                  text: 'Library',
                  image: 'library',
                  onTap: () => Navigator.push(context, MaterialPageRoute(
                        builder: (BuildContext context) {
                          return const LibraryAdmin();
                        },
                      ))),
              DashBoardItem(
                text: 'Outing',
                image: 'outing',
                onTap: () => Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context) {
                    return const OutingAdmin();
                  },
                )),
              ),
              DashBoardItem(
                text: 'Mess',
                image: 'mess',
                onTap: () => Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context) {
                    return const MessAdminScreen();
                  },
                )),
              ),
              DashBoardItem(
                text: 'Canteen',
                image: 'canteen',
                onTap: () => Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context) {
                    return NavigationBarPage(selectedIndex: 1);
                  },
                )),
              ),
              const DashBoardItem(
                text: 'Clubs',
                image: 'clubs',
              ),
              const DashBoardItem(
                text: 'Notice Board',
                image: 'notice_board',
              ),
              DashBoardItem(
                text: 'Faculty Details',
                image: 'faculty_details',
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FacultyAdminScreen(),
                    )),
              ),
              DashBoardItem(
                  text: 'Services',
                  image: 'services',
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ServiceAdminScreen(),
                      ))),
              const DashBoardItem(
                text: 'Calendar',
                image: 'calendar',
              ),
              DashBoardItem(
                text: 'Users',
                image: 'users',
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AllUserScreen(),
                    )),
              ),
            ]),
      ),
    );
  }
}
