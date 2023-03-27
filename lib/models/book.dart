class Book {
  String bookName;
  int bookId;
  DateTime issueDate;
  int enrollNo;
  Book(
      {required this.bookName,
      required this.bookId,
      required this.issueDate,
      required this.enrollNo});

  Book.fromMap(Map<String, dynamic> data)
      : bookName = data['bookName'],
        bookId = data['bookId'],
        issueDate = DateTime.parse(data['date_issued']),
        enrollNo = data['enroll_no'];

  Map<String, dynamic> toMap() {
    return {
      'bookName': bookName,
      'bookId': bookId,
      'date_issued': issueDate,
      'enroll_no': enrollNo,
    };
  }
}
