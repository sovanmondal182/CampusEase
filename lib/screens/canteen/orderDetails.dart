import 'package:campus_ease/apis/foodAPIs.dart';
import 'package:campus_ease/notifiers/authNotifier.dart';
import 'package:campus_ease/screens/canteen/order_deliver_scanner.dart';
import 'package:campus_ease/widgets/customRaisedButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_flutter/qr_flutter.dart';

class OrderDetailsPage extends StatefulWidget {
  final dynamic orderdata;

  OrderDetailsPage(this.orderdata);

  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  final GlobalKey globalKey = GlobalKey();
  @override
  void initState() {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    getUserDetails(authNotifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> items = widget.orderdata['items'];
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Text(
                "Order Details",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontFamily: 'MuseoModerno',
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ListView.builder(
                  // padding: EdgeInsets.only(left: 20, right: 20),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  itemBuilder: (context, int i) {
                    return ListTile(
                      title: Text(
                        "${items[i]["item_name"]}",
                        style: TextStyle(fontSize: 16),
                      ),
                      subtitle: Text("Quantity: ${items[i]["count"]}"),
                      trailing: Text(
                          "Price: ${items[i]["count"]} * ${items[i]["price"]} = ${items[i]["price"] * items[i]["count"]} INR"),
                    );
                  }),
              SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Ordered At: ${DateFormat("d MMM yyyy hh:mm aa").format(DateTime.parse(widget.orderdata['placed_at']))}",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'MuseoModerno',
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  (widget.orderdata['delivery_at'] != "null")
                      ? Text(
                          "Delivered At: ${DateFormat("d MMM yyyy hh:mm aa").format(DateTime.parse(widget.orderdata['delivery_at']))}",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: 'MuseoModerno',
                          ),
                        )
                      : Text(
                          "Delivered At: -",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: 'MuseoModerno',
                          ),
                        ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Total Amount: ${widget.orderdata['total'].toString()} INR",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'MuseoModerno',
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Status: ${widget.orderdata['is_delivered'] ? "Delivered" : "Pending"}",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'MuseoModerno',
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              (!widget.orderdata['is_delivered'])
                  ? GestureDetector(
                      onTap: () {
                        (authNotifier.userDetails!.role == "canteen")
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OrderDeliverScanner(
                                        orderdata: widget.orderdata)))
                            : showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Center(child: Text("Scan Me")),
                                    content: Container(
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.3),
                                            spreadRadius: 1,
                                            blurRadius: 1,
                                            offset: const Offset(1,
                                                2), // changes position of shadow
                                          ),
                                        ],
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: RepaintBoundary(
                                          key: globalKey,
                                          child: QrImage(
                                            gapless: true,
                                            padding: const EdgeInsets.all(10.0),
                                            backgroundColor: Colors.white,
                                            version: 5,
                                            semanticsLabel: 'Scan Me',
                                            data: widget.orderdata.id,
                                            dataModuleStyle: QrDataModuleStyle(
                                              dataModuleShape:
                                                  QrDataModuleShape.circle,
                                              color: Colors.black,
                                            ),
                                            eyeStyle: QrEyeStyle(
                                              eyeShape: QrEyeShape.circle,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text("Close"),
                                      ),
                                    ],
                                  );
                                });
                        // orderReceived(widget.orderdata.id, context);
                        print(widget.orderdata.id);
                      },
                      child: CustomRaisedButton(
                          buttonText:
                              (authNotifier.userDetails!.role == "canteen")
                                  ? 'Delivered'
                                  : 'Received'),
                    )
                  : Text(""),
            ],
          ),
        ),
      ),
    );
  }
}
