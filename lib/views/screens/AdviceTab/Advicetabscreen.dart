import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uum_career_advisor_app/myconfig.dart';
import 'package:flutter/material.dart';
import 'package:uum_career_advisor_app/models/post.dart';
import 'package:uum_career_advisor_app/views/screens/AdviceTab/postCreationPage.dart';
import 'package:uum_career_advisor_app/models/question.dart';
import 'package:uum_career_advisor_app/views/screens/AdviceTab/QuestionCreationPage.dart';
import 'package:uum_career_advisor_app/models/user.dart';

class AdviceTabScreen extends StatefulWidget {
  final User user;

  const AdviceTabScreen({super.key, required this.user});

  @override
  _AdviceTabScreenState createState() => _AdviceTabScreenState();
}

class _AdviceTabScreenState extends State<AdviceTabScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Post> posts = [];
  List<Post> displayedPosts = [];
  List<Question> questions = [];
  List<Question> displayedQuestions = [];

  @override
  void initState() {
    super.initState();
    loadPosts();
    loadQuestions();
    _tabController = TabController(length: 2, vsync: this);
  }

  Future<void> loadPosts() async {
    var url = Uri.parse(
        "${MyConfig().SERVER}/uum_career_advisor_app/php/load_post.php");
    try {
      var response = await http
          .post(url); // Change this to post if your PHP expects POST request
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        if (jsonData['status'] == 'success') {
          var postsData =
              jsonData['data']['posts']; // Access the 'posts' key inside 'data'
          setState(() {
            posts =
                List<Post>.from(postsData.map((item) => Post.fromJson(item)));
            displayedPosts = List.from(posts);
          });
        } else {
          // Handle the failure case
          print('Failed to load posts');
        }
      } else {
        // Handle server error
        print('Server error: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions
      print('Error occurred: $e');
    }
  }

  Future<void> loadQuestions() async {
    var url = Uri.parse(
        "${MyConfig().SERVER}/uum_career_advisor_app/php/load_question.php");
    try {
      var response = await http.post(url);
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        if (jsonData['status'] == 'success') {
          var questionsData = jsonData['data']['questions'];
          setState(() {
            questions = List<Question>.from(
                questionsData.map((item) => Question.fromJson(item)));
            displayedQuestions = List.from(questions);
          });
        } else {
          print('Failed to load questions');
        }
      } else {
        print('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Advice'),
        backgroundColor: Colors.blueGrey,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              _showSearchDialog();
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Posts'),
            Tab(text: 'Ask Questions'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAdvicePostsTab(),
          _buildAskQuestionsTab(),
        ],
      ),
      floatingActionButton: _showAddButton()
          ? FloatingActionButton(
              onPressed: () {
                if (_tabController.index == 0) {
                  if (_checkUserRole() == 'senior') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PostCreationPage(user: widget.user),
                      ),
                    );
                  } else {
                    // Show a message or dialog informing that only seniors can create posts
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Restricted Access"),
                          content: Text(
                              "Sorry, students are not allowed to create posts."),
                          actions: <Widget>[
                            TextButton(
                              child: Text("OK"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                } else {
                  if (_checkUserRole() == 'student') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            QuestionCreationPage(user: widget.user),
                      ),
                    );
                  } else {
                    // Show a message or dialog informing that only seniors can create posts
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Restricted Access"),
                          content: Text(
                              "Sorry, only students are allowed to ask questions."),
                          actions: <Widget>[
                            TextButton(
                              child: Text("OK"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                }
              },
              child: Icon(Icons.add),
              backgroundColor: Colors.blueGrey,
            )
          : null,
    );
  }

  Widget _buildAdvicePostsTab() {
    return ListView.builder(
      itemCount: displayedPosts.length,
      itemBuilder: (context, index) {
        final post = displayedPosts[index];
        return Card(
          margin: EdgeInsets.all(8.0),
          child: Container(
            height: 70, // Fixed height for each post card
            child: ListTile(
              title: Text(post.postTitle ?? 'No Title'),
              //contentPadding: EdgeInsets.all(1),
              subtitle: Text(post.postContent ?? 'No Content'),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAskQuestionsTab() {
    return ListView.builder(
      itemCount: displayedQuestions.length,
      itemBuilder: (context, index) {
        final question = displayedQuestions[index];
        return Card(
          margin: EdgeInsets.all(8.0),
          child: Container(
            height: 150, // Fixed height for each question card
            padding: EdgeInsets.all(8.0), // Padding inside the card
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  question.questionTitle ?? 'No Title',
                  style: TextStyle(
                    fontWeight: FontWeight.bold, // Make title bold
                    fontSize: 18, // You can adjust the font size as needed
                  ),
                ),
                SizedBox(height: 14), // Gap between title and subtitle
                Text(
                  question.questionContent ?? 'No Content',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _searchPost(String query) {
    final filteredPosts = posts.where((post) {
      final titleLower =
          post.postTitle?.toLowerCase() ?? ''; // Use null-aware operator
      final contentLower =
          post.postContent?.toLowerCase() ?? ''; // Use null-aware operator
      final searchLower = query.toLowerCase();

      return titleLower.contains(searchLower) ||
          contentLower.contains(searchLower);
    }).toList();

    setState(() {
      displayedPosts = filteredPosts;
    });
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String searchQuery = '';
        return AlertDialog(
          title: Text("Search Advice"),
          content: TextField(
            onChanged: (value) {
              searchQuery = value;
            },
            decoration: InputDecoration(hintText: "Search here..."),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Search"),
              onPressed: () {
                Navigator.of(context).pop();
                _searchPost(searchQuery);
              },
            ),
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Object _checkUserRole() {
    if (widget.user.role == "Senior") {
      return 'senior';
    } else {
      return 'student';
    }
  }

  bool _showAddButton() {
    // Show the button for all users
    return true;
  }
}
