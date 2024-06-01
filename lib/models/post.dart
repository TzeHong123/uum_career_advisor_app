class Post {
  String? postId;
  String? userId;
  String? userName;
  String? postTitle;
  String? postContent;
  int likes;
  int userHasLiked;
  bool isFavorite;

  Post({
    this.postId,
    this.userId,
    this.userName,
    this.postTitle,
    this.postContent,
    this.likes = 0,
    required this.userHasLiked,
    required this.isFavorite,
  });

  // Assuming you get a JSON map from your database
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      postId: json['post_id'].toString(),
      userId: json['user_id'].toString(),
      userName: json['user_name'],
      postTitle: json['post_title'],
      postContent: json['post_content'],
      likes: int.parse(json['post_likes'].toString()),
      userHasLiked:
          int.parse(json['userHasLiked'].toString()), // Correct the field name
      isFavorite: json['isFavorite'] == 1 || json['isFavorite'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['post_id'] = postId;
    data['user_id'] = userId;
    data['user_name'] = userName;
    data['post_title'] = postTitle;
    data['post_content'] = postContent;
    data['likes'] = likes;
    data['user_has_liked'] = userHasLiked;
    data['isFavorite'] =
        isFavorite ? 1 : 0; // Add this line if isFavorite is to be serialized
    return data;
  }
}
