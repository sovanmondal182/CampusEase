import 'package:flutter/material.dart';

import '../../apis/allAPIs.dart';
import '../../widgets/customRaisedButton.dart';

class IssueBookScreen extends StatefulWidget {
  const IssueBookScreen({super.key});

  @override
  State<IssueBookScreen> createState() => _IssueBookScreenState();
}

class _IssueBookScreenState extends State<IssueBookScreen> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    String? bookName;
    int? enrollNo, bookId;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Issue Book'),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Issue a Book",
                          style: TextStyle(
                            color: Color(0xFF8CBBF1),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          validator: (String? value) {
                            if (value!.length < 3) {
                              return "Not a valid name";
                            } else {
                              return null;
                            }
                          },
                          keyboardType: TextInputType.text,
                          onSaved: (String? value) {
                            bookName = value!;
                          },
                          cursorColor: const Color.fromARGB(255, 20, 27, 35),
                          decoration: const InputDecoration(
                            hintText: 'Book Name',

                            // icon: Icon(
                            //   Icons.fastfood,
                            //   color: Color(0xFF8CBBF1),
                            // ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          validator: (String? value) {
                            if (value!.length < 3) {
                              return "Not a valid Id";
                            } else if (int.tryParse(value) == null) {
                              return "Not a valid integer";
                            } else {
                              return null;
                            }
                          },
                          keyboardType: const TextInputType.numberWithOptions(),
                          onSaved: (String? value) {
                            bookId = int.parse(value!);
                          },
                          cursorColor: const Color(0xFF8CBBF1),
                          decoration: const InputDecoration(
                            hintText: 'Book ID',

                            // icon: Icon(
                            //   Icons.attach_money,
                            //   color: Color(0xFF8CBBF1),
                            // ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          validator: (String? value) {
                            if (value!.length != 14) {
                              return "Enroll No must be 14 digits";
                            } else if (int.tryParse(value) == null) {
                              return "Not a valid integer";
                            } else {
                              return null;
                            }
                          },
                          keyboardType: const TextInputType.numberWithOptions(),
                          onSaved: (String? value) {
                            enrollNo = int.parse(value!);
                          },
                          cursorColor: const Color(0xFF8CBBF1),
                          decoration: const InputDecoration(
                            hintText: 'Enrollment Number',

                            // icon: Icon(
                            //   Icons.add_shopping_cart,
                            //   color: Color(0xFF8CBBF1),
                            // ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      issueBook(bookName, bookId, enrollNo, context);
                    }
                  },
                  child: const CustomRaisedButton(buttonText: 'Issue'),
                ),
              ),
            ],
          ),
        ));
  }
}
