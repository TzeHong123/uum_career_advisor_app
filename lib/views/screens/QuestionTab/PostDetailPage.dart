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
    // Initialize your comments list here, for demonstration I'll add a couple of example comments.
    comments = [
      Comment(
          id: 1,
          userId: '1',
          username: 'Jane Doe',
          userProfilePic: 'assets/images/profile.png',
          text: 'Great question!',
          upvotes: 10,
          downvotes: 2),
      Comment(
          id: 2,
          userId: '2',
          username: 'John',
          userProfilePic: 'assets/images/profile.png',
          text:
              'I think you should go find some good tutorial video or consult an expert online. Do not be afraid to ask, there are always people willing to help you!',
          upvotes: 30,
          downvotes: 0)
    ];
  }

  Future<void> addComment(String? userId, String? questionId,
      String userProfilePic, String commentText) async {
    var url = Uri.parse(
        "${MyConfig().SERVER}/uum_career_advisor_app/php/add_comment.php");

    try {
      var response = await http.post(url, body: {
        'user_id': userId.toString(),
        'question_id': questionId.toString(),
        'user_profile_pic': userProfilePic,
        'comment_text': commentText,
        'upvotes': '0', // default value
        'downvotes': '0' // default value
      });

      if (response.statusCode == 200) {
        print('Comment added successfully');
        // Optionally, update your local list of comments if needed
      } else {
        print('Failed to add comment');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

//   Future<List<Comment>> fetchComments(int questionId) async {
//   var url = Uri.parse("${MyConfig().SERVER}/uum_career_advisor_app/php/fetch_comments.php?question_id=$questionId");
//   var response = await http.get(url);

//   if (response.statusCode == 200) {
//     var jsonResponse = json.decode(response.body);
//     if (jsonResponse['status'] == 'success') {
//       List<Comment> comments = List<Comment>.from(
//         jsonResponse['data'].map((model) => Comment.fromJson(model))
//       );
//       return comments;
//     } else {
//       throw Exception('Failed to load comments: ${jsonResponse['message']}');
//     }
//   } else {
//     throw Exception('Failed to load comments');
//   }
// }

  void handleSubmit() {
    String? userId =
        widget.user.id; // Example user ID, get this from your user data
    String? questionId = widget
        .question.questionId; // Get the question ID from your Question object
    String userProfilePic =
        "assets/images/profile.png"; // Example profile picture path

    if (commentController.text.isNotEmpty) {
      addComment(userId, questionId, userProfilePic, commentController.text)
          .then((_) {
        print("Comment submitted!");
        commentController.clear(); // Clear the text field after submitting
        setState(
            () {}); // Update the UI if necessary, such as updating a comment list
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
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  return CommentWidget(
                    userName: comments[index].username,
                    userImageUrl: comments[index].userProfilePic,
                    comment: comments[index].text,
                    upvotes: comments[index].upvotes,
                    downvotes: comments[index].downvotes,
                  );
                },
              ),
              TextField(
                controller: commentController,
                decoration: InputDecoration(
                  labelText: 'Add a comment...',
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (value) =>
                    handleSubmit(), // Ensure this uses handleSubmit
              ),
            ],
          ),
        ),
      ),
    );
  }
//   FutureBuilder<List<Comment>>(
//   future: fetchComments(question.id),
//   builder: (context, snapshot) {
//     if (snapshot.connectionState == ConnectionState.done) {
//       if (snapshot.hasData) {
//         return ListView.builder(
//           itemCount: snapshot.data!.length,
//           itemBuilder: (context, index) {
//             return CommentWidget(comment: snapshot.data![index]);
//           },
//         );
//       } else if (snapshot.hasError) {
//         return Text("${snapshot.error}");
//       }
//     }
//     return CircularProgressIndicator(); // Show loading spinner while waiting for data
//   },
// )

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
          // onBackgroundImageError: (exception, stackTrace) {
          //   return Text(userName[0]); // Fallback to initial letter
          // },
        ),
        title: Text(userName, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              comment,
              textAlign: TextAlign.justify, // Justifying the comment text
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
