// ignore_for_file: use_build_context_synchronously, file_names

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'package:campus_ease/models/food.dart';
import 'package:campus_ease/models/user.dart' as u;
import 'package:campus_ease/notifiers/authNotifier.dart';
import 'package:campus_ease/screens/login/login.dart';

import '../notificationservice/local_notification_service.dart';
import '../screens/canteen/canteen_adminhomepage.dart';
import '../screens/canteen/canteen_navigationBar.dart';
import '../screens/dashboard/admin_dashboard.dart';
import '../screens/dashboard/faculty_dashboard.dart';
import '../screens/dashboard/student_dashboard_screen.dart';
import '../screens/notice/view_notice.dart';
import '../screens/outing/outing_admin.dart';
import '../screens/service/service_admin_screen.dart';

void toast(String data) {
  Fluttertoast.showToast(
      msg: data,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.grey,
      textColor: Colors.white);
}

login(u.User user, AuthNotifier authNotifier, BuildContext context) async {
  final UserCredential authResult;
  EasyLoading.show();
  try {
    authResult = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: user.email!, password: user.password!);
  } catch (error) {
    EasyLoading.dismiss();
    toast(error.toString());
    return;
  }

  try {
    User? firebaseUser = authResult.user;
    if (!firebaseUser!.emailVerified) {
      await FirebaseAuth.instance.signOut();
      EasyLoading.dismiss();
      toast("Email ID not verified");
      return;
    } else {
      authNotifier.setUser(firebaseUser);
    }
    await getUserDetails(authNotifier);
    initializeCurrentUser(authNotifier, context);
    EasyLoading.dismiss();

    (authNotifier.userDetails!.role == 'admin')
        ? Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (BuildContext context) {
              return const AdminDashboardScreen();
            },
          ))
        : (authNotifier.userDetails!.role == 'faculty')
            ? Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (BuildContext context) {
                  return const FacultyDashboardScreen();
                },
              ))
            : (authNotifier.userDetails!.role == 'worker')
                ? Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (BuildContext context) {
                      return const ServiceAdminScreen();
                    },
                  ))
                : (authNotifier.userDetails!.role == 'canteen')
                    ? Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (BuildContext context) {
                          return const AdminHomePage();
                        },
                      ))
                    : (authNotifier.userDetails!.role == 'warden')
                        ? Navigator.pushReplacement(context, MaterialPageRoute(
                            builder: (BuildContext context) {
                              return const FacultyDashboardScreen();
                            },
                          ))
                        : (authNotifier.userDetails!.role == 'librarian')
                            ? Navigator.pushReplacement(context,
                                MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return const FacultyDashboardScreen();
                                },
                              ))
                            : (authNotifier.userDetails!.role == 'guard')
                                ? Navigator.pushReplacement(context,
                                    MaterialPageRoute(
                                    builder: (BuildContext context) {
                                      return const OutingAdmin();
                                    },
                                  ))
                                : Navigator.pushReplacement(context,
                                    MaterialPageRoute(
                                    builder: (BuildContext context) {
                                      return const StudentDashBoardScreen();
                                    },
                                  ));
  } catch (error) {
    EasyLoading.dismiss();
    toast(error.toString());
    return;
  }
}

signUp(u.User user, AuthNotifier authNotifier, BuildContext context) async {
  EasyLoading.show();
  bool userDataUploaded = false;
  final UserCredential authResult;
  try {
    authResult = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: user.email!.trim(), password: user.password!);
  } catch (error) {
    EasyLoading.dismiss();
    toast(error.toString());
    return;
  }

  try {
    User? firebaseUser = authResult.user;
    await firebaseUser!.sendEmailVerification();

    await firebaseUser.updateDisplayName(user.displayName);
    await firebaseUser.reload();
    uploadUserData(user, userDataUploaded);
    await FirebaseAuth.instance.signOut();
    authNotifier.setUser(null);
    EasyLoading.dismiss();

    toast("Verification link is sent to ${user.email}");
    initializeCurrentUser(authNotifier, context);
    Navigator.pop(context);
  } catch (error) {
    EasyLoading.dismiss();

    toast(error.toString());
    return;
  }
}

