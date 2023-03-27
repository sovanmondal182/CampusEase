import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../widgets/dashboard_item.dart';
import '../navigationBar.dart';
import 'library_student.dart';

class StudentDashBoardScreen extends StatefulWidget {
  const StudentDashBoardScreen({super.key});

  @override
  State<StudentDashBoardScreen> createState() => _StudentDashBoardScreenState();
}

class _StudentDashBoardScreenState extends State<StudentDashBoardScreen> {
  @override
  Widget build(BuildContext context) {
    final hight = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Dashboard'),
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
