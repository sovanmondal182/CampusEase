import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/book.dart';
import '../../models/library_in_out_model.dart';
import '../../notifiers/authNotifier.dart';

class LibraryInOutLog extends StatefulWidget {
  const LibraryInOutLog({super.key});

  @override
  State<LibraryInOutLog> createState() => _LibraryInOutLogState();
}

class _LibraryInOutLogState extends State<LibraryInOutLog> {
  List<LibraryInOut> _inOut = <LibraryInOut>[];
  String name = '';

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Library In Out Log'),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
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
                  .collection('libraryInOut')
                  .orderBy('in_time', descending: true)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData && snapshot.data!.docs.length > 0) {
                  _inOut = <LibraryInOut>[];
                  snapshot.data!.docs.forEach((item) {
                    _inOut.add(LibraryInOut(
                      inTime: item['in_time'],
                      outTime: item['out_time'],
                      enrollNo: item['enroll_no'],
                    ));
                  });
                  List<LibraryInOut> _suggestionList =
                      (name == '' || name == null)
                          ? _inOut
                          : _inOut
                              .where((element) => element.enrollNo
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
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.01,
                                      ),
                                      Text(
                                          "In Time: ${DateFormat("d MMM yyyy hh:mm aa").format(DateTime.parse(_suggestionList[i].inTime))}"),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.01,
                                      ),
                                      _suggestionList[i].outTime == "null"
                                          ? const Text("Out Time: -")
                                          : Text(
                                              "Out Time: ${DateFormat("d MMM yyyy hh:mm aa").format(DateTime.parse(_suggestionList[i].outTime))}"),
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
      )),
    );
  }
}
