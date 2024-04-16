class Question {
  String? questionId;
  String? userId;
  String? userName;
  String? questionTitle;
  String? questionContent;

  Question({
    this.questionId,
    this.userId,
    this.userName,
    this.questionTitle,
    this.questionContent,
  });

  // Assuming you get a JSON map from your database
  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      questionId: json['question_id'].toString(),
      userId: json['user_id'].toString(),
      userName: json['user_name'],
      questionTitle: json['question_title'],
      questionContent: json['question_content'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['question_id'] = questionId;
    data['user_id'] = userId;
    data['user_name'] = userName;
    data['question_title'] = questionTitle;
    data['question_content'] = questionContent;
    return data;
  }
}
