import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';

import '../../apis/foodAPIs.dart';
import '../../notifiers/authNotifier.dart';
import '../../widgets/customRaisedButton.dart';

class ServiceAddComplaint extends StatefulWidget {
  const ServiceAddComplaint({super.key});

  @override
  State<ServiceAddComplaint> createState() => _ServiceAddComplaintState();
}

class _ServiceAddComplaintState extends State<ServiceAddComplaint> {
  final TextEditingController _reviewController = TextEditingController();
  final items = ['Water', 'Electricity', 'Wifi', 'Sweeper', 'Other'];
  String type = 'Water';

  @override
  void initState() {
    _reviewController.text = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Register a Complaint'),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(children: [
                Row(
                  children: [
                    const Text(
                      "Type: ",
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    DropdownButton(
                      // Initial Value
                      value: type,

                      // Down Arrow Icon
                      icon: const Icon(Icons.keyboard_arrow_down),

                      // Array list of items
                      items: items.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      // After selecting the desired option,it will
                      // change button value to selected value
                      onChanged: (String? newValue) {
                        setState(() {
                          type = newValue!;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Comment: ",
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      child: TextField(
                        controller: _reviewController,
                        keyboardType: TextInputType.text,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(10.0),
                          border: OutlineInputBorder(),
                          hintText: 'Enter your comment',
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
                    registerComplaint(authNotifier.userDetails, type,
                        _reviewController.text, context);
                    sendNotificationToRole(
                        type, _reviewController.text, 'worker', 'worker');
                    sendNotificationToSpecificUser(
                        authNotifier.userDetails!.uuid,
                        'Services',
                        'Your complaint has been registered',
                        'worker');
                    Navigator.pop(context);
                  },
                  child: CustomRaisedButton(buttonText: 'Submit'),
                ),
              ]),
            ),
          ),
        ));
  }
}
