class Comment {
  String? commentId;
  String? userId;
  String? questionId;
  String? userProfilePic;
  String? commentText;
  int upvotes;
  int downvotes;
  String? username;

  Comment({
    this.commentId,
    this.userId,
    this.questionId,
    this.userProfilePic,
    this.commentText,
    this.upvotes = 0,
    this.downvotes = 0,
    this.username,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      commentId: json['comment_id']?.toString(),
      userId: json['user_id']?.toString(),
      questionId: json['question_id']?.toString(),
      userProfilePic: json['user_profile_pic'],
      commentText: json['comment_text'],
      upvotes: int.tryParse(json['upvotes']?.toString() ?? '0') ?? 0,
      downvotes: int.tryParse(json['downvotes']?.toString() ?? '0') ?? 0,
      username: json['username'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['comment_id'] = commentId;
    data['user_id'] = userId;
    data['question_id'] = questionId;
    data['user_profile_pic'] = userProfilePic;
    data['comment_text'] = commentText;
    data['upvotes'] = upvotes;
    data['downvotes'] = downvotes;
    data['username'] = username;
    return data;
  }
}
