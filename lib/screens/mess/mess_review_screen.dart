import 'package:campus_ease/apis/allAPIs.dart';
import 'package:campus_ease/notifiers/authNotifier.dart';
import 'package:campus_ease/widgets/customRaisedButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MessReviewScreen extends StatefulWidget {
  const MessReviewScreen({super.key});

  @override
  State<MessReviewScreen> createState() => _MessReviewScreenState();
}

class _MessReviewScreenState extends State<MessReviewScreen> {
  final TextEditingController _reviewController = TextEditingController();
  final items = ['Good', 'Average', 'Bad'];
  final type = ['Breakfast', 'Lunch', 'Dinner'];
  String review = 'Good';
  String mealType = 'Breakfast';

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
          title: const Text('Mess Review'),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(children: [
                Row(
                  children: [
                    const Text(
                      "Review: ",
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    DropdownButton(
                      // Initial Value
                      value: review,

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
                          review = newValue!;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: [
                    const Text(
                      "Meal Type: ",
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    DropdownButton(
                      // Initial Value
                      value: mealType,

                      // Down Arrow Icon
                      icon: const Icon(Icons.keyboard_arrow_down),

                      // Array list of items
                      items: type.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      // After selecting the desired option,it will
                      // change button value to selected value
                      onChanged: (String? newValue) {
                        setState(() {
                          mealType = newValue!;
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
                    messReview(
                        review,
                        mealType,
                        authNotifier.userDetails!.enrollNo,
                        _reviewController.text,
                        context);
                  },
                  child: const CustomRaisedButton(buttonText: 'Submit'),
                ),
              ]),
            ),
          ),
        ));
  }
}
