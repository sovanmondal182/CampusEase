class Notice {
  String title;
  String description;
  DateTime issueDate;
  String id;
  Notice(
      {required this.title,
      required this.description,
      required this.issueDate,
      required this.id});

  Notice.fromMap(Map<String, dynamic> data)
      : title = data['title'],
        description = data['message'],
        issueDate = DateTime.parse(data['published_at']),
        id = data['id'];

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'message': description,
      'date_issued': issueDate,
      'published_at': issueDate,
      'id': id,
    };
  }
}
