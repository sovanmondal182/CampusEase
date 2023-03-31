import 'package:campus_ease/screens/outing/outing_in_out_log.dart';
import 'package:campus_ease/screens/outing/outing_setting.dart';
import 'package:campus_ease/widgets/dashboard_item.dart';
import 'package:flutter/material.dart';

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
        padding: const EdgeInsets.all(10.0),
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
                MaterialPageRoute(builder: (context) => const OutingSetting())),
          ),
          DashBoardItem(
            text: 'Outing Log',
            image: 'outing',
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const OutingInOutLog())),
          ),
        ],
      )),
    );
  }
}
