import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:uum_career_advisor_app/models/user.dart';
import 'dart:convert';
import 'package:uum_career_advisor_app/myconfig.dart';
import 'package:flutter/material.dart';
import 'package:uum_career_advisor_app/models/question.dart';
import 'package:uum_career_advisor_app/views/screens/QuestionTab/Questiontabscreen.dart'; // Import your Question model

class MyPostDetailPage extends StatefulWidget {
  final Question question;
  final User user;

  MyPostDetailPage({Key? key, required this.user, required this.question})
      : super(key: key);

  @override
  _MyPostDetailPageState createState() => _MyPostDetailPageState();
}

class _MyPostDetailPageState extends State<MyPostDetailPage> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.question.questionTitle);
    _contentController =
        TextEditingController(text: widget.question.questionContent);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _updatePost() async {
    var url = Uri.parse(
        "${MyConfig().SERVER}/uum_career_advisor_app/php/update_question.php");
    var response = await http.post(url, body: {
      'question_id': widget.question.questionId.toString(),
      'question_title': _titleController.text,
      'question_content': _contentController.text,
    });

    if (response.body == 'success') {
      setState(() {
        widget.question.questionTitle = _titleController.text;
        widget.question.questionContent = _contentController.text;
      });
      Fluttertoast.showToast(
          msg: "Question details updated!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 16.0);
      Navigator.pop(context, true); // Optionally pop the context after updating
    } else {
      print('Failed to update question');
    }
  }

  void _deletePost() async {
    var url = Uri.parse(
        "${MyConfig().SERVER}/uum_career_advisor_app/php/delete_question.php");
    var response = await http.post(url, body: {
      'question_id': widget.question.questionId.toString(),
    });

    var responseData = json.decode(response.body);
    if (responseData['status'] == 'success') {
      Fluttertoast.showToast(
          msg: "Question Deleted!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 16.0);
      Navigator.pop(context, true);
    } else {
      print('Failed to delete post');
    }
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: Text(
              "Are you sure you want to delete this post? This action cannot be undone."),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Delete", style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
                _deletePost();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit My Question"),
        backgroundColor: Colors.blueGrey,
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _showDeleteConfirmation,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(labelText: 'Content'),
              maxLines: 5,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updatePost,
              child: Text('Confirm'),
              style: ElevatedButton.styleFrom(primary: Colors.blueGrey),
            ),
          ],
        ),
      ),
    );
  }
}
