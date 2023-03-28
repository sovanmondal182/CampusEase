import 'package:campus_ease/screens/library/library_in_out.dart';
import 'package:campus_ease/screens/outing/outing_in_out_log.dart';
import 'package:campus_ease/screens/outing/outing_setting.dart';
import 'package:campus_ease/widgets/dashboard_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'outing_in_out.dart';

class OutingAdmin extends StatefulWidget {
  const OutingAdmin({super.key});

  @override
  State<OutingAdmin> createState() => _OutingAdminState();
}

class _OutingAdminState extends State<OutingAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Outing'),
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
            text: 'Outing Setting',
            image: 'outing',
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => OutingSetting())),
          ),
          DashBoardItem(
            text: 'Outing Log',
            image: 'outing',
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => OutingInOutLog())),
          ),
        ],
      )),
    );
  }
}
