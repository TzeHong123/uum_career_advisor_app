class Comment {
  String? id;
  String? userId;
  String? username;
  String? userProfilePic;
  String? text;
  int upvotes;
  int downvotes;

  Comment({
    this.id,
    this.userId,
    this.username,
    this.userProfilePic,
    this.text,
    this.upvotes = 0,
    this.downvotes = 0,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id']?.toString(),
      userId: json['user_id']?.toString(),
      username: json['username'],
      userProfilePic: json['user_profile_pic'],
      text: json['text'],
      upvotes: int.tryParse(json['upvotes']?.toString() ?? '0') ?? 0,
      downvotes: int.tryParse(json['downvotes']?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['username'] = username;
    data['user_profile_pic'] = userProfilePic;
    data['text'] = text;
    data['upvotes'] = upvotes;
    data['downvotes'] = downvotes;
    return data;
  }

  void upvote() {
    upvotes += 1;
  }

  void downvote() {
    downvotes -= 1;
  }
}
