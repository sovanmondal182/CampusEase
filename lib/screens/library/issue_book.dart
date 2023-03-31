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
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Issue a Book",
                    style: TextStyle(
                      color: Color.fromRGBO(255, 63, 111, 1),
                      fontSize: 25,
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
                    cursorColor: const Color.fromRGBO(255, 63, 111, 1),
                    decoration: const InputDecoration(
                      hintText: 'Book Name',
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(255, 63, 111, 1),
                      ),
                      // icon: Icon(
                      //   Icons.fastfood,
                      //   color: Color.fromRGBO(255, 63, 111, 1),
                      // ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    validator: (String? value) {
                      if (value!.length < 3) {
                        return "Not a valid bookId";
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
                    cursorColor: const Color.fromRGBO(255, 63, 111, 1),
                    decoration: const InputDecoration(
                      hintText: 'Book ID',
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(255, 63, 111, 1),
                      ),
                      // icon: Icon(
                      //   Icons.attach_money,
                      //   color: Color.fromRGBO(255, 63, 111, 1),
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
                    cursorColor: const Color.fromRGBO(255, 63, 111, 1),
                    decoration: const InputDecoration(
                      hintText: 'Enrollment Number',
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(255, 63, 111, 1),
                      ),
                      // icon: Icon(
                      //   Icons.add_shopping_cart,
                      //   color: Color.fromRGBO(255, 63, 111, 1),
                      // ),
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
          ),
        ));
  }
}
