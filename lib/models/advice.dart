class Advice {
  final String? adviceId;
  final String? postId;
  final String? userName;
  final String? jobTitle;
  final String? companyName;
  final DateTime? createdAt;
  final String? adviceTitle;
  final String adviceContent;

  Advice({
    this.adviceId,
    this.postId,
    this.userName,
    this.jobTitle,
    this.companyName,
    this.adviceTitle,
    required this.adviceContent,
    this.createdAt,
  });

  factory Advice.fromJson(Map<String, dynamic> json) {
    return Advice(
      adviceId: json['advice_id']?.toString(),
      postId: json['post_id']?.toString(),
      userName: json['user_name'],
      jobTitle: json['job_title'], // Corrected key access
      companyName: json['company_name'], // Corrected key access
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
    data['job_title'] = jobTitle;
    data['company_name'] = companyName;
    data['advice_title'] = adviceTitle;
    data['advice_content'] = adviceContent;
    // Adjust date format as necessary, e.g., ISO8601
    if (createdAt != null) {
      data['created_at'] = createdAt!.toIso8601String();
    }
    return data;
  }
}