getUserDetails(AuthNotifier authNotifier) async {
  await FirebaseFirestore.instance
      .collection('users')
      .doc(authNotifier.user!.uid)
      .get()
      .catchError((e) => (e))
      .then((value) => {
            (value.exists)
                ? authNotifier.setUserDetails(u.User.fromMap(value.data()!))
                : null
          });
}

uploadUserData(u.User user, bool userdataUpload) async {
  bool userDataUploadVar = userdataUpload;
  User? currentUser = FirebaseAuth.instance.currentUser;

  CollectionReference userRef = FirebaseFirestore.instance.collection('users');
  CollectionReference cartRef = FirebaseFirestore.instance.collection('carts');

  user.uuid = currentUser!.uid;
  user.deviceToken = "";
  if (userDataUploadVar != true) {
    await userRef
        .doc(currentUser.uid)
        .set(user.toMap())
        .catchError((e) => debugPrint(e))
        .then((value) => userDataUploadVar = true);
    await cartRef
        .doc(currentUser.uid)
        .set({})
        .catchError((e) => debugPrint(e))
        .then((value) => userDataUploadVar = true);
  } else {}
}

initializeCurrentUser(AuthNotifier authNotifier, BuildContext context) async {
  User? firebaseUser = FirebaseAuth.instance.currentUser;
  String deviceTokenToSendPushNotification = "";
  Future<void> getDeviceTokenToSendNotification() async {
    final FirebaseMessaging fcm = FirebaseMessaging.instance;
    final token = await fcm.getToken();
    deviceTokenToSendPushNotification = token.toString();
    if (deviceTokenToSendPushNotification != "" &&
        authNotifier.userDetails != null) {
      CollectionReference deviceRef =
          FirebaseFirestore.instance.collection('devices');
      CollectionReference userRef =
          FirebaseFirestore.instance.collection('users');
      await userRef
          .doc(authNotifier.userDetails!.uuid)
          .update({'device_token': deviceTokenToSendPushNotification})
          .catchError((e) => (e))
          .then((value) => debugPrint("Device Token Updated"));

      await deviceRef
          .doc(authNotifier.userDetails!.uuid)
          .set({
            'device_token': deviceTokenToSendPushNotification,
            'role': authNotifier.userDetails!.role
          })
          .catchError((e) => debugPrint(e))
          .then((value) => debugPrint("Device Token Added"));
    }
  }

  if (firebaseUser != null) {
    authNotifier.setUser(firebaseUser);
    await getUserDetails(authNotifier);
    await getDeviceTokenToSendNotification();
  }
}

initilizeFirebaseMessage(BuildContext context) {
  // 1. This method call when app in terminated state and you get a notification
  // when you click on notification app open from terminated state and you can get notification data in this method

  FirebaseMessaging.instance.getInitialMessage().then(
    (message) {
      if (message != null) {
        if (message.data['_id'] != null) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const ViewNoticeScreen(
                  // id: message.data['_id'],
                  ),
            ),
          );
        }
      }
    },
  );
  // 2. This method only call when App in forground it mean app must be opened
  FirebaseMessaging.onMessage.listen(
    (message) {
      if (message.notification != null) {
        LocalNotificationService.createanddisplaynotification(message);
      }
    },
  );

  // 3. This method only call when App in background and not terminated(not closed)
  FirebaseMessaging.onMessageOpenedApp.listen(
    (message) {
      if (message.notification != null) {}
    },
  );
}

signOut(AuthNotifier authNotifier, BuildContext context) async {
  await FirebaseAuth.instance.signOut();

  authNotifier.setUser(null);
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (BuildContext context) {
      return const LoginPage();
    }),
    (route) => false,
  );
}

