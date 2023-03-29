import 'package:campus_ease/notifiers/authNotifier.dart';
import 'package:campus_ease/screens/outing/outing_in_out.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';

import '../../widgets/dashboard_item.dart';
import '../canteen/canteen_navigationBar.dart';
import '../canteen/canteen_profilePage.dart';
import '../faculty_details/faculty_details_table.dart';
import '../library/library_student.dart';
import '../mess/mess_student_screen.dart';
import '../profile/user_profile.dart';
import '../service/service_student.dart';

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
              DashBoardItem(
                text: 'Outing',
                image: 'outing',
                onTap: () => Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context) {
                    return OutingInOut();
                  },
                )),
              ),
              DashBoardItem(
                text: 'Mess',
                image: 'mess',
                onTap: () => Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context) {
                    return MessStudentScreen();
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
                onTap: () => Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context) {
                    return FacultyDetailsTableScreen();
                  },
                )),
              ),
              DashBoardItem(
                text: 'Services',
                image: 'services',
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ServiceStudentScreen(),
                    )),
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
