import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uum_career_advisor_app/models/comment.dart';
import 'package:uum_career_advisor_app/models/question.dart';
import 'package:uum_career_advisor_app/models/user.dart';
import 'package:uum_career_advisor_app/myconfig.dart';

class QuestionDetailPage extends StatefulWidget {
  final User user;
  final Question question;

  const QuestionDetailPage(
      {Key? key, required this.user, required this.question})
      : super(key: key);

  @override
  State<QuestionDetailPage> createState() => _QuestionDetailPageState();
}

class _QuestionDetailPageState extends State<QuestionDetailPage> {
  late TextEditingController commentController;
  List<Comment> comments = [];

// Callback function to update the comments list
  void updateCommentsList(Comment updatedComment) {
    setState(() {
      int index = comments.indexWhere(
          (comment) => comment.commentId == updatedComment.commentId);
      if (index != -1) {
        comments[index] = updatedComment;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    commentController = TextEditingController();
    fetchComments(widget.question.questionId!).then((fetchedComments) {
      setState(() {
        comments = fetchedComments;
      });
    }).catchError((error) {
      print('Error fetching comments: $error');
    });
  }

  Future<List<Comment>> fetchComments(String questionId) async {
    var url = Uri.parse(
        "${MyConfig().SERVER}/uum_career_advisor_app/php/fetch_comment.php?question_id=$questionId");
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] == 'success') {
        List<Comment> comments = List<Comment>.from(
            jsonResponse['data'].map((model) => Comment.fromJson(model)));
        return comments;
      } else {
        throw Exception(jsonResponse['message']);
      }
    } else {
      throw Exception('Failed to load comments');
    }
  }

  void handleSubmit() {
    String userId = widget.user.id ?? ''; // Example user ID
    String questionId = widget.question.questionId ?? ''; // Question ID

    String userProfilePic =
        widget.user.profilePicture ?? ''; // Example profile picture path

    if (commentController.text.isNotEmpty) {
      addComment(userId, questionId, userProfilePic, commentController.text)
          .then((_) {
        print("Comment submitted!");
        commentController.clear();
        fetchComments(widget.question.questionId!).then((fetchedComments) {
          setState(() {
            comments = fetchedComments;
          });
        });
      }).catchError((error) {
        print("Failed to submit comment: $error");
      });
    } else {
      print("Comment text is empty");
    }
  }

  Future<void> addComment(String userId, String questionId,
      String userProfilePic, String commentText) async {
    var url = Uri.parse(
        "${MyConfig().SERVER}/uum_career_advisor_app/php/add_comment.php");

    try {
      var response = await http.post(url, body: {
        'user_id': userId,
        'question_id': questionId,
        'user_profile_pic': userProfilePic,
        'comment_text': commentText,
        'upvotes': '0', // Default value
        'downvotes': '0' // Default value
      });

      if (response.statusCode == 200) {
        print('Comment added successfully');
        Fluttertoast.showToast(
            msg: "Comment added!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      } else {
        print('Failed to add comment');
        Fluttertoast.showToast(
            msg: "Failed to add comment",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      }
    } catch (e) {
      print('Error occurred: $e');
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
                    comment: comments[index],
                    user: widget.user,
                    onUpdate: updateCommentsList, // Pass the callback function
                  );
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
}

class CommentWidget extends StatelessWidget {
  final Comment comment;
  final User user;
  final Function(Comment) onUpdate; // Callback function

  const CommentWidget({
    Key? key,
    required this.comment,
    required this.user,
    required this.onUpdate,
  }) : super(key: key);

  Future<void> upvoteComment(BuildContext context, String commentId) async {
    var url = Uri.parse(
        "${MyConfig().SERVER}/uum_career_advisor_app/php/upvote_comment.php");

    try {
      var response = await http.post(url, body: {
        'comment_id': commentId,
        'user_id': user.id!,
      });

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success') {
          print('Comment upvoted successfully');
          Fluttertoast.showToast(
              msg: "Upvoted the comment!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 16.0);
          // Fetch the updated comment and refresh the UI
          fetchSingleComment(commentId).then((updatedComment) {
            onUpdate(updatedComment);
          });
        } else {
          print('Failed to upvote comment: ${jsonResponse['message']}');
          Fluttertoast.showToast(
              msg: jsonResponse['message'],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 16.0);
        }
      } else {
        print('Failed to upvote comment');
        Fluttertoast.showToast(
            msg: "Failed to upvote comment",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      }
    } catch (e) {
      print('Error occurred while upvoting comment: $e');
    }
  }

  Future<Comment> fetchSingleComment(String commentId) async {
    var url = Uri.parse(
        "${MyConfig().SERVER}/uum_career_advisor_app/php/fetch_single_comment.php?comment_id=$commentId");
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] == 'success') {
        return Comment.fromJson(jsonResponse['data']);
      } else {
        throw Exception(jsonResponse['message']);
      }
    } else {
      throw Exception('Failed to load comment');
    }
  }

  Future<void> downvoteComment(BuildContext context, String commentId) async {
    var url = Uri.parse(
        "${MyConfig().SERVER}/uum_career_advisor_app/php/downvote_comment.php");

    try {
      var response = await http.post(url, body: {
        'comment_id': commentId,
        'user_id': user.id!,
      });

      if (response.statusCode == 200) {
        print('Comment downvoted successfully');
        Fluttertoast.showToast(
            msg: "Downvoted the comment!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);

        // Fetch the updated comment and refresh the UI
        fetchSingleComment(commentId).then((updatedComment) {
          onUpdate(updatedComment);
        });
      } else {
        print('Failed to downvote comment');
      }
    } catch (e) {
      print('Error occurred while downvoting comment: $e');
    }
  }

  Future<Comment> fetchUpdatedComment(String commentId) async {
    var url = Uri.parse(
        "${MyConfig().SERVER}/uum_career_advisor_app/php/fetch_single_comment.php?comment_id=$commentId");
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] == 'success') {
        return Comment.fromJson(jsonResponse['data']);
      } else {
        throw Exception(jsonResponse['message']);
      }
    } else {
      throw Exception('Failed to load comment');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(
              "${MyConfig().SERVER}/uum_career_advisor_app/php/assets/profile/${comment.userProfilePic}"),
          // Using ! to assert that userProfilePic is not null
        ),
        title: Text(comment.username ?? "Anonymous",
            style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              comment.commentText ?? '',
              textAlign: TextAlign.justify,
            ),
            Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.thumb_up, color: Colors.green),
                  onPressed: () {
                    upvoteComment(context, comment.commentId!);
                  },
                ),
                Text('${comment.upvotes}'),
                IconButton(
                  icon: Icon(Icons.thumb_down, color: Colors.red),
                  onPressed: () {
                    downvoteComment(context, comment.commentId!);
                  },
                ),
                Text('${comment.downvotes}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
