class Post {
  String? postId;
  String? userId;
  String? userName;
  String? postTitle;
  String? postContent;
  int likes;
  int userHasLiked; // No longer marked as late
  bool isFavorite;

  Post({
    this.postId,
    this.userId,
    this.userName,
    this.postTitle,
    this.postContent,
    this.likes = 0, // Provide default value directly
    this.userHasLiked = 0, // Provide default value directly
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
      likes: int.tryParse(json['post_likes'].toString()) ??
          0, // Ensure it's an int
      userHasLiked:
          int.tryParse(json['user_has_liked']?.toString() ?? '0') ?? 0,
      isFavorite: json['isFavorite'] == 1 ||
          json['isFavorite'] == true, // Handle both integer and boolean values
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
    return data;
  }
}
