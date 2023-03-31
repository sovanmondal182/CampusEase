import 'package:campus_ease/screens/service/service_add_complaint.dart';
import 'package:campus_ease/screens/service/service_view_complaint.dart';
import 'package:flutter/material.dart';

import '../../widgets/dashboard_item.dart';

class ServiceStudentScreen extends StatefulWidget {
  const ServiceStudentScreen({super.key});

  @override
  State<ServiceStudentScreen> createState() => _ServiceStudentScreenState();
}

class _ServiceStudentScreenState extends State<ServiceStudentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Service'),
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
            text: 'Register a Complaint',
            image: 'services',
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ServiceAddComplaint())),
          ),
          DashBoardItem(
            text: 'View Complaints',
            image: 'services',
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ServiceViewComplaints())),
          ),
        ],
      )),
    );
  }
}
