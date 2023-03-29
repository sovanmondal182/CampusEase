import 'dart:ffi';

class User {
  String? displayName;
  String? email;
  String? password;
  String? uuid;
  String? role;
  double? balance;
  String? phone;
  int? enrollNo;
  String? photoUrl;
  String? admissionYear;
  String? branch;
  String? course;
  String? roomNo;
  String? hostelName;

  User({
    this.displayName,
    this.email,
    this.password,
    this.uuid,
    this.role,
    this.balance,
    this.phone,
    this.enrollNo,
    this.photoUrl,
    this.admissionYear,
    this.branch,
    this.course,
    this.roomNo,
    this.hostelName,
  });

  User.fromMap(Map<String, dynamic> data)
      : displayName = data['displayName'],
        email = data['email'],
        password = data['password'],
        uuid = data['uuid'],
        role = data['role'],
        balance = data['balance'],
        phone = data['phone'],
        enrollNo = data['enroll_no'],
        photoUrl = data['photo_url'],
        admissionYear = data['admission_year'],
        branch = data['branch'],
        course = data['course'],
        roomNo = data['room_no'],
        hostelName = data['hostel_name'];

  Map<String, dynamic> toMap() {
    return {
      'displayName': displayName,
      'email': email,
      'password': password,
      'uuid': uuid,
      'role': role,
      'balance': balance,
      'phone': phone,
      'enroll_no': enrollNo,
      'photo_url': photoUrl,
      'admission_year': admissionYear,
      'branch': branch,
      'course': course,
      'room_no': roomNo,
      'hostel_name': hostelName,
    };
  }
}
