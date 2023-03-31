import 'package:campus_ease/screens/mess/mess_review_log.dart';
import 'package:flutter/material.dart';

import '../../widgets/dashboard_item.dart';

class MessAdminScreen extends StatefulWidget {
  const MessAdminScreen({super.key});

  @override
  State<MessAdminScreen> createState() => _MessAdminScreenState();
}

class _MessAdminScreenState extends State<MessAdminScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mess'),
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
            text: 'Review Log',
            image: 'mess',
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const MessReviewLog())),
          ),
        ],
      )),
    );
  }
}
