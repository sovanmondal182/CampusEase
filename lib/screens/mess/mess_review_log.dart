import 'package:campus_ease/models/mess_review_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessReviewLog extends StatefulWidget {
  const MessReviewLog({super.key});

  @override
  State<MessReviewLog> createState() => _MessReviewLogState();
}

class _MessReviewLogState extends State<MessReviewLog> {
  List<MessReviewModel> _inOut = <MessReviewModel>[];
  String name = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mess Review Log'),
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
                    .collection('mess_review')
                    .orderBy('date', descending: true)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                    _inOut = <MessReviewModel>[];
                    for (var item in snapshot.data!.docs) {
                      _inOut.add(MessReviewModel(
                        review: item['review'],
                        comment: item['comment'],
                        mealTyle: item['meal_type'],
                        date: item['date'],
                        enrollNo: item['enroll_no'],
                      ));
                    }
                    List<MessReviewModel> suggestionList = (name == '')
                        ? _inOut
                        : _inOut
                            .where((element) =>
                                element.enrollNo
                                    .toString()
                                    .toLowerCase()
                                    .contains(name.toLowerCase()) ||
                                element.date
                                    .toString()
                                    .toLowerCase()
                                    .contains(name.toLowerCase()) ||
                                element.review
                                    .toString()
                                    .toLowerCase()
                                    .contains(name.toLowerCase()) ||
                                element.mealTyle
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
                                            "Meal Type: ${suggestionList[i].mealTyle}"),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.01,
                                        ),
                                        Text(
                                            "Review: ${suggestionList[i].review}"),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.01,
                                        ),
                                        suggestionList[i].comment == ""
                                            ? const Text("Comment: -")
                                            : Text(
                                                "Comment: ${suggestionList[i].comment}"),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.01,
                                        ),
                                        Text(
                                            "Date: ${DateFormat("d MMM yyyy hh:mm aa").format(DateTime.parse(suggestionList[i].date))}"),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }),
                      );
                    } else {
                      return Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          // width: MediaQuery.of(context).size.width * 0.6,
                          child: const Text("No Items to display"),
                        ),
                      );
                    }
                  } else {
                    return Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        // width: MediaQuery.of(context).size.width * 0.6,
                        child: const Text("No Items to display"),
                      ),
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
