import 'package:campus_ease/screens/outing/outing_in_out_log.dart';
import 'package:campus_ease/screens/outing/outing_setting.dart';
import 'package:campus_ease/widgets/dashboard_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../apis/allAPIs.dart';
import '../../notifiers/authNotifier.dart';

class OutingAdmin extends StatefulWidget {
  const OutingAdmin({super.key});

  @override
  State<OutingAdmin> createState() => _OutingAdminState();
}

class _OutingAdminState extends State<OutingAdmin> {
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

  signOutUser() {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    if (authNotifier.user != null) {
      signOut(authNotifier, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: (authNotifier.userDetails!.role == 'guard')
            ? const Text(
                'CampusEase',
                style: TextStyle(
                    color: Color(0xFF8CBBF1),
                    fontWeight: FontWeight.w800,
                    fontSize: 26),
              )
            : const Text('Outing'),
        actions: [
          if (authNotifier.userDetails!.role == 'guard')
            IconButton(
              icon: const Icon(
                Icons.logout_rounded,
                color: Colors.black,
              ),
              onPressed: () {
                signOutUser();
              },
            )
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
            text: 'Outing Setting',
            image: 'outing',
            onTap: () {
              if (authNotifier.userDetails!.role != "guard") {
                return Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const OutingSetting()));
              } else {
                showOutingInfo(context);
              }
            },
          ),
          DashBoardItem(
            text: 'Outing Log',
            image: 'outing',
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const OutingInOutLog())),
          ),
        ],
      )),
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
                  child: const Text("Ok")),
            ],
          );
        });
  }
}
