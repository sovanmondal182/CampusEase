class OutingInOutModel {
  String inTime;
  String outTime;
  int enrollNo;
  bool late;
  OutingInOutModel(
      {required this.inTime,
      required this.outTime,
      required this.enrollNo,
      required this.late});

  OutingInOutModel.fromMap(Map<String, dynamic> data)
      : inTime = data['in_time'],
        outTime = data['out_time'],
        enrollNo = data['enroll_no'],
        late = data['late'];

  Map<String, dynamic> toMap() {
    return {
      'in_time': inTime,
      'out_time': outTime,
      'enroll_no': enrollNo,
      'late': late,
    };
  }
}
