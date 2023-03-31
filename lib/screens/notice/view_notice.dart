import 'package:campus_ease/apis/allAPIs.dart';
import 'package:campus_ease/screens/notice/publish_notice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/notice.dart';
import '../../notifiers/authNotifier.dart';

class ViewNoticeScreen extends StatefulWidget {
  const ViewNoticeScreen({super.key});

  @override
  State<ViewNoticeScreen> createState() => _ViewNoticeScreenState();
}

class _ViewNoticeScreenState extends State<ViewNoticeScreen> {
  List<Notice> _notice = <Notice>[];
  String name = '';

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Notices'),
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
                    .collection('notices')
                    .orderBy('published_at', descending: true)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                    _notice = <Notice>[];
                    for (var item in snapshot.data!.docs) {
                      _notice.add(Notice(
                        title: item['title'],
                        description: item['message'],
                        issueDate:
                            DateTime.parse(item['published_at'].toString()),
                        id: item.id,
                      ));
                    }
                    List<Notice> suggestionList = (name == '')
                        ? _notice
                        : _notice
                            .where((element) => element.title
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
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text(suggestionList[i].title),
                                          content: Text(
                                              suggestionList[i].description),
                                          actions: [
                                            if (authNotifier
                                                    .userDetails!.role ==
                                                'admin')
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                PublishNoticeScreen(
                                                                  id: suggestionList[
                                                                          i]
                                                                      .id,
                                                                )));
                                                  },
                                                  child: const Text("Edit")),
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text("Close"))
                                          ],
                                        );
                                      });
                                },
                                onLongPress: () {
                                  if (authNotifier.userDetails!.role ==
                                      'admin') {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text("Delete Notice"),
                                            content: const Text(
                                                "Are you sure you want to delete this notice?"),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    deleteNotice(
                                                        suggestionList[i].id);
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text("Yes")),
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text("No"))
                                            ],
                                          );
                                        });
                                  }
                                },
                                behavior: HitTestBehavior.opaque,
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
                                              "Title: ${suggestionList[i].title}"),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.01,
                                          ),
                                          Text(
                                              "Date Issued: ${DateFormat("d MMM yyyy hh:mm aa").format(suggestionList[i].issueDate)}"),
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