forgotPassword(
    u.User user, AuthNotifier authNotifier, BuildContext context) async {
  EasyLoading.show();
  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: user.email!);
  } catch (error) {
    EasyLoading.dismiss();
    toast(error.toString());
    return;
  }

  EasyLoading.dismiss();
  toast("Reset Email has sent successfully");
  Navigator.pop(context);
}

addToCart(Food food, BuildContext context) async {
  try {
    User? currentUser = FirebaseAuth.instance.currentUser;
    CollectionReference cartRef =
        FirebaseFirestore.instance.collection('carts');
    QuerySnapshot data =
        await cartRef.doc(currentUser!.uid).collection('items').get();
    if (data.docs.length >= 10) {
      toast("Cart cannot have more than 10 times!");
      return;
    }
    await cartRef
        .doc(currentUser.uid)
        .collection('items')
        .doc(food.id)
        .set({"count": 1})
        .catchError((e) => debugPrint(e))
        .then((value) => debugPrint("Success"));
  } catch (error) {
    toast("Failed to add to cart!");
    return;
  }

  toast("Added to cart successfully!");
}

removeFromCart(Food food, BuildContext context) async {
  try {
    User? currentUser = FirebaseAuth.instance.currentUser;
    CollectionReference cartRef =
        FirebaseFirestore.instance.collection('carts');
    await cartRef
        .doc(currentUser!.uid)
        .collection('items')
        .doc(food.id)
        .delete()
        .catchError((e) => debugPrint(e))
        .then((value) => debugPrint("Success"));
  } catch (error) {
    toast("Failed to Remove from cart!");
    return;
  }

  toast("Removed from cart successfully!");
}

addNewItem(
    String? itemName, int? price, int? totalQty, BuildContext context) async {
  try {
    CollectionReference itemRef =
        FirebaseFirestore.instance.collection('items');
    await itemRef
        .doc()
        .set({"item_name": itemName, "price": price, "total_qty": totalQty})
        .catchError((e) => debugPrint(e))
        .then((value) => debugPrint("Success"));
  } catch (error) {
    toast("Failed to add to new item!");
    return;
  }

  Navigator.pop(context);
  toast("New Item added successfully!");
}

issueBook(
    String? bookName, int? bookId, int? enrollNo, BuildContext context) async {
  try {
    bool isBookAvailable = false;
    CollectionReference itemRef =
        FirebaseFirestore.instance.collection('books');
    await itemRef.where("book_id", isEqualTo: bookId).get().then((value) => {
          if (value.docs.isEmpty)
            {
              isBookAvailable = true,
            }
        });

    if (isBookAvailable) {
      await itemRef
          .doc()
          .set({
            "book_name": bookName,
            "book_id": bookId,
            "enroll_no": enrollNo,
            "date_issued": DateTime.now().toLocal().toString()
          })
          .catchError((e) => debugPrint(e))
          .then((value) => toast("Book issued successfully!"));
      sendNotificationToSpecificUserByEnrollNo(enrollNo, 'Library',
          'Book ID $bookId issued successfully', 'book-issued');
    } else {
      toast("Book is already issued!");
    }
  } catch (error) {
    toast("Failed to add to new item!");
    return;
  }

  Navigator.pop(context);
}

editItem(String itemName, int price, int totalQty, BuildContext context,
    String id) async {
  try {
    CollectionReference itemRef =
        FirebaseFirestore.instance.collection('items');
    await itemRef
        .doc(id)
        .set({"item_name": itemName, "price": price, "total_qty": totalQty})
        .catchError((e) => debugPrint(e))
        .then((value) => debugPrint("Success"));
  } catch (error) {
    toast("Failed to edit item!");
    return;
  }

  Navigator.pop(context);
  toast("Item edited successfully!");
}

deleteItem(String id, BuildContext context) async {
  try {
    CollectionReference itemRef =
        FirebaseFirestore.instance.collection('items');
    await itemRef
        .doc(id)
        .delete()
        .catchError((e) => debugPrint(e))
        .then((value) => debugPrint("Success"));
  } catch (error) {
    toast("Failed to delete item!");
    return;
  }

  Navigator.pop(context);
  toast("Item deleted successfully!");
}

