import 'package:campus_ease/notifiers/authNotifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';

import '../../widgets/dashboard_item.dart';
import '../canteen/canteen_navigationBar.dart';
import '../canteen/canteen_profilePage.dart';
import '../library/library_student.dart';
import '../profile/user_profile.dart';

class StudentDashBoardScreen extends StatefulWidget {
  const StudentDashBoardScreen({super.key});

  @override
  State<StudentDashBoardScreen> createState() => _StudentDashBoardScreenState();
}

class _StudentDashBoardScreenState extends State<StudentDashBoardScreen> {
  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context);
    final hight = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Dashboard'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserProfileScreen()));
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
                          return LibraryStudentScreen();
                        },
                      ))),
              const DashBoardItem(
                text: 'Outing',
                image: 'outing',
              ),
              const DashBoardItem(
                text: 'Mess',
                image: 'mess',
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
              const DashBoardItem(
                text: 'Faculty Details',
                image: 'faculty_details',
              ),
              const DashBoardItem(
                text: 'Services',
                image: 'services',
              ),
              const DashBoardItem(
                text: 'Calendar',
                image: 'calendar',
              ),
            ]),
      ),
    );
  }
}
