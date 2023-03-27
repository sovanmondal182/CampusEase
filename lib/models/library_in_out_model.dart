class LibraryInOut {
  String inTime;
  String outTime;
  int enrollNo;
  LibraryInOut(
      {required this.inTime, required this.outTime, required this.enrollNo});

  LibraryInOut.fromMap(Map<String, dynamic> data)
      : inTime = data['in_time'],
        outTime = data['out_time'],
        enrollNo = data['enroll_no'];

  Map<String, dynamic> toMap() {
    return {
      'in_time': inTime,
      'out_time': outTime,
      'enroll_no': enrollNo,
    };
  }
}
