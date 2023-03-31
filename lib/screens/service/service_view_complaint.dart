import 'package:campus_ease/apis/foodAPIs.dart';
import 'package:campus_ease/models/complaint_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../notifiers/authNotifier.dart';
import '../../widgets/customRaisedButton.dart';

class ServiceViewComplaints extends StatefulWidget {
  const ServiceViewComplaints({super.key});

  @override
  State<ServiceViewComplaints> createState() => _ServiceViewComplaintsState();
}

class _ServiceViewComplaintsState extends State<ServiceViewComplaints> {
  List<ComplaintModel> _complaints = <ComplaintModel>[];
  String name = '';
  final _formKeyEdit = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Complaints'),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Card(
                child: TextField(
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search), hintText: 'Search...'),
                  onChanged: (val) {
                    setState(() {
                      name = val;
                    });
                  },
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: (authNotifier.userDetails!.role == 'admin' ||
                        authNotifier.userDetails!.role == 'worker')
                    ? FirebaseFirestore.instance
                        .collection('complaints')
                        .orderBy('date', descending: true)
                        .snapshots()
                    : FirebaseFirestore.instance
                        .collection('complaints')
                        .where('enroll_no',
                            isEqualTo: authNotifier.userDetails!.enrollNo)
                        .orderBy('date', descending: true)
                        .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData && snapshot.data!.docs.length > 0) {
                    _complaints = <ComplaintModel>[];
                    snapshot.data!.docs.forEach((item) {
                      _complaints.add(ComplaintModel(
                        name: item['name'],
                        hostelName: item['hostel_name'],
                        roomNo: item['room_no'],
                        phone: item['phone'],
                        message: item['message'],
                        status: item['status'],
                        type: item['type'],
                        date: item['date'],
                        solvedDate: item['solved_date'],
                        enrollNo: item['enroll_no'],
                        id: item.id,
                      ));
                    });
                    List<ComplaintModel> _suggestionList =
                        (name == '' || name == null)
                            ? _complaints
                            : _complaints
                                .where((element) =>
                                    element.type
                                        .toString()
                                        .toLowerCase()
                                        .contains(name.toLowerCase()) ||
                                    element.roomNo
                                        .toString()
                                        .toLowerCase()
                                        .contains(name.toLowerCase()) ||
                                    element.hostelName
                                        .toString()
                                        .toLowerCase()
                                        .contains(name.toLowerCase()) ||
                                    element.name
                                        .toString()
                                        .toLowerCase()
                                        .contains(name.toLowerCase()))
                                .toList();
                    if (_suggestionList.length > 0) {
                      return Container(
                        margin: const EdgeInsets.only(top: 10.0),
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _suggestionList.length,
                            itemBuilder: (context, int i) {
                              return GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  (authNotifier.userDetails!.role == 'worker' ||
                                          authNotifier.userDetails!.role ==
                                              'admin')
                                      ? showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return popupEditForm(
                                                context, _suggestionList[i]);
                                          })
                                      : null;
                                },
                                onLongPress: () {
                                  (authNotifier.userDetails!.role == 'worker' ||
                                          authNotifier.userDetails!.role ==
                                              'admin')
                                      ? showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text(
                                                  "Are you sure you want to delete?"),
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text("No")),
                                                TextButton(
                                                    onPressed: () {
                                                      deleteComplaint(
                                                          _suggestionList[i].id,
                                                          context);
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text("Yes")),
                                              ],
                                            );
                                          })
                                      : null;
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 20.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("${i + 1}. "),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              "Type: ${_suggestionList[i].type}"),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.01,
                                          ),
                                          Text(
                                              "Message: ${_suggestionList[i].message}"),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.01,
                                          ),
                                          if (authNotifier.userDetails!.role ==
                                                  'worker' ||
                                              authNotifier.userDetails!.role ==
                                                  'admin')
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    "Hostel Name: ${_suggestionList[i].hostelName}"),
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.01,
                                                ),
                                                Text(
                                                    "Room No: ${_suggestionList[i].roomNo}"),
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.01,
                                                ),
                                                Text(
                                                    "Name: ${_suggestionList[i].name}"),
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.01,
                                                ),
                                                Text(
                                                    "Phone: ${_suggestionList[i].phone}"),
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.01,
                                                ),
                                              ],
                                            ),
                                          Text(
                                              "Issue Date: ${DateFormat("d MMM yyyy hh:mm aa").format(DateTime.parse(_suggestionList[i].date))}"),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.01,
                                          ),
                                          _suggestionList[i].status != "Solved"
                                              ? Container()
                                              : Text(
                                                  "Solved Date: ${DateFormat("d MMM yyyy hh:mm aa").format(DateTime.parse(_suggestionList[i].solvedDate))}"),
                                          _suggestionList[i].status != "Solved"
                                              ? Container()
                                              : SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.01,
                                                ),
                                          Text(
                                              "Status: ${_suggestionList[i].status}"),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      );
                    } else {
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: const Text("No Items to display"),
                      );
                    }
                  } else {
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: const Text("No Items to display"),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      )),
    );
  }

  Widget popupEditForm(context, ComplaintModel data) {
    return AlertDialog(
        content: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              updateComplaint(data.id,
                  data.status == 'Solved' ? 'Pending' : 'Solved', context);
              if (data.status == 'Solved') {
                sendNotificationToSpecificUserByEnrollNo(
                    data.enrollNo,
                    'Services',
                    'Your complaint has been marked as solved',
                    'worker');
              }
              Navigator.pop(context);
            },
            child: CustomRaisedButton(
                buttonText: data.status == 'Solved' ? 'Pending' : 'Solved'),
          ),
        ),
      ],
    ));
  }
}
