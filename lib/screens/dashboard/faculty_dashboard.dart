import 'package:campus_ease/screens/faculty_details/faculty_details_table.dart';
import 'package:campus_ease/screens/notice/view_notice.dart';
import 'package:campus_ease/screens/service/service_student.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../notifiers/authNotifier.dart';
import '../../widgets/dashboard_item.dart';
import '../canteen/canteen_navigationBar.dart';
import '../library/library_admin.dart';
import '../outing/outing_admin.dart';
import '../profile/user_profile.dart';

class FacultyDashboardScreen extends StatefulWidget {
  const FacultyDashboardScreen({super.key});

  @override
  State<FacultyDashboardScreen> createState() => _FacultyDashboardScreenState();
}

class _FacultyDashboardScreenState extends State<FacultyDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Faculty Dashboard'),
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
              if (authNotifier.userDetails!.role == 'librarian')
                DashBoardItem(
                    text: 'Library',
                    image: 'library',
                    onTap: () => Navigator.push(context, MaterialPageRoute(
                          builder: (BuildContext context) {
                            return const LibraryAdmin();
                          },
                        ))),
              if (authNotifier.userDetails!.role == 'warden')
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
                text: 'Canteen',
                image: 'canteen',
                onTap: () => Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context) {
                    return NavigationBarPage(selectedIndex: 1);
                  },
                )),
              ),
              DashBoardItem(
                  text: 'Notice Board',
                  image: 'notice_board',
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ViewNoticeScreen(),
                      ))),
              DashBoardItem(
                text: 'Faculty Details',
                image: 'faculty_details',
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FacultyDetailsTableScreen(),
                    )),
              ),
              DashBoardItem(
                  text: 'Services',
                  image: 'services',
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ServiceStudentScreen(),
                      ))),
            ]),
      ),
    );
  }
}
