import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/library_in_out_model.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Library In Out Log'),
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
                stream: FirebaseFirestore.instance
                    .collection('libraryInOut')
                    .orderBy('in_time', descending: true)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                    _inOut = <LibraryInOut>[];
                    for (var item in snapshot.data!.docs) {
                      _inOut.add(LibraryInOut(
                        inTime: item['in_time'],
                        outTime: item['out_time'],
                        enrollNo: item['enroll_no'],
                      ));
                    }
                    List<LibraryInOut> suggestionList = (name == '')
                        ? _inOut
                        : _inOut
                            .where((element) => element.enrollNo
                                .toString()
                                .toLowerCase()
                                .contains(name.toLowerCase()))
                            .toList();
                    if (suggestionList.isNotEmpty) {
                      return Container(
                        margin: const EdgeInsets.only(top: 10.0),
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: suggestionList.length,
                            itemBuilder: (context, int i) {
                              return Container(
                                margin: const EdgeInsets.only(bottom: 20.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${i + 1}. "),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            "Enroll No: ${suggestionList[i].enrollNo}"),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.01,
                                        ),
                                        Text(
                                            "In Time: ${DateFormat("d MMM yyyy hh:mm aa").format(DateTime.parse(suggestionList[i].inTime))}"),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.01,
                                        ),
                                        suggestionList[i].outTime == "null"
                                            ? const Text("Out Time: -")
                                            : Text(
                                                "Out Time: ${DateFormat("d MMM yyyy hh:mm aa").format(DateTime.parse(suggestionList[i].outTime))}"),
                                      ],
                                    ),
                                  ],
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
}
