import 'package:campus_ease/screens/mess/mess_review_log.dart';
import 'package:campus_ease/screens/mess/mess_review_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../widgets/dashboard_item.dart';
import 'mess_scanner.dart';

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
        padding: EdgeInsets.all(10.0),
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
                MaterialPageRoute(builder: (context) => MessReviewLog())),
          ),
        ],
      )),
    );
  }
}