returnBook(String id, BuildContext context) async {
  try {
    CollectionReference itemRef =
        FirebaseFirestore.instance.collection('books');
    await itemRef
        .where("book_id", isEqualTo: int.parse(id))
        .get()
        .then((value) {
      for (var element in value.docs) {
        itemRef
            .doc(element.id)
            .delete()
            .catchError((e) => debugPrint(e))
            .then((value) => debugPrint("Success"));
        sendNotificationToSpecificUserByEnrollNo(element['enroll_no'],
            'Library', 'Book ID $id returned successfully', 'book-returned');
      }
    });
  } catch (error) {
    toast("Failed to return book!");
    return;
  }

  Navigator.pop(context);
  toast("Book returned successfully!");
}

libraryInOut(int? enrollNo, BuildContext context) async {
  try {
    CollectionReference itemRef =
        FirebaseFirestore.instance.collection('libraryInOut');
    await itemRef
        .where("enroll_no", isEqualTo: enrollNo)
        .where("out_time", isEqualTo: "null")
        .get()
        .then((value) async => {
              if (value.docs.isEmpty)
                {
                  await itemRef
                      .doc()
                      .set({
                        "in_time": DateTime.now().toLocal().toString(),
                        "out_time": "null",
                        "enroll_no": enrollNo,
                      })
                      .catchError((e) => debugPrint(e))
                      .then((value) {
                        // Navigator.pop(context);
                        toast("Entry successfull!");
                      }),
                }
              else
                {
                  await itemRef
                      .doc(value.docs[0].id)
                      .update({
                        "out_time": DateTime.now().toLocal().toString(),
                      })
                      .catchError((e) => debugPrint(e))
                      .then((value) {
                        // Navigator.pop(context);
                        toast("Entry successfull!");
                      }),
                }
            });
  } catch (error) {
    toast("Failed to entry!");
    return;
  }
}

outingInOut(int? enrollNo, BuildContext context) async {
  try {
    String? timeInWeekdays;
    String? timeInWeekends;
    CollectionReference itemRef =
        FirebaseFirestore.instance.collection('outingInOut');
    await FirebaseFirestore.instance
        .collection('outing_setting')
        .where('timeInWeekdays', isNotEqualTo: null)
        .get()
        .then((value) async {
      for (var element in value.docs) {
        timeInWeekdays = element['timeInWeekdays'];
        timeInWeekends = element['timeInWeekends'];
      }
    });
    await itemRef
        .where("enroll_no", isEqualTo: enrollNo)
        .where("in_time", isEqualTo: "null")
        .get()
        .then((value) async => {
              if (value.docs.isEmpty)
                {
                  await itemRef
                      .doc()
                      .set({
                        "out_time": DateTime.now().toLocal().toString(),
                        "in_time": "null",
                        "enroll_no": enrollNo,
                        "late": false,
                        "message": "",
                      })
                      .catchError((e) => debugPrint(e))
                      .then((value) {
                        // Navigator.pop(context);
                        toast("Entry successfull!");
                      }),
                }
              else
                {
                  await itemRef
                      .doc(value.docs[0].id)
                      .update({
                        "in_time": DateTime.now().toLocal().toString(),
                        "late": (DateTime.now().weekday != 6 ||
                                DateTime.now().weekday != 7)
                            ? (DateTime.now().hour <
                                    (int.parse(timeInWeekdays!.split(":")[0])))
                                ? false
                                : (DateTime.now().minute <=
                                        (int.parse(
                                            timeInWeekdays!.split(":")[1])))
                                    ? false
                                    : true
                            : (DateTime.now().hour <
                                    (int.parse(timeInWeekends!.split(":")[0])))
                                ? false
                                : (DateTime.now().minute <=
                                        (int.parse(
                                            timeInWeekends!.split(":")[1])))
                                    ? false
                                    : true
                      })
                      .catchError((e) => debugPrint(e))
                      .then((value) {
                        // Navigator.pop(context);
                        toast("Entry successfull!");
                      }),
                }
            });
  } catch (error) {
    toast("Failed to Entry!");
    return;
  }
}

