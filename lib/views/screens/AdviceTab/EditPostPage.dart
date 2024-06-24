import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uum_career_advisor_app/myconfig.dart';
import 'package:flutter/material.dart';
import 'package:uum_career_advisor_app/models/post.dart';

class MyPostDetailPage extends StatefulWidget {
  final Post post;

  MyPostDetailPage({Key? key, required this.post}) : super(key: key);

  @override
  _MyPostDetailPageState createState() => _MyPostDetailPageState();
}

class _MyPostDetailPageState extends State<MyPostDetailPage> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.post.postTitle);
    _contentController = TextEditingController(text: widget.post.postContent);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _updatePost() async {
    var url = Uri.parse(
        "${MyConfig().SERVER}/uum_career_advisor_app/php/update_post.php");
    var response = await http.post(url, body: {
      'post_id':
          widget.post.postId.toString(), // assuming your post model has an id
      'post_title': _titleController.text,
      'post_content': _contentController.text,
    });

    if (response.body == 'success') {
      setState(() {
        // Update the local data that feeds the UI, if necessary
        widget.post.postTitle = _titleController.text;
        widget.post.postContent = _contentController.text;
      });
      Navigator.pop(context); // Optionally pop the context after updating
    } else {
      // Handle error
      print('Failed to update post');
    }
  }

  void _deletePost() async {
    var url = Uri.parse(
        "${MyConfig().SERVER}/uum_career_advisor_app/php/delete_post.php");
    var response = await http.post(url, body: {
      'post_id':
          widget.post.postId.toString(), // assuming your post model has an id
    });

    if (response.body == 'success') {
      Fluttertoast.showToast(
          msg: "Post deleted successfully!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 16.0);
      Navigator.pop(context); // Pop the context after deletion
    } else {
      // Handle error
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
                Navigator.of(context)
                    .pop(); // Dismiss the dialog but do nothing
              },
            ),
            TextButton(
              child: Text("Delete", style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
                _deletePost(); // Proceed with the deletion
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
        title: Text("Edit Advice Banner"),
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
