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

  User({
    this.displayName,
    this.email,
    this.password,
    this.uuid,
    this.role,
    this.balance,
    this.phone,
    this.enrollNo,
  });

  User.fromMap(Map<String, dynamic> data)
      : displayName = data['displayName'],
        email = data['email'],
        password = data['password'],
        uuid = data['uuid'],
        role = data['role'],
        balance = data['balance'],
        phone = data['phone'],
        enrollNo = data['enroll_no'];

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
    };
  }
}