updateOutingInOut(String? message, String? id, BuildContext context) async {
  try {
    CollectionReference itemRef =
        FirebaseFirestore.instance.collection('outingInOut');
    await itemRef.doc(id).update({
      "message": message,
    }).then((value) async {
      toast("Message updated successfully!");
    });
  } catch (error) {
    toast("Failed to Entry!");
    return;
  }
}

deleteOutingInOut(String? id, BuildContext context) async {
  try {
    CollectionReference itemRef =
        FirebaseFirestore.instance.collection('outingInOut');
    await itemRef.doc(id).delete().then((value) async {
      toast("Entry deleted successfully!");
    });
  } catch (error) {
    toast("Failed to delete!");
    return;
  }
}

registerComplaint(
    u.User? user, String? type, String? message, BuildContext context) async {
  try {
    CollectionReference itemRef =
        FirebaseFirestore.instance.collection('complaints');
    await itemRef
        .doc()
        .set({
          "type": type,
          "message": message,
          "hostel_name": user!.hostelName,
          "room_no": user.roomNo,
          "name": user.displayName,
          "enroll_no": user.enrollNo,
          "phone": user.phone,
          "status": "Pending",
          "date": DateTime.now().toLocal().toString(),
          "solved_date": "null",
        })
        .catchError((e) => debugPrint(e))
        .then((value) {
          toast("Complaint registered successfully!");
        });
  } catch (error) {
    toast("Failed to register complaint!");
    return;
  }
}

updateComplaint(String? id, String? status, BuildContext context) async {
  try {
    CollectionReference itemRef =
        FirebaseFirestore.instance.collection('complaints');
    await itemRef.doc(id).update({
      "status": status,
      "solved_date": DateTime.now().toLocal().toString(),
    }).then((value) async {
      toast("Complaint updated successfully!");
    });
  } catch (error) {
    toast("Failed to update complaint!");
    return;
  }
}

deleteComplaint(String? id, BuildContext context) async {
  try {
    CollectionReference itemRef =
        FirebaseFirestore.instance.collection('complaints');
    await itemRef.doc(id).delete().then((value) async {
      toast("Complaint deleted successfully!");
    });
  } catch (error) {
    toast("Failed to delete complaint!");
    return;
  }
}

editCartItem(String itemId, int count, BuildContext context) async {
  try {
    User? currentUser = FirebaseAuth.instance.currentUser;
    CollectionReference cartRef =
        FirebaseFirestore.instance.collection('carts');
    if (count <= 0) {
      await cartRef
          .doc(currentUser!.uid)
          .collection('items')
          .doc(itemId)
          .delete()
          .catchError((e) => debugPrint(e))
          .then((value) => debugPrint("Success"));
    } else {
      await cartRef
          .doc(currentUser!.uid)
          .collection('items')
          .doc(itemId)
          .update({"count": count})
          .catchError((e) => debugPrint(e))
          .then((value) => debugPrint("Success"));
    }
  } catch (error) {
    toast("Failed to update Cart!");
    return;
  }

  toast("Cart updated successfully!");
}

messReview(String? review, String? mealTyle, int? enrollNo, String? comment,
    BuildContext context) async {
  try {
    CollectionReference itemRef =
        FirebaseFirestore.instance.collection('mess_review');

    await itemRef
        .doc()
        .set({
          "review": review,
          "meal_type": mealTyle,
          "enroll_no": enrollNo,
          "comment": comment,
          "date": DateTime.now().toLocal().toString()
        })
        .catchError((e) => debugPrint(e))
        .then((value) => toast("Review added successfully!"));
  } catch (error) {
    toast("Failed to add to new item!");
    return;
  }

  Navigator.pop(context);
}

