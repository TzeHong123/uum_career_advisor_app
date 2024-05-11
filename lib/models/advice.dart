class Advice {
  final String? adviceId;
  final String? postId;
  final String? userName;
  final String? adviceTitle;
  final String adviceContent;
  final DateTime? createdAt;

  Advice({
    this.adviceId,
    this.postId,
    this.userName,
    this.adviceTitle,
    required this.adviceContent,
    this.createdAt,
  });

  factory Advice.fromJson(Map<String, dynamic> json) {
    return Advice(
      adviceId: json['advice_id']?.toString(),
      postId: json['post_id']?.toString(),
      userName: json['user_name'],
      adviceTitle: json['advice_title'],
      adviceContent: json['advice_content'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['advice_id'] = adviceId;
    data['post_id'] = postId;
    data['user_name'] = userName;
    data['advice_title'] = adviceTitle;
    data['advice_content'] = adviceContent;
    // Adjust date format as necessary, e.g., ISO8601
    if (createdAt != null) {
      data['created_at'] = createdAt!.toIso8601String();
    }
    return data;
  }
}
