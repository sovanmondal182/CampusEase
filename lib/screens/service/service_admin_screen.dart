import 'package:campus_ease/screens/service/service_view_complaint.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../widgets/dashboard_item.dart';

class ServiceAdminScreen extends StatefulWidget {
  const ServiceAdminScreen({super.key});

  @override
  State<ServiceAdminScreen> createState() => _ServiceAdminScreenState();
}

class _ServiceAdminScreenState extends State<ServiceAdminScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Service'),
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
            text: 'View Complaints',
            image: 'services',
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ServiceViewComplaints())),
          ),
        ],
      )),
    );
  }
}
