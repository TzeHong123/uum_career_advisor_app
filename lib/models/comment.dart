class Comment {
  final int id;
  final String userId;
  final String username;
  final String userProfilePic;
  final String text;
  int upvotes;
  int downvotes;

  Comment({
    required this.id,
    required this.userId,
    required this.username,
    required this.userProfilePic,
    required this.text,
    this.upvotes = 0,
    this.downvotes = 0,
  });

  void upvote() {
    upvotes += 1;
  }

  void downvote() {
    downvotes += 1;
  }
}
