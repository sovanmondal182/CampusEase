class MessReviewModel {
  String review;
  String mealTyle;
  int enrollNo;
  String comment;
  String date;
  MessReviewModel(
      {required this.review,
      required this.mealTyle,
      required this.enrollNo,
      required this.comment,
      required this.date});

  MessReviewModel.fromMap(Map<String, dynamic> data)
      : review = data['review'],
        mealTyle = data['meal_type'],
        enrollNo = data['enroll_no'],
        comment = data['comment'],
        date = data['date'];

  Map<String, dynamic> toMap() {
    return {
      'review': review,
      'meal_type': mealTyle,
      'enroll_no': enrollNo,
      'comment': comment,
      'date': date,
    };
  }
}
