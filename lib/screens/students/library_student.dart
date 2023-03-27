import 'package:campus_ease/screens/students/library_in_out.dart';
import 'package:campus_ease/widgets/dashboard_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'view_issued_book.dart';

class LibraryStudentScreen extends StatefulWidget {
  const LibraryStudentScreen({super.key});

  @override
  State<LibraryStudentScreen> createState() => _LibraryStudentScreenState();
}

class _LibraryStudentScreenState extends State<LibraryStudentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Library'),
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
            text: 'View Issued Books',
            image: 'library',
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => ViewIssuedBook())),
          ),
          DashBoardItem(
            text: 'Library In-Out',
            image: 'outing',
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => LibraryInOut())),
          ),
        ],
      )),
    );
  }
}
