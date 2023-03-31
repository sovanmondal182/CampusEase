import 'package:campus_ease/screens/library/library_in_out_log.dart';
import 'package:flutter/material.dart';

import '../../widgets/dashboard_item.dart';
import 'view_issued_book.dart';
import 'issue_book.dart';
import 'return_book.dart';

class LibraryAdmin extends StatefulWidget {
  const LibraryAdmin({super.key});

  @override
  State<LibraryAdmin> createState() => _LibraryAdminState();
}

class _LibraryAdminState extends State<LibraryAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Library'),
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
            text: 'Issue a Book',
            image: 'library',
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const IssueBookScreen())),
          ),
          DashBoardItem(
            text: 'Return a Book',
            image: 'library',
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ReturnBookScreen())),
          ),
          DashBoardItem(
            text: 'View Issued Books',
            image: 'library',
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ViewIssuedBook())),
          ),
          DashBoardItem(
              text: 'View In-Out Log',
              image: 'library',
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LibraryInOutLog()))),
        ],
      )),
    );
  }
}
