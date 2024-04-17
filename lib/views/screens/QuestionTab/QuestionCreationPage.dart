import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:uum_career_advisor_app/models/question.dart';
import 'package:uum_career_advisor_app/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:uum_career_advisor_app/myconfig.dart';
import 'package:uum_career_advisor_app/views/screens/QuestionTab/Questiontabscreen.dart';

class QuestionCreationPage extends StatefulWidget {
  final User user;

  QuestionCreationPage({Key? key, required this.user}) : super(key: key);

  @override
  _QuestionCreationPageState createState() => _QuestionCreationPageState();
}

class _QuestionCreationPageState extends State<QuestionCreationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _contentController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Question'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Question Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _contentController,
                decoration: InputDecoration(
                  labelText: 'Question Content',
                  border: OutlineInputBorder(),
                ),
                maxLines: 10,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter content';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.blueGrey, // Background color
                ),
                child: Text('Submit Question'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Create a Question object with user info and save it
                    Question newQuestion = Question(
                      userId: widget.user.id,
                      userName: widget.user.name,
                      questionTitle: _titleController.text,
                      questionContent: _contentController.text,
                    );

                    try {
                      http.post(
                          Uri.parse(
                              "${MyConfig().SERVER}/uum_career_advisor_app/php/add_new_question.php"),
                          body: {
                            "question_title": newQuestion.questionTitle,
                            "question_content": newQuestion.questionContent,
                            "user_id": widget.user.id,
                            "user_name": widget.user.name,
                          }).then((response) {
                        print(response.body);
                        if (response.statusCode == 200) {
                          var jsondata = jsonDecode(response.body);
                          if (jsondata['status'] == 'success') {
                            // User user = User.fromJson(jsondata['data']);
                            // print(user.name);
                            // print(user.email);
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Question Created!")));
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (content) => QuestionTabScreen(
                                          user: widget.user,
                                        )));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Failed to add question!")));
                          }
                        }
                      });
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Question Creation failed.")));
                    }

                    // Navigate back to previous screen
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
