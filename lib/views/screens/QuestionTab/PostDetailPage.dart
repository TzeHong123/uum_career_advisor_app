import 'package:flutter/material.dart';
import 'package:uum_career_advisor_app/models/question.dart'; // Make sure to import your Question model

class PostDetailPage extends StatelessWidget {
  final Question question;

  const PostDetailPage({Key? key, required this.question}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Question Details"),
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              question.questionTitle ?? "No Title",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              question.questionContent ?? "No Content",
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
