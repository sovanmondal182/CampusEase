class OutingInOutModel {
  String inTime;
  String outTime;
  int enrollNo;
  bool late;
  String message;
  String id;
  OutingInOutModel(
      {required this.inTime,
      required this.outTime,
      required this.enrollNo,
      required this.late,
      required this.message,
      required this.id});

  OutingInOutModel.fromMap(Map<String, dynamic> data)
      : inTime = data['in_time'],
        outTime = data['out_time'],
        enrollNo = data['enroll_no'],
        late = data['late'],
        message = data['message'],
        id = data['id'];

  Map<String, dynamic> toMap() {
    return {
      'in_time': inTime,
      'out_time': outTime,
      'enroll_no': enrollNo,
      'late': late,
      'message': message,
      'id': id,
    };
  }
}
