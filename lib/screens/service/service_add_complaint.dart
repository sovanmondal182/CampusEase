import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../apis/allAPIs.dart';
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
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
              child: Column(children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "Type: ",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: DropdownButton(
                        underline: const SizedBox(),
                        // Initial Value
                        value: type,

                        // Down Arrow Icon
                        icon: const Icon(Icons.arrow_drop_down),

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
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(
                      child: Text(
                        "Comment: ",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: _reviewController,
                        keyboardType: TextInputType.text,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          hoverColor: Color(0xFF8CBBF1),
                          focusColor: Color(0xFF8CBBF1),
                          contentPadding: EdgeInsets.all(10.0),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF8CBBF1),
                            ),
                          ),
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
                    if ((authNotifier.userDetails!.hostelName != null ||
                            authNotifier.userDetails!.hostelName != "") &&
                        (authNotifier.userDetails!.roomNo != null ||
                            authNotifier.userDetails!.roomNo != "")) {
                      registerComplaint(authNotifier.userDetails, type,
                          _reviewController.text, context);
                      sendNotificationToSpecificUser(
                          authNotifier.userDetails!.uuid,
                          'Services',
                          'Your complaint has been registered',
                          'worker');
                      Navigator.pop(context);
                    } else if ((authNotifier.userDetails!.hostelName == null ||
                            authNotifier.userDetails!.hostelName == "") &&
                        (authNotifier.userDetails!.roomNo == null ||
                            authNotifier.userDetails!.roomNo == "")) {
                      toast('Please update your hostel details in profile!');
                    } else if (authNotifier.userDetails!.hostelName == null ||
                        authNotifier.userDetails!.hostelName == "") {
                      toast('Please update your hostel name in profile!');
                    } else if (authNotifier.userDetails!.roomNo == null ||
                        authNotifier.userDetails!.roomNo == "") {
                      toast('Please update your room no in profile!');
                    }
                  },
                  child: const CustomRaisedButton(buttonText: 'Submit'),
                ),
              ]),
            ),
          ),
        ));
  }
}
