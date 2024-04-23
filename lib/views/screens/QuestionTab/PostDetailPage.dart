import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uum_career_advisor_app/models/question.dart';
import 'package:uum_career_advisor_app/models/comment.dart';
import 'package:uum_career_advisor_app/models/user.dart';

import '../../../myconfig.dart';

class PostDetailPage extends StatefulWidget {
  final User user;
  final Question question;

  const PostDetailPage({Key? key, required this.user, required this.question})
      : super(key: key);

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  late TextEditingController commentController;
  List<Comment> comments = [];

  @override
  void initState() {
    super.initState();
    commentController = TextEditingController();
  }

  Future<void> addComment(String? userId, String? questionId,
      String userProfilePic, String commentText) async {
    var url = Uri.parse(
        "${MyConfig().SERVER}/uum_career_advisor_app/php/add_comment.php");

    try {
      var response = await http.post(url, body: {
        'user_id': userId ?? '',
        'question_id': questionId ?? '',
        'user_profile_pic': userProfilePic,
        'comment_text': commentText,
        'upvotes': '0', // default value
        'downvotes': '0' // default value
      });

      if (response.statusCode == 200) {
        print('Comment added successfully');
      } else {
        print('Failed to add comment');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  Future<List<Comment>> fetchComments(String? questionId) async {
    var url = Uri.parse(
        "${MyConfig().SERVER}/uum_career_advisor_app/php/fetch_comments.php?question_id=${questionId ?? ''}");
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] == 'success') {
        List<Comment> comments = List<Comment>.from(
            jsonResponse['data'].map((model) => Comment.fromJson(model)));
        return comments;
      } else {
        throw Exception('Failed to load comments: ${jsonResponse['message']}');
      }
    } else {
      throw Exception('Failed to load comments');
    }
  }

  void handleSubmit() {
    if (commentController.text.isNotEmpty) {
      addComment(widget.user.id, widget.question.questionId,
              "assets/images/profile.png", commentController.text)
          .then((_) {
        print("Comment submitted!");
        commentController.clear();
        setState(() {});
      }).catchError((error) {
        print("Failed to submit comment: $error");
      });
    } else {
      print("Comment text is empty");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Question Details"),
        backgroundColor: Colors.blueGrey,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.question.questionTitle ?? "No Title",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                widget.question.questionContent ?? "No Content",
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 24),
              Text('Comments',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              FutureBuilder<List<Comment>>(
                future: fetchComments(widget.question.questionId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } else if (snapshot.hasData) {
                    return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        Comment comment = snapshot.data![index];
                        return CommentWidget(
                          userName: comment.username ?? "Unknown",
                          userImageUrl: comment.userProfilePic ??
                              "assets/images/profile.png",
                          comment: comment.text ?? "",
                          upvotes: comment.upvotes,
                          downvotes: comment.downvotes,
                        );
                      },
                    );
                  } else {
                    return Text("No comments found.");
                  }
                },
              ),
              TextField(
                controller: commentController,
                decoration: InputDecoration(
                  labelText: 'Add a comment...',
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (value) => handleSubmit(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }
}

class CommentWidget extends StatelessWidget {
  final String userName;
  final String userImageUrl;
  final String comment;
  final int upvotes;
  final int downvotes;

  const CommentWidget({
    Key? key,
    required this.userName,
    required this.userImageUrl,
    required this.comment,
    required this.upvotes,
    required this.downvotes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage(userImageUrl),
        ),
        title: Text(userName, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              comment,
              textAlign: TextAlign.justify,
            ),
            Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.thumb_up, color: Colors.green),
                  onPressed: () {}, // Placeholder for upvote functionality
                ),
                Text('$upvotes'),
                IconButton(
                  icon: Icon(Icons.thumb_down, color: Colors.red),
                  onPressed: () {}, // Placeholder for downvote functionality
                ),
                Text('$downvotes'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
