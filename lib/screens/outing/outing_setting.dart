// ignore_for_file: avoid_print

import 'package:campus_ease/apis/allAPIs.dart';
import 'package:campus_ease/widgets/customRaisedButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

class OutingSetting extends StatefulWidget {
  const OutingSetting({super.key});

  @override
  State<OutingSetting> createState() => _OutingSettingState();
}

class _OutingSettingState extends State<OutingSetting> {
  TextEditingController timeInWeekdays = TextEditingController();
  TextEditingController timeOutWeekdays = TextEditingController();
  TextEditingController timeInWeekends = TextEditingController();
  TextEditingController timeOutWeekends = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  fetch() async {
    CollectionReference itemRef =
        FirebaseFirestore.instance.collection('outing_setting');

    await itemRef
        .where('timeInWeekdays', isNotEqualTo: null)
        .get()
        .then((value) async {
      for (var element in value.docs) {
        timeInWeekdays.text = element['timeInWeekdays'];
        timeOutWeekdays.text = element['timeOutWeekdays'];
        timeInWeekends.text = element['timeInWeekends'];
        timeOutWeekends.text = element['timeOutWeekends'];
      }
    });
  }

  updateTiming() async {
    CollectionReference itemRef =
        FirebaseFirestore.instance.collection('outing_setting');

    await itemRef
        .where('timeInWeekdays', isNotEqualTo: null)
        .get()
        .then((value) async {
      if (value.docs.isNotEmpty) {
        await itemRef.doc(value.docs[0].id).update({
          'timeInWeekdays': timeInWeekdays.text,
          'timeOutWeekdays': timeOutWeekdays.text,
          'timeInWeekends': timeInWeekends.text,
          'timeOutWeekends': timeOutWeekends.text,
        });
        sendNotificationToRole('Outing',
            'Outing timing changed! Please check it out!', 'user', 'outing');
      } else {
        await itemRef
            .doc()
            .set({
              'timeInWeekdays': timeInWeekdays.text,
              'timeOutWeekdays': timeOutWeekdays.text,
              'timeInWeekends': timeInWeekends.text,
              'timeOutWeekends': timeOutWeekends.text,
            })
            .then((value) => print("Timings Updated"))
            .catchError((error) => print("Failed to add user: $error"));
      }
    });
  }

  @override
  void initState() {
    fetch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Outing Setting'),
      ),
      body: SafeArea(
          child: Container(
              margin: const EdgeInsets.all(10.0),
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const Text(
                          'Weekdays',
                          style: TextStyle(fontSize: 20),
                        ),
                        Row(
                          children: [
                            const Expanded(child: Text('Out Time: ')),
                            const SizedBox(
                              width: 10.0,
                            ),
                            Expanded(
                              flex: 3,
                              child: TextField(
                                controller: timeOutWeekdays,
                                decoration:
                                    const InputDecoration(hintText: "Out Time"),
                                readOnly: true,
                                onTap: () async {
                                  TimeOfDay? pickedTime = await showTimePicker(
                                    initialTime: TimeOfDay.now(),
                                    context: context,
                                  );

                                  if (pickedTime != null && mounted) {
                                    DateTime parsedTime = DateFormat.jm().parse(
                                        pickedTime.format(context).toString());

                                    String formattedTime =
                                        DateFormat('HH:mm').format(parsedTime);

                                    setState(() {
                                      timeOutWeekdays.text = formattedTime;
                                    });
                                  } else {}
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: [
                            const Expanded(child: Text('In Time: ')),
                            const SizedBox(
                              width: 10.0,
                            ),
                            Expanded(
                              flex: 3,
                              child: TextField(
                                controller: timeInWeekdays,
                                decoration:
                                    const InputDecoration(hintText: "In Time"),
                                readOnly: true,
                                onTap: () async {
                                  TimeOfDay? pickedTime = await showTimePicker(
                                    initialTime: TimeOfDay.now(),
                                    context: context,
                                  );

                                  if (pickedTime != null && mounted) {
                                    DateTime parsedTime = DateFormat.jm().parse(
                                        pickedTime.format(context).toString());

                                    String formattedTime =
                                        DateFormat('HH:mm').format(parsedTime);

                                    setState(() {
                                      timeInWeekdays.text = formattedTime;
                                    });
                                  } else {}
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        const Text(
                          'Weekends',
                          style: TextStyle(fontSize: 20),
                        ),
                        Row(
                          children: [
                            const Expanded(child: Text('Out Time: ')),
                            const SizedBox(
                              width: 10.0,
                            ),
                            Expanded(
                              flex: 3,
                              child: TextField(
                                controller: timeOutWeekends,
                                decoration:
                                    const InputDecoration(hintText: "Out Time"),
                                readOnly: true,
                                onTap: () async {
                                  TimeOfDay? pickedTime = await showTimePicker(
                                    initialTime: TimeOfDay.now(),
                                    context: context,
                                  );

                                  if (pickedTime != null && mounted) {
                                    DateTime parsedTime = DateFormat.jm().parse(
                                        pickedTime.format(context).toString());

                                    String formattedTime =
                                        DateFormat('HH:mm').format(parsedTime);

                                    setState(() {
                                      timeOutWeekends.text = formattedTime;
                                    });
                                  } else {}
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: [
                            const Expanded(child: Text('In Time: ')),
                            const SizedBox(
                              width: 10.0,
                            ),
                            Expanded(
                              flex: 3,
                              child: TextField(
                                controller: timeInWeekends,
                                decoration:
                                    const InputDecoration(hintText: "In Time"),
                                readOnly: true,
                                onTap: () async {
                                  TimeOfDay? pickedTime = await showTimePicker(
                                    initialTime: TimeOfDay.now(),
                                    context: context,
                                  );

                                  if (pickedTime != null && mounted) {
                                    DateTime parsedTime = DateFormat.jm().parse(
                                        pickedTime.format(context).toString());

                                    String formattedTime =
                                        DateFormat('HH:mm').format(parsedTime);

                                    setState(() {
                                      timeInWeekends.text = formattedTime;
                                    });
                                  } else {}
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (_formKey.currentState!.validate() &&
                          timeInWeekdays.text.isNotEmpty &&
                          timeOutWeekdays.text.isNotEmpty &&
                          timeInWeekends.text.isNotEmpty &&
                          timeOutWeekends.text.isNotEmpty) {
                        updateTiming();
                        Navigator.pop(context);
                      }
                    },
                    child: const CustomRaisedButton(
                      buttonText: "Update",
                    ),
                  ),
                ],
              ))),
    );
  }
}
