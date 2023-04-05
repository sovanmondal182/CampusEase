import 'package:campus_ease/notifiers/authNotifier.dart';
import 'package:campus_ease/screens/service/service_view_complaint.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../apis/allAPIs.dart';
import '../../widgets/dashboard_item.dart';

class ServiceAdminScreen extends StatefulWidget {
  const ServiceAdminScreen({super.key});

  @override
  State<ServiceAdminScreen> createState() => _ServiceAdminScreenState();
}

class _ServiceAdminScreenState extends State<ServiceAdminScreen> {
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
        title: const Text('Service'),
        actions: [
          if (authNotifier.userDetails!.role == 'worker')
            IconButton(
                onPressed: () => signOutUser(),
                icon: const Icon(Icons.logout_rounded))
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
