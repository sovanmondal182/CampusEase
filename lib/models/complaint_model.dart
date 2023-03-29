class ComplaintModel {
  String hostelName;
  String roomNo;
  String name;
  String phone;
  int enrollNo;
  String message;
  String status;
  String type;
  String id;
  String date;
  String solvedDate;
  ComplaintModel(
      {required this.hostelName,
      required this.roomNo,
      required this.name,
      required this.phone,
      required this.enrollNo,
      required this.message,
      required this.status,
      required this.type,
      required this.id,
      required this.date,
      required this.solvedDate});

  ComplaintModel.fromMap(Map<String, dynamic> data)
      : hostelName = data['hostel_name'],
        roomNo = data['room_no'],
        name = data['name'],
        phone = data['phone'],
        enrollNo = data['enroll_no'],
        message = data['message'],
        status = data['status'],
        type = data['type'],
        id = data['id'],
        date = data['date'],
        solvedDate = data['solved_date'];

  Map<String, dynamic> toMap() {
    return {
      'hostel_name': hostelName,
      'room_no': roomNo,
      'name': name,
      'phone': phone,
      'enroll_no': enrollNo,
      'message': message,
      'status': status,
      'type': type,
      'id': id,
      'date': date,
      'solved_date': solvedDate,
    };
  }
}
