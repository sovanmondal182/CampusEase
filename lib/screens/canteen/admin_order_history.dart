import 'package:campus_ease/apis/allAPIs.dart';
import 'package:campus_ease/notifiers/authNotifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'orderDetails.dart';

class AdminOrderDetailsPage extends StatefulWidget {
  const AdminOrderDetailsPage({super.key});

  @override
  State<AdminOrderDetailsPage> createState() => _AdminOrderDetailsPageState();
}

class _AdminOrderDetailsPageState extends State<AdminOrderDetailsPage> {
  final GlobalKey globalKey = GlobalKey();
  @override
  void initState() {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    getUserDetails(authNotifier);
    super.initState();
  }

  signOutUser() {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    if (authNotifier.user != null) {
      signOut(authNotifier, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.logout_rounded,
              color: Colors.white,
            ),
            onPressed: () {
              signOutUser();
            },
          )
        ],
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('orders')
              .orderBy("placed_at", descending: true)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
              List<dynamic> orders = snapshot.data!.docs;
              return Container(
                margin: const EdgeInsets.only(top: 10.0),
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: orders.length,
                    itemBuilder: (context, int i) {
                      return GestureDetector(
                        child: Card(
                          child: ListTile(
                              enabled: !orders[i]['is_delivered'],
                              title: Text(
                                  "#${(i + 1)} Order ID: ${orders[i].id.substring(orders[i].id.length - 5)}"),
                              subtitle: Text(
                                  'Total Amount: ${orders[i]['total'].toString()} INR'),
                              trailing: Text(
                                  'Status: ${(orders[i]['is_delivered']) ? "Delivered" : "Pending"}')),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      OrderDetailsPage(orders[i])));
                        },
                      );
                    }),
              );
            } else {
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                width: MediaQuery.of(context).size.width * 0.6,
                child: const Text(""),
              );
            }
          },
        ),
      ),
    );
  }
}