addMoney(int amount, BuildContext context, String id) async {
  try {
    CollectionReference userRef =
        FirebaseFirestore.instance.collection('users');
    await userRef
        .doc(id)
        .update({'balance': FieldValue.increment(amount)})
        .catchError((e) => debugPrint(e))
        .then((value) => debugPrint("Success"));
  } catch (error) {
    toast("Failed to add money!");
    return;
  }

  Navigator.pop(context);
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (BuildContext context) {
      return NavigationBarPage(selectedIndex: 1);
    }),
  );
  toast("Money added successfully!");
}

placeOrder(BuildContext context, double total) async {
  try {
    // Initiaization
    User? currentUser = FirebaseAuth.instance.currentUser;
    CollectionReference cartRef =
        FirebaseFirestore.instance.collection('carts');
    CollectionReference orderRef =
        FirebaseFirestore.instance.collection('orders');
    CollectionReference itemRef =
        FirebaseFirestore.instance.collection('items');
    CollectionReference userRef =
        FirebaseFirestore.instance.collection('users');

    List<String> foodIds = <String>[];
    Map<String, int> count = <String, int>{};
    List<dynamic> cartItems = <dynamic>[];

    // Checking user balance
    DocumentSnapshot userData = await userRef.doc(currentUser!.uid).get();
    if (userData['balance'] < total) {
      toast("You dont have succifient balance to place this order!");
      return;
    }

    // Getting all cart items of the user
    QuerySnapshot data =
        await cartRef.doc(currentUser.uid).collection('items').get();
    for (var item in data.docs) {
      foodIds.add(item.id);
      count[item.id] = item['count'];
    }

    // Checking for item availability
    QuerySnapshot snap =
        await itemRef.where(FieldPath.documentId, whereIn: foodIds).get();
    for (var i = 0; i < snap.docs.length; i++) {
      if (snap.docs[i]['total_qty'] < count[snap.docs[i].id]) {
        toast(
            "Item: ${snap.docs[i]['item_name']} has QTY: ${snap.docs[i]['total_qty']} only. Reduce/Remove the item.");
        return;
      }
    }

    // Creating cart items array
    for (var item in snap.docs) {
      cartItems.add({
        "item_id": item.id,
        "count": count[item.id],
        "item_name": item['item_name'],
        "price": item['price']
      });
    }

    // Creating a transaction
    await FirebaseFirestore.instance
        .runTransaction((Transaction transaction) async {
      // Update the item count in items table
      for (var i = 0; i < snap.docs.length; i++) {
        transaction.update(snap.docs[i].reference,
            {"total_qty": snap.docs[i]["total_qty"] - count[snap.docs[i].id]});
      }

      // Deduct amount from user
      await userRef
          .doc(currentUser.uid)
          .update({'balance': FieldValue.increment(-1 * total)});

      // Place a new order
      await orderRef.doc().set({
        "items": cartItems,
        "is_delivered": false,
        "total": total,
        "placed_at": DateTime.now().toLocal().toString(),
        "delivery_at": "null",
        "placed_by": currentUser.uid,
        "user_name": userData["displayName"]
      });

      // Empty cart
      for (var i = 0; i < data.docs.length; i++) {
        transaction.delete(data.docs[i].reference);
      }
      // return;
    });

    // Successfull transaction
    sendNotificationToSpecificUser(currentUser.uid, 'Canteen',
        'Your order has been successfully placed!', 'order-placed');
    orderRef
        .where("delivery_at", isEqualTo: "null")
        .where('placed_by', isEqualTo: currentUser.uid)
        .get()
        .then((value) {
      for (var element in value.docs) {
        sendNotificationToRole('Order', 'New order received!', 'canteen',
            'new-order+${element.id}');
      }
    });

    Navigator.pop(context);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (BuildContext context) {
        return NavigationBarPage(selectedIndex: 1);
      }),
    );
    toast("Order Placed Successfully!");
  } catch (error) {
    Navigator.pop(context);
    toast("Failed to place order!");
    return;
  }
}

