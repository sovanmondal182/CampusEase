// ignore_for_file: file_names

import 'dart:io';

import 'package:campus_ease/apis/allAPIs.dart';
import 'package:campus_ease/notifiers/authNotifier.dart';
import 'package:campus_ease/screens/canteen/orderDetails.dart';
import 'package:campus_ease/widgets/customRaisedButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  Razorpay? _razorpay;
  int money = 0;
  bool uploading = false;

  signOutUser() {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    if (authNotifier.user != null) {
      signOut(authNotifier, context);
    }
  }

  @override
  void initState() {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    getUserDetails(authNotifier);
    super.initState();
    _razorpay = Razorpay();
    _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay!.clear();
  }

  Future<void> updateProfileImage() async {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    setState(() {
      uploading = true;
    });
    String firebaseId = authNotifier.userDetails!.uuid!;

    await pickImageFromGallery().then((pickedFile) async {
      if (pickedFile == null) return;
      try {
        Reference storage =
            FirebaseStorage.instance.ref().child('profiles/$firebaseId');
        UploadTask uploadTask = storage.putFile(File(pickedFile.path));
        String imgUrl = await (await uploadTask).ref.getDownloadURL();
        authNotifier.userDetails!.photoUrl = imgUrl;
        profileUpdate(authNotifier.userDetails!);
        setState(() {
          uploading = true;
        });
      } catch (e) {
        debugPrint(e.toString());
      }
    });
  }

  Future<XFile?> pickImageFromGallery() async {
    return await ImagePicker().pickImage(source: ImageSource.gallery);
  }

  Future<CroppedFile?> cropSelectedImage(String filePath) async {
    return await ImageCropper().cropImage(
      sourcePath: filePath,
      aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallet'),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(top: 30, right: 10),
                ),
              ],
            ),
            (authNotifier.userDetails!.photoUrl != null)
                ? GestureDetector(
                    onTap: () async {
                      updateProfileImage();
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 40,
                      backgroundImage:
                          NetworkImage(authNotifier.userDetails!.photoUrl!),
                    ))
                : GestureDetector(
                    onTap: () async {
                      updateProfileImage();
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.grey.withOpacity(0.3),
                      radius: 40,
                      child: const Icon(
                        Icons.person,
                        size: 70,
                      ),
                    ),
                  ),
            const SizedBox(
              height: 20,
            ),
            authNotifier.userDetails!.displayName != null
                ? Text(
                    authNotifier.userDetails!.displayName!,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontFamily: 'MuseoModerno',
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : const Text("You don't have a user name"),
            const SizedBox(
              height: 10,
            ),
            authNotifier.userDetails!.balance != null
                ? Text(
                    "Balance: ₹${authNotifier.userDetails!.balance}",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'MuseoModerno',
                    ),
                  )
                : const Text(
                    "Balance: ₹0",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'MuseoModerno',
                    ),
                  ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return popupForm(context);
                    });
              },
              child: const CustomRaisedButton(buttonText: 'Add Money'),
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              "Order History",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontFamily: 'MuseoModerno',
              ),
              textAlign: TextAlign.left,
            ),
            myOrders(authNotifier.userDetails!.uuid),
          ],
        ),
      ),
    );
  }

  Widget myOrders(uid) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('orders')
          .where('placed_by', isEqualTo: uid)
          .orderBy("is_delivered")
          .orderBy("placed_at", descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          List<dynamic> orders = snapshot.data!.docs;
          return Container(
            margin: const EdgeInsets.only(top: 10.0),
            child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: orders.length,
                itemBuilder: (context, int i) {
                  return GestureDetector(
                    child: Card(
                      color: Colors.transparent,
                      elevation: 0,
                      child: ListTile(
                          minLeadingWidth: 5,
                          enabled: !orders[i]['is_delivered'],
                          leading: Text("${(i + 1)}."),
                          title: Text(
                              "Order ID: ${orders[i].id.substring(orders[i].id.length - 5)}"),
                          subtitle: Text(
                              'Total Amount: ₹${orders[i]['total'].toString()}'),
                          trailing: Text(
                              'Status: ${(orders[i]['is_delivered']) ? "Delivered" : "Pending"}')),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  OrderDetailsPage(orders[i])));
                    },
                  );
                }),
          );
        } else {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            width: MediaQuery.of(context).size.width * 0.6,
            child: const Text(""),
          );
        }
      },
    );
  }

  Widget popupForm(context) {
    int amount = 0;
    return AlertDialog(
        content: Stack(
      // overflow: Overflow.visible,
      children: <Widget>[
        Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.always,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Deposit Money",
                  style: TextStyle(
                    color: Color(0xFF8CBBF1),
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  validator: (String? value) {
                    if (int.tryParse(value!) == null) {
                      return "Not a valid integer";
                    } else if (int.parse(value) < 100) {
                      return "Minimum Deposit is ₹100";
                    } else if (int.parse(value) > 1000) {
                      return "Maximum Deposit is ₹1000";
                    } else {
                      return null;
                    }
                  },
                  keyboardType: const TextInputType.numberWithOptions(),
                  onSaved: (String? value) {
                    amount = int.parse(value!);
                  },
                  cursorColor: const Color(0xFF8CBBF1),
                  decoration: const InputDecoration(
                    hintText: 'Money in INR',
                    icon: Icon(
                      Icons.attach_money,
                      color: Color(0xFF8CBBF1),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      return openCheckout(amount);
                    }
                  },
                  child: const CustomRaisedButton(buttonText: 'Add Money'),
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }

  void openCheckout(int amount) async {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    money = amount;
    var options = {
      'key': 'rzp_test_rpAQaSlgUesRkn',
      'amount': money * 100,
      'name': authNotifier.userDetails!.displayName,
      'description': "${authNotifier.userDetails!.uuid} - ${DateTime.now()}",
      'prefill': {
        'contact': authNotifier.userDetails!.phone,
        'email': authNotifier.userDetails!.email
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay!.open(options);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void toast(String data) {
    Fluttertoast.showToast(
        msg: data,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey,
        textColor: Colors.white);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    addMoney(money, context, authNotifier.userDetails!.uuid!);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    toast("ERROR: ${response.code} - ${response.message!}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    toast("EXTERNAL_WALLET: ${response.walletName!}");
    Navigator.pop(context);
  }
}
