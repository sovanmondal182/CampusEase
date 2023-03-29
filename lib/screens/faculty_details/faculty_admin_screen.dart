import 'package:campus_ease/screens/faculty_details/faculty_details_add.dart';
import 'package:campus_ease/screens/faculty_details/faculty_details_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../widgets/dashboard_item.dart';

class FacultyAdminScreen extends StatefulWidget {
  const FacultyAdminScreen({super.key});

  @override
  State<FacultyAdminScreen> createState() => _FacultyAdminScreenState();
}

class _FacultyAdminScreenState extends State<FacultyAdminScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Faculty Details'),
      ),
      body: SafeArea(
          child: GridView(
        padding: EdgeInsets.all(10.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.0,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
        ),
        children: [
          DashBoardItem(
            text: 'Add Faculty Details',
            image: 'faculty_details',
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FacultyDetailsAddScreen())),
          ),
          DashBoardItem(
            text: 'View Faculty Details',
            image: 'faculty_details',
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FacultyDetailsTableScreen())),
          ),
        ],
      )),
    );
  }
}