orderReceived(String id, BuildContext context) async {
  try {
    CollectionReference ordersRef =
        FirebaseFirestore.instance.collection('orders');
    await ordersRef
        .doc(id)
        .update({
          'is_delivered': true,
          'delivery_at': DateTime.now().toLocal().toString()
        })
        .catchError((e) => debugPrint(e))
        .then((value) => debugPrint("Success"));
  } catch (error) {
    toast("Failed to mark as delivered!");
    return;
  }

  Navigator.pop(context);
  toast("Order delivered successfully!");
}

profileUpdate(u.User user) async {
  bool userDataUploadVar = false;
  User? currentUser = FirebaseAuth.instance.currentUser;

  CollectionReference userRef = FirebaseFirestore.instance.collection('users');

  user.uuid = currentUser!.uid;
  if (userDataUploadVar != true) {
    await userRef
        .doc(currentUser.uid)
        .set(user.toMap())
        .catchError((e) => debugPrint(e))
        .then((value) => userDataUploadVar = true);
  } else {}
}

updateUserProfile(u.User user) async {
  bool userDataUploadVar = false;

  CollectionReference userRef = FirebaseFirestore.instance.collection('users');

  if (userDataUploadVar != true) {
    await userRef
        .doc(user.uuid)
        .update(user.toMap())
        .catchError((e) => debugPrint(e))
        .then((value) => userDataUploadVar = true);
    sendNotificationToSpecificUser(user.uuid, 'Profile Updated',
        'Your profile has been updated!', 'profile-update');
  } else {}
}

facultyDetailsUpdate(String? facultyId, String? facultyName,
    String? facultyEmail, String? facultyMobile, String? facultyBranch) async {
  bool userDataUploadVar = false;

  CollectionReference userRef =
      FirebaseFirestore.instance.collection('faculty_details');

  if (userDataUploadVar != true) {
    if (facultyId != null) {
      await userRef
          .doc(facultyId)
          .update({
            "facultyName": facultyName,
            "facultyEmail": facultyEmail,
            "facultyMobile": facultyMobile,
            "facultyBranch": facultyBranch
          })
          .catchError((e) => debugPrint(e))
          .then((value) => userDataUploadVar = true);
    } else {
      await userRef
          .doc(facultyId)
          .set({
            "facultyName": facultyName,
            "facultyEmail": facultyEmail,
            "facultyMobile": facultyMobile,
            "facultyBranch": facultyBranch
          })
          .catchError((e) => debugPrint(e))
          .then((value) => userDataUploadVar = true);
    }
  } else {}
}

publishNotice(String? title, String? message, BuildContext context) async {
  CollectionReference noticeRef =
      FirebaseFirestore.instance.collection('notices');
  await noticeRef.doc().set({
    "title": title,
    "message": message,
    "published_at": DateTime.now().toLocal().toString(),
  });
}

updateNotice(
    String? title, String? message, String? id, BuildContext context) async {
  CollectionReference noticeRef =
      FirebaseFirestore.instance.collection('notices');
  await noticeRef.doc(id).update({
    "title": title,
    "message": message,
    "published_at": DateTime.now().toLocal().toString(),
  });
}

deleteNotice(String? id) async {
  CollectionReference noticeRef =
      FirebaseFirestore.instance.collection('notices');
  await noticeRef.doc(id).delete();
}

