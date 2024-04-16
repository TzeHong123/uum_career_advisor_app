import 'package:flutter/material.dart';
import 'package:uum_career_advisor_app/models/question.dart'; // Import your Question model

class MyPostDetailPage extends StatefulWidget {
  final Question question;

  MyPostDetailPage({Key? key, required this.question}) : super(key: key);

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

  void _updatePost() {
    // Implement your logic to update the post in your database
    Navigator.pop(context); // Optionally pop the context after updating
  }

  void _deletePost() {
    // Implement your logic to delete the post from your database
    Navigator.pop(context); // Pop the context after deletion
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit My Post"),
        backgroundColor: Colors.blueGrey,
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _deletePost,
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
              child: Text('Update Post'),
              style: ElevatedButton.styleFrom(primary: Colors.blueGrey),
            ),
          ],
        ),
      ),
    );
  }
}
