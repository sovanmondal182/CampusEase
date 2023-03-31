import 'package:campus_ease/screens/canteen/canteen_profilePage.dart';
import 'package:campus_ease/screens/canteen/orderDetails.dart';
import 'package:campus_ease/screens/dashboard/student_dashboard_screen.dart';
import 'package:campus_ease/screens/library/view_issued_book.dart';
import 'package:campus_ease/screens/notice/view_notice.dart';
import 'package:campus_ease/screens/service/service_view_complaint.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import '../screens/canteen/admin_order_history.dart';
import '../screens/profile/user_profile.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static void initialize() {
    // initializationSettings  for Android
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
    );
    _notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (response) async {
      if (response.payload != "" || response.payload != null) {
        if (response.payload == "worker") {
          Get.to(() => const ServiceViewComplaints());
        } else if (response.payload == "profile-update") {
          Get.to(() => const UserProfileScreen());
        } else if (response.payload == "Notice") {
          Get.to(() => const ViewNoticeScreen());
        } else if (response.payload == "book-issued") {
          Get.to(() => const ViewIssuedBook());
        } else if (response.payload == "order-placed") {
          Get.to(() => const ProfilePage());
        } else if (response.payload == "book-returned") {
          Get.to(() => const ViewIssuedBook());
        } else if (response.payload!.split("+")[0] == "new-order") {
          FirebaseFirestore.instance
              .collection('orders')
              .doc(response.payload!.split("+")[1])
              .get()
              .then((value) {
            Get.to(() => OrderDetailsPage(value));
          });
          Get.to(() => const AdminOrderDetailsPage());
        } else if (response.payload == "outing") {
          Get.to(() => const StudentDashBoardScreen());
        } else if (response.payload!.split("+")[0] == "order-delivered") {
          FirebaseFirestore.instance
              .collection('orders')
              .doc(response.payload!.split("+")[1])
              .get()
              .then((value) {
            Get.to(() => OrderDetailsPage(value));
          });
        }
      }
    }, onDidReceiveBackgroundNotificationResponse: (response) async {
      if (response.payload != "" || response.payload != null) {
        if (response.payload == "worker") {
          Get.to(() => const ServiceViewComplaints());
        } else if (response.payload == "profile-update") {
          Get.to(() => const UserProfileScreen());
        } else if (response.payload == "Notice") {
          Get.to(() => const ViewNoticeScreen());
        } else if (response.payload == "book-issued") {
          Get.to(() => const ViewIssuedBook());
        } else if (response.payload == "order-placed") {
          Get.to(() => const ProfilePage());
        } else if (response.payload == "book-returned") {
          Get.to(() => const ViewIssuedBook());
        } else if (response.payload!.split("+")[0] == "new-order") {
          FirebaseFirestore.instance
              .collection('orders')
              .doc(response.payload!.split("+")[1])
              .get()
              .then((value) {
            Get.to(() => OrderDetailsPage(value));
          });
          Get.to(() => const AdminOrderDetailsPage());
        } else if (response.payload == "outing") {
          Get.to(() => const StudentDashBoardScreen());
        } else if (response.payload!.split("+")[0] == "order-delivered") {
          FirebaseFirestore.instance
              .collection('orders')
              .doc(response.payload!.split("+")[1])
              .get()
              .then((value) {
            Get.to(() => OrderDetailsPage(value));
          });
        }
      }
    });
  }

  static void createanddisplaynotification(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      const NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          "campus_ease",
          "campus_ease",
          importance: Importance.max,
          priority: Priority.high,
        ),
      );

      await _notificationsPlugin.show(
        id,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
        payload: message.data['_id'],
      );
    } on Exception {
      debugPrint("Error in displaying notification");
    }
  }
}
