import 'package:flutter/material.dart';

import '../../apis/allAPIs.dart';
import '../../widgets/customRaisedButton.dart';

class ReturnBookScreen extends StatefulWidget {
  const ReturnBookScreen({super.key});

  @override
  State<ReturnBookScreen> createState() => _ReturnBookScreenState();
}

class _ReturnBookScreenState extends State<ReturnBookScreen> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    int? bookId;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Return Book'),
        ),
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
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
                    child: GestureDetector(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          returnBook(bookId.toString(), context);
                        }
                      },
                      child: const CustomRaisedButton(buttonText: 'Return'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
