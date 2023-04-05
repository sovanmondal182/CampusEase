import 'dart:io';

import 'package:campus_ease/apis/allAPIs.dart';
import 'package:campus_ease/notifiers/authNotifier.dart';
import 'package:campus_ease/screens/outing/outing_in_out.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../widgets/dashboard_item.dart';
import '../canteen/canteen_navigationBar.dart';
import '../faculty_details/faculty_details_table.dart';
import '../library/library_student.dart';
import '../mess/mess_student_screen.dart';
import '../notice/view_notice.dart';
import '../profile/user_profile.dart';
import '../service/service_student.dart';

class StudentDashBoardScreen extends StatefulWidget {
  const StudentDashBoardScreen({super.key});

  @override
  State<StudentDashBoardScreen> createState() => _StudentDashBoardScreenState();
}

class _StudentDashBoardScreenState extends State<StudentDashBoardScreen> {
  String timeInWeekdays = "";
  String timeOutWeekdays = "";
  String timeInWeekends = "";
  String timeOutWeekends = "";
  fetch() async {
    CollectionReference itemRef =
        FirebaseFirestore.instance.collection('outing_setting');

    await itemRef
        .where('timeInWeekdays', isNotEqualTo: null)
        .get()
        .then((value) async {
      for (var element in value.docs) {
        timeInWeekdays = element['timeInWeekdays'];
        timeOutWeekdays = element['timeOutWeekdays'];
        timeInWeekends = element['timeInWeekends'];
        timeOutWeekends = element['timeOutWeekends'];
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fetch();
  }

  _showExitDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Exit',
          ),
          backgroundColor: Colors.white,
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text(
                  'Are you sure you want to exit the app ?',
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Get.back(),
              child: const Text(
                'Cancel',
              ),
            ),
            TextButton(
              onPressed: () => exit(0),
              child: const Text(
                'OK',
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context);
    return WillPopScope(
      onWillPop: () => _showExitDialog(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'CampusEase',
            style: TextStyle(
                color: Color(0xFF8CBBF1),
                fontWeight: FontWeight.w800,
                fontSize: 26),
          ),
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
              physics: const BouncingScrollPhysics(),
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
                            return const LibraryStudentScreen();
                          },
                        ))),
                DashBoardItem(
                    text: 'Outing',
                    image: 'outing',
                    onTap: () {
                      showOutingInfo(context);
                    }),
                DashBoardItem(
                  text: 'Mess',
                  image: 'mess',
                  onTap: () => Navigator.push(context, MaterialPageRoute(
                    builder: (BuildContext context) {
                      return const MessStudentScreen();
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
                  onTap: () => Navigator.push(context, MaterialPageRoute(
                    builder: (BuildContext context) {
                      return const ViewNoticeScreen();
                    },
                  )),
                ),
                DashBoardItem(
                  text: 'Faculty Details',
                  image: 'faculty_details',
                  onTap: () => Navigator.push(context, MaterialPageRoute(
                    builder: (BuildContext context) {
                      return const FacultyDetailsTableScreen();
                    },
                  )),
                ),
                DashBoardItem(
                  text: 'Services',
                  image: 'services',
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ServiceStudentScreen(),
                      )),
                ),
              ]),
        ),
      ),
    );
  }

  Future<dynamic> showOutingInfo(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Outing Timing"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Weekdays'),
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: [
                    const Expanded(child: Text('Out Time: ')),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(timeOutWeekdays),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: [
                    const Expanded(child: Text('In Time: ')),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(timeInWeekdays),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20.0,
                ),
                const Text('Weekends'),
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: [
                    const Expanded(child: Text('Out Time: ')),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(timeOutWeekends),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: [
                    const Expanded(child: Text('In Time: ')),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(timeInWeekends),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel")),
              TextButton(
                  onPressed: () {
                    if ((DateTime.now().weekday != 6 ||
                            DateTime.now().weekday != 7)
                        ? (DateTime.now().hour <
                                (int.parse(timeOutWeekdays.split(":")[0])))
                            ? false
                            : (DateTime.now().minute <=
                                    (int.parse(timeOutWeekdays.split(":")[1])))
                                ? false
                                : true
                        : (DateTime.now().hour <
                                (int.parse(timeOutWeekends.split(":")[0])))
                            ? false
                            : (DateTime.now().minute <=
                                (int.parse(timeOutWeekends.split(":")[1])))) {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(
                        builder: (BuildContext context) {
                          return const OutingInOut();
                        },
                      ));
                    } else {
                      Navigator.pop(context);
                      toast("You can't go out now");
                    }
                  },
                  child: const Text("Next")),
            ],
          );
        });
  }
}
