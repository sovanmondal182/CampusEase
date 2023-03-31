import 'package:campus_ease/screens/notice/publish_notice.dart';
import 'package:campus_ease/screens/notice/view_notice.dart';
import 'package:flutter/material.dart';

import '../../widgets/dashboard_item.dart';

class NoticeAdminScreen extends StatefulWidget {
  const NoticeAdminScreen({super.key});

  @override
  State<NoticeAdminScreen> createState() => _NoticeAdminScreenState();
}

class _NoticeAdminScreenState extends State<NoticeAdminScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notice Board'),
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
            text: 'Publish a Notice',
            image: 'notice_board',
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const PublishNoticeScreen())),
          ),
          DashBoardItem(
            text: 'View Notices',
            image: 'notice_board',
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ViewNoticeScreen())),
          ),
        ],
      )),
    );
  }
}
