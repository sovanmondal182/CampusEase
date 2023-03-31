import 'package:campus_ease/apis/allAPIs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../widgets/customRaisedButton.dart';

class PublishNoticeScreen extends StatefulWidget {
  final String? id;
  const PublishNoticeScreen({super.key, this.id});

  @override
  State<PublishNoticeScreen> createState() => _PublishNoticeScreenState();
}

class _PublishNoticeScreenState extends State<PublishNoticeScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  fetch() async {
    CollectionReference itemRef =
        FirebaseFirestore.instance.collection('notices');
    if (widget.id != null) {
      await itemRef.doc(widget.id).get().then((value) {
        setState(() {
          _titleController.text = value['title'];
          _descriptionController.text = value['message'];
        });
      });
    } else {
      _titleController.text = "";
      _descriptionController.text = "";
    }
  }

  @override
  void initState() {
    _titleController.text = '';
    _descriptionController.text = '';
    fetch();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Publish Notice'),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
              child: Form(
                key: _formKey,
                child: Column(children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Expanded(
                        flex: 3,
                        child: Text(
                          "Title: ",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Expanded(
                        flex: 7,
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter title';
                            }
                            return null;
                          },
                          controller: _titleController,
                          keyboardType: TextInputType.text,
                          maxLines: 2,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(10.0),
                            border: OutlineInputBorder(),
                            hintText: 'Enter Title',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Expanded(
                        flex: 3,
                        child: Text(
                          "Description: ",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Expanded(
                        flex: 7,
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter description';
                            }
                            return null;
                          },
                          controller: _descriptionController,
                          keyboardType: TextInputType.text,
                          maxLines: 5,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(10.0),
                            border: OutlineInputBorder(),
                            hintText: 'Enter Description',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (_formKey.currentState!.validate() &&
                          _titleController.text.isNotEmpty &&
                          _descriptionController.text.isNotEmpty) {
                        if (widget.id != null) {
                          updateNotice(widget.id!, _titleController.text,
                              _descriptionController.text, context);
                        } else {
                          publishNotice(_titleController.text,
                              _descriptionController.text, context);
                        }

                        sendNotification(
                            _titleController.text, _descriptionController.text);

                        Navigator.pop(context);
                      }
                    },
                    child: CustomRaisedButton(
                        buttonText: widget.id != null ? 'Update' : 'Submit'),
                  ),
                ]),
              ),
            ),
          ),
        ));
  }
}
