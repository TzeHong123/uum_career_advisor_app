import 'package:flutter/material.dart';
import 'package:uum_career_advisor_app/models/post.dart'; // Make sure to import your post model

class PostDetailPage extends StatelessWidget {
  final Post post;

  const PostDetailPage({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(post.postTitle ?? "Post Details"),
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              post.postTitle ?? "No Title",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              post.postContent ?? "No Content",
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
