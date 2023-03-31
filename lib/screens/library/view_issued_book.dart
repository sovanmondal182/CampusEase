import 'package:campus_ease/models/book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../notifiers/authNotifier.dart';

class ViewIssuedBook extends StatefulWidget {
  const ViewIssuedBook({super.key});

  @override
  State<ViewIssuedBook> createState() => _ViewIssuedBookState();
}

class _ViewIssuedBookState extends State<ViewIssuedBook> {
  List<Book> _books = <Book>[];
  String name = '';

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Issued Books'),
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
                stream: (authNotifier.userDetails!.role == 'admin')
                    ? FirebaseFirestore.instance.collection('books').snapshots()
                    : FirebaseFirestore.instance
                        .collection('books')
                        .where('enroll_no',
                            isEqualTo: authNotifier.userDetails!.enrollNo)
                        .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                    _books = <Book>[];
                    for (var item in snapshot.data!.docs) {
                      _books.add(Book(
                        bookId: item['book_id'],
                        bookName: item['book_name'],
                        issueDate:
                            DateTime.parse(item['date_issued'].toString()),
                        enrollNo: item['enroll_no'],
                      ));
                    }
                    List<Book> suggestionList = (name == '')
                        ? _books
                        : _books
                            .where((element) =>
                                element.bookName
                                    .toLowerCase()
                                    .contains(name.toLowerCase()) ||
                                element.bookId
                                    .toString()
                                    .toLowerCase()
                                    .contains(name.toLowerCase()) ||
                                element.enrollNo
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
                                            "Book Name: ${suggestionList[i].bookName}"),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.01,
                                        ),
                                        Text(
                                            "Book ID: ${suggestionList[i].bookId}"),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.01,
                                        ),
                                        Text(
                                            "Date Issued: ${DateFormat("d MMM yyyy hh:mm aa").format(suggestionList[i].issueDate)}"),
                                        if (authNotifier.userDetails!.role ==
                                            'admin')
                                          Column(
                                            children: [
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.01,
                                              ),
                                              Text(
                                                  "Issued to: ${suggestionList[i].enrollNo}"),
                                            ],
                                          ),
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
