import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:campus_ease/screens/profile/update_user_details.dart';

import '../../models/user.dart';

class AllUserScreen extends StatefulWidget {
  const AllUserScreen({super.key});

  @override
  State<AllUserScreen> createState() => _AllUserScreenState();
}

class _AllUserScreenState extends State<AllUserScreen> {
  List<User> _user = <User>[];
  String name = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Users'),
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
                stream:
                    FirebaseFirestore.instance.collection('users').snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                    _user = <User>[];
                    for (var item in snapshot.data!.docs) {
                      _user.add(User(
                        displayName: item['displayName'],
                        enrollNo: item['enroll_no'],
                        uuid: item['uuid'],
                      ));
                    }
                    List<User> suggestionList = (name == '')
                        ? _user
                        : _user
                            .where((element) =>
                                element.enrollNo
                                    .toString()
                                    .toLowerCase()
                                    .contains(name.toLowerCase()) ||
                                element.displayName
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
                              return GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              UpdateUserDetails(
                                                id: suggestionList[i].uuid!,
                                              )));
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
                                              "Name: ${suggestionList[i].displayName}"),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.01,
                                          ),
                                          Text(
                                              "Enroll No: ${suggestionList[i].enrollNo}"),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.01,
                                          ),
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
}
