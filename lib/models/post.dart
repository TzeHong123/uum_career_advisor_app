class Post {
  String? postId;
  String? userId;
  String? userName;
  String? postTitle;
  String? postContent;

  Post({
    this.postId,
    this.userId,
    this.userName,
    this.postTitle,
    this.postContent,
  });

  // Assuming you get a JSON map from your database
  Post.fromJson(Map<String, dynamic> json) {
    postId = json['post_id'];
    userId = json['user_id'];
    userName = json['user_name'];
    postTitle = json['post_title'];
    postContent = json['post_content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['post_id'] = postId;
    data['user_id'] = userId;
    data['user_name'] = userName;
    data['post_title'] = postTitle;
    data['post_content'] = postContent;
    return data;
  }
}