sendNotification(String? title, String? message) async {
  CollectionReference userRef =
      FirebaseFirestore.instance.collection('devices');
  List<String> tokens = [];
  await userRef
      .where('role', whereNotIn: ['canteen', 'worker', 'guard'])
      .get()
      .then((value) {
        for (var element in value.docs) {
          tokens.add(element['device_token']);
        }
      });
  try {
    var response =
        await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
            headers: <String, String>{
              'Authorization':
                  'key=AAAAEOXp7dQ:APA91bG9068JCt-ylX58Q7Dagz5kJ0LUUdp1ndY5Sxhsi1ZwQ7ICLI8lNaZCk9vDGsyx_kthe2Q1MOFHlBijZWB0_4eXvarNlzxkAe-m8Gn43JKvSmwdbzDwgrMiA-xo-SV4G2k_HQcr',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              "registration_ids": tokens,
              "notification": {
                "body": message,
                "title": title,
                "android_channel_id": "campus_ease",
                "sound": true
              },
              "priority": "high",
              "data": {
                "_id": "Notice",
              }
            }));

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    throw Exception(e.toString());
  }
}

sendNotificationToRole(
    String? title, String? message, String? role, String? payload) async {
  CollectionReference userRef =
      FirebaseFirestore.instance.collection('devices');
  List<String> tokens = [];
  await userRef.where("role", isEqualTo: role).get().then((value) {
    for (var element in value.docs) {
      tokens.add(element['device_token']);
    }
  });
  try {
    var response =
        await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
            headers: <String, String>{
              'Authorization':
                  'key=AAAAEOXp7dQ:APA91bG9068JCt-ylX58Q7Dagz5kJ0LUUdp1ndY5Sxhsi1ZwQ7ICLI8lNaZCk9vDGsyx_kthe2Q1MOFHlBijZWB0_4eXvarNlzxkAe-m8Gn43JKvSmwdbzDwgrMiA-xo-SV4G2k_HQcr',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              "registration_ids": tokens,
              "notification": {
                "body": message,
                "title": title,
                "android_channel_id": "campus_ease",
                "sound": true
              },
              "priority": "high",
              "data": {
                "_id": payload,
              }
            }));

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    throw Exception(e.toString());
  }
}

sendNotificationToSpecificUser(
    String? id, String? title, String? message, String? payload) async {
  CollectionReference userRef = FirebaseFirestore.instance.collection('users');
  List<String> tokens = [];
  await userRef.doc(id).get().then((value) {
    tokens.add(value['device_token']);
  });
  try {
    var response =
        await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
            headers: <String, String>{
              'Authorization':
                  'key=AAAAEOXp7dQ:APA91bG9068JCt-ylX58Q7Dagz5kJ0LUUdp1ndY5Sxhsi1ZwQ7ICLI8lNaZCk9vDGsyx_kthe2Q1MOFHlBijZWB0_4eXvarNlzxkAe-m8Gn43JKvSmwdbzDwgrMiA-xo-SV4G2k_HQcr',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              "registration_ids": tokens,
              "notification": {
                "body": message,
                "title": title,
                "android_channel_id": "campus_ease",
                "sound": true
              },
              "priority": "high",
              "data": {
                "_id": payload,
              }
            }));

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    throw Exception(e.toString());
  }
}

sendNotificationToSpecificUserByEnrollNo(
    int? enrollNo, String? title, String? message, String? payload) async {
  CollectionReference userRef = FirebaseFirestore.instance.collection('users');
  List<String> tokens = [];
  await userRef.where('enroll_no', isEqualTo: enrollNo).get().then((value) {
    for (var element in value.docs) {
      tokens.add(element['device_token']);
    }
  });
  try {
    var response =
        await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
            headers: <String, String>{
              'Authorization':
                  'key=AAAAEOXp7dQ:APA91bG9068JCt-ylX58Q7Dagz5kJ0LUUdp1ndY5Sxhsi1ZwQ7ICLI8lNaZCk9vDGsyx_kthe2Q1MOFHlBijZWB0_4eXvarNlzxkAe-m8Gn43JKvSmwdbzDwgrMiA-xo-SV4G2k_HQcr',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              "registration_ids": tokens,
              "notification": {
                "body": message,
                "title": title,
                "android_channel_id": "campus_ease",
                "sound": true
              },
              "priority": "high",
              "data": {
                "_id": payload,
              }
            }));

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    throw Exception(e.toString());
  }
}
