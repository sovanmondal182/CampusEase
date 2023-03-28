import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/outing_in_out_model.dart';
import '../../notifiers/authNotifier.dart';

class OutingInOutLog extends StatefulWidget {
  const OutingInOutLog({super.key});

  @override
  State<OutingInOutLog> createState() => _OutingInOutLogState();
}

class _OutingInOutLogState extends State<OutingInOutLog> {
  List<OutingInOutModel> _inOut = <OutingInOutModel>[];
  String name = '';

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Outing Log'),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Card(
                child: TextField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search), hintText: 'Search...'),
                  onChanged: (val) {
                    setState(() {
                      name = val;
                    });
                  },
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('outingInOut')
                    .orderBy('in_time', descending: true)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData && snapshot.data!.docs.length > 0) {
                    _inOut = <OutingInOutModel>[];
                    snapshot.data!.docs.forEach((item) {
                      _inOut.add(OutingInOutModel(
                        inTime: item['in_time'],
                        outTime: item['out_time'],
                        enrollNo: item['enroll_no'],
                        late: item['late'],
                      ));
                    });
                    List<OutingInOutModel> _suggestionList =
                        (name == '' || name == null)
                            ? _inOut
                            : _inOut
                                .where((element) =>
                                    element.enrollNo
                                        .toString()
                                        .toLowerCase()
                                        .contains(name.toLowerCase()) ||
                                    element.late
                                        .toString()
                                        .toLowerCase()
                                        .contains(name.toLowerCase()) ||
                                    element.outTime
                                        .toString()
                                        .toLowerCase()
                                        .contains(name.toLowerCase()))
                                .toList();
                    if (_suggestionList.length > 0) {
                      return Container(
                        margin: EdgeInsets.only(top: 10.0),
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _suggestionList.length,
                            itemBuilder: (context, int i) {
                              return Container(
                                margin: EdgeInsets.only(bottom: 20.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${i + 1}. "),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            "Enroll No: ${_suggestionList[i].enrollNo}"),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.01,
                                        ),
                                        Text(
                                            "Out Time: ${DateFormat("d MMM yyyy hh:mm aa").format(DateTime.parse(_suggestionList[i].outTime))}"),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.01,
                                        ),
                                        _suggestionList[i].inTime == "null"
                                            ? const Text("In Time: -")
                                            : Text(
                                                "In Time: ${DateFormat("d MMM yyyy hh:mm aa").format(DateTime.parse(_suggestionList[i].inTime))}"),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.01,
                                        ),
                                        Text(
                                            "Status: ${_suggestionList[i].inTime == "null" ? "Out" : "In"}"),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.01,
                                        ),
                                        _suggestionList[i].late == true
                                            ? Text(
                                                "Late: Yes",
                                                style: TextStyle(
                                                    color: Colors.red),
                                              )
                                            : Container(),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }),
                      );
                    } else {
                      return Container(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Text("No Items to display"),
                      );
                    }
                  } else {
                    return Container(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Text("No Items to display"),
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
}
