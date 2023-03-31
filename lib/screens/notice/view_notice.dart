import 'package:campus_ease/apis/foodAPIs.dart';
import 'package:campus_ease/screens/notice/publish_notice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/book.dart';
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
                    .collection('notices')
                    .orderBy('published_at', descending: true)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData && snapshot.data!.docs.length > 0) {
                    _notice = <Notice>[];
                    snapshot.data!.docs.forEach((item) {
                      _notice.add(Notice(
                        title: item['title'],
                        description: item['message'],
                        issueDate:
                            DateTime.parse(item['published_at'].toString()),
                        id: item.id,
                      ));
                    });
                    List<Notice> _suggestionList = (name == '' || name == null)
                        ? _notice
                        : _notice
                            .where((element) => element.title
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
                              return GestureDetector(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text(_suggestionList[i].title),
                                          content: Text(
                                              _suggestionList[i].description),
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
                                                                  id: _suggestionList[
                                                                          i]
                                                                      .id,
                                                                )));
                                                  },
                                                  child: Text("Edit")),
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text("Close"))
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
                                            title: Text("Delete Notice"),
                                            content: Text(
                                                "Are you sure you want to delete this notice?"),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    deleteNotice(
                                                        _suggestionList[i].id);
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text("Yes")),
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text("No"))
                                            ],
                                          );
                                        });
                                  }
                                },
                                behavior: HitTestBehavior.opaque,
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 20.0),
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
                                              "Title: ${_suggestionList[i].title}"),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.01,
                                          ),
                                          Text(
                                              "Date Issued: ${DateFormat("d MMM yyyy hh:mm aa").format(_suggestionList[i].issueDate)}"),
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
