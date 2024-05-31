import 'package:flutter/material.dart';
import 'package:uum_career_advisor_app/models/advice.dart';
import 'package:uum_career_advisor_app/models/post.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uum_career_advisor_app/myconfig.dart';

import '../../../models/user.dart';

class PostDetailPage extends StatefulWidget {
  final User user;
  final Post post;

  PostDetailPage({Key? key, required this.user, required this.post})
      : super(key: key);

  @override
  _PostDetailPageState createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  late Future<List<Advice>> futureAdvice;

  @override
  void initState() {
    super.initState();
    futureAdvice = fetchAdvices(widget.post.postId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Details'),
        backgroundColor: Colors.blueGrey,
        actions: <Widget>[
          if (widget.user.role == "Senior")
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () => _showAddAdviceDialog(context),
            )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.post.postTitle ?? "No Title",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              SizedBox(height: 20),
              Text(
                textAlign: TextAlign.justify,
                widget.post.postContent ?? "No Content",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 20),
              FutureBuilder<List<Advice>>(
                future: futureAdvice,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } else if (snapshot.hasData) {
                    return Column(
                      children: snapshot.data!
                          .map((advice) => Container(
                                margin: EdgeInsets.all(10),
                                padding: EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 10),
                                decoration: BoxDecoration(
                                  color: Colors.blueGrey[50],
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      spreadRadius: 1,
                                      blurRadius: 5,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      advice.adviceContent,
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: 30),
                                    Text(
                                      'By ${advice.userName ?? "Unknown"}',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: 3),
                                    if (advice.jobTitle != null &&
                                        advice.companyName !=
                                            null) // Only display if both job title and company name are available
                                      Text(
                                        '${advice.jobTitle} at ${advice.companyName}',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.black54,
                                        ),
                                      ),
                                  ],
                                ),
                              ))
                          .toList(),
                    );
                  } else {
                    return Text("No advices found.");
                  }
                },
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(
                      widget.post.userHasLiked == 1
                          ? Icons.thumb_up
                          : Icons.thumb_up_alt_outlined,
                      color: widget.post.userHasLiked == 1
                          ? Colors.blue
                          : Colors.grey,
                    ),
                    onPressed: () {
                      toggleLike(widget.post);
                    },
                  ),
                  Text('${widget.post.likes} Likes'),
                  IconButton(
                    icon: Icon(
                      widget.post.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: widget.post.isFavorite ? Colors.red : Colors.grey,
                    ),
                    onPressed: () {
                      addToFavourites(widget.post.postId.toString());
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<Advice>> fetchAdvices(String? postId) async {
    final response = await http.get(Uri.parse(
        "${MyConfig().SERVER}/uum_career_advisor_app/php/load_advice_content.php?post_id=$postId"));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] == 'success') {
        List data = jsonResponse['data'];
        return data.map((json) => Advice.fromJson(json)).toList();
      } else {
        throw Exception(jsonResponse['message']);
      }
    } else {
      throw Exception('Failed to load advice');
    }
  }

  void _showAddAdviceDialog(BuildContext context) {
    TextEditingController adviceController = TextEditingController();
    TextEditingController jobTitleController = TextEditingController();
    TextEditingController companyNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add Your Advice"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: adviceController,
                decoration: InputDecoration(hintText: "Type your advice here"),
              ),
              TextField(
                controller: jobTitleController,
                decoration: InputDecoration(hintText: "Your Job Title"),
              ),
              TextField(
                controller: companyNameController,
                decoration: InputDecoration(hintText: "Your Company Name"),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Submit'),
              onPressed: () {
                if (adviceController.text.isNotEmpty &&
                    jobTitleController.text.isNotEmpty &&
                    companyNameController.text.isNotEmpty) {
                  _addAdviceToPost(
                    adviceController.text,
                    jobTitleController.text,
                    companyNameController.text,
                  );
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _addAdviceToPost(
      String advice, String jobTitle, String companyName) async {
    var url = Uri.parse(
        "${MyConfig().SERVER}/uum_career_advisor_app/php/add_new_advice_content.php");
    try {
      var response = await http.post(url, body: {
        'post_id': widget.post.postId,
        'user_id': widget.user.id,
        'user_name': widget.user.name,
        'job_title': jobTitle, // Add this field
        'company_name': companyName, // Add this field
        'advice_title': widget.post.postTitle,
        'advice_content': advice,
      });
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print("Advice added successfully: ${data['message']}");
      } else {
        print("Failed to add advice: Status code ${response.statusCode}");
      }
    } catch (e) {
      print("Error when adding advice: $e");
    }
  }

  void toggleLike(Post post) async {
    // Assume user's ID is accessible via some model
    String? userId = widget.user.id; // Substitute with actual user ID logic

    // Update the UI immediately for better responsiveness
    setState(() {
      post.userHasLiked = post.userHasLiked == 1 ? 0 : 1;
      post.likes += post.userHasLiked == 1 ? 1 : -1;
    });

    // Then send the update to the backend
    try {
      final response = await http.post(
        Uri.parse(
            "${MyConfig().SERVER}/uum_career_advisor_app/php/update_post_likes.php"),
        body: {
          'post_id': post.postId.toString(),
          'user_id': userId,
          'user_has_liked': post.userHasLiked.toString(),
        },
      );

      if (response.statusCode == 200) {
        print("Like status updated successfully.");
      } else {
        print(
            "Failed to update like status. Server error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error updating like status: $e");
    }
  }

  Future<void> addToFavourites(String postId) async {
    var url = Uri.parse(
        "${MyConfig().SERVER}/uum_career_advisor_app/php/add_to_favourites.php");
    try {
      var response = await http.post(url, body: {
        'user_id': widget.user.id, // Substitute with actual user ID logic
        'post_id': postId,
      });
      var jsonData = json.decode(response.body);
      if (jsonData['status'] == 'success') {
        print(jsonData['message']);
      } else {
        print(jsonData['message']);
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
