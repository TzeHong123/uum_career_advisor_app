import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uum_career_advisor_app/myconfig.dart';
import 'package:flutter/material.dart';
import 'package:uum_career_advisor_app/models/question.dart';
import 'package:uum_career_advisor_app/views/screens/QuestionTab/MyPostDetailPage.dart';
import 'package:uum_career_advisor_app/views/screens/QuestionTab/PostDetailPage.dart';
import 'package:uum_career_advisor_app/views/screens/QuestionTab/QuestionCreationPage.dart';
import 'package:uum_career_advisor_app/models/user.dart';

class QuestionTabScreen extends StatefulWidget {
  final User user;

  const QuestionTabScreen({super.key, required this.user});

  @override
  _QuestionTabScreenState createState() => _QuestionTabScreenState();
}

class _QuestionTabScreenState extends State<QuestionTabScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Question> questions = [];
  List<Question> displayedQuestions = [];
  List<Question> userQuestions = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
    loadQuestions();
  }

  void _handleTabSelection() {
    if (_tabController.index == 1) {
      // When My Questions tab is selected
      _filterUserQuestions();
    } else {
      // When Q&A tab is selected
      setState(() {
        displayedQuestions = List.from(questions);
      });
    }
  }

  void _filterUserQuestions() {
    setState(() {
      userQuestions = questions
          .where((question) => question.userId == widget.user.id)
          .toList();
      displayedQuestions =
          userQuestions; // Only show user's posts in My Questions tab
    });
  }

  Future<void> loadQuestions() async {
    var url = Uri.parse(
        "${MyConfig().SERVER}/uum_career_advisor_app/php/load_question.php");
    try {
      var response = await http.post(url, body: {
        'user_id': widget.user.id.toString(), // Ensure ID is sent as a String
      });
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        if (jsonData['status'] == 'success') {
          var questionsData = jsonData['data']['questions'] as List;
          setState(() {
            questions =
                questionsData.map((item) => Question.fromJson(item)).toList();
            displayedQuestions = List.from(questions);
          });
        } else {
          print('Failed to load question posts');
        }
      } else {
        print('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  Widget _buildMyQuestionsTab() {
    return ListView.builder(
      itemCount: userQuestions.length, // Use userQuestions for this tab
      itemBuilder: (context, index) {
        final question = userQuestions[index];
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyPostDetailPage(question: question),
              ),
            );
          },
          child: Card(
            margin: EdgeInsets.all(8.0),
            child: Container(
              height: 150,
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(question.questionTitle ?? 'No Title',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  SizedBox(height: 14),
                  Text(question.questionContent ?? 'No Content',
                      style: Theme.of(context).textTheme.bodyText2),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Question'),
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
            Tab(text: 'Q&A'),
            Tab(text: 'My Questions'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildQuestionsTab(),
          _buildMyQuestionsTab(),
        ],
      ),
      floatingActionButton: _showAddButton()
          ? FloatingActionButton(
              onPressed: () {
                if (_tabController.index == 0) {
                  if (_checkUserRole() == 'student') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            QuestionCreationPage(user: widget.user),
                      ),
                    );
                  } else {
                    // Show a message or dialog informing that only students can ask questions
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Restricted Access"),
                          content: Text(
                              "Only students are allowed to ask questions."),
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

  Widget _buildQuestionsTab() {
    return ListView.builder(
      itemCount: displayedQuestions.length,
      itemBuilder: (context, index) {
        final question = displayedQuestions[index];
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PostDetailPage(question: question),
              ),
            );
          },
          child: Card(
            margin: EdgeInsets.all(8.0),
            child: Container(
              height: 150,
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    question.questionTitle ?? 'No Title',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(height: 14),
                  Text(
                    question.questionContent ?? 'No Content',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // //Function for handling backend for updating post like status
  // void toggleLike(Post post) async {
  //   // Assuming your User model has a userId attribute that stores the user ID
  //   String? userId = widget.user.id;
  //   print("Sending like status update for user_id: $userId");

  //   // Update the UI immediately
  //   setState(() {
  //     post.userHasLiked = post.userHasLiked == 1 ? 0 : 1;
  //     post.likes += post.userHasLiked == 1 ? 1 : -1;
  //   });

  //   // Send the update to the backend
  //   try {
  //     final response = await http.post(
  //       Uri.parse(
  //           "${MyConfig().SERVER}/uum_career_advisor_app/php/update_post_likes.php"),
  //       body: {
  //         'post_id': post.postId.toString(),
  //         'user_id': userId,
  //         'user_has_liked': post.userHasLiked
  //             .toString(), // Corrected to send userHasLiked status
  //       },
  //     );

  //     if (response.statusCode == 200) {
  //       // Handle successful response
  //       print("Like status updated successfully");
  //     } else {
  //       // Handle server error
  //       print(
  //           "Failed to update like status, server returned: ${response.statusCode}");
  //     }
  //   } catch (e) {
  //     // Handle error
  //     print("Error updating like status: $e");
  //   }
  // }

  // Future<void> addToFavourites(String postId) async {
  //   var url = Uri.parse(
  //       "${MyConfig().SERVER}/uum_career_advisor_app/php/add_to_favourites.php");
  //   try {
  //     var response = await http.post(url, body: {
  //       'user_id': widget.user.id,
  //       'post_id': postId,
  //     });
  //     var jsonData = json.decode(response.body);
  //     if (jsonData['status'] == 'success') {
  //       // Update UI or show a message
  //       print(jsonData['message']);
  //     } else {
  //       // Handle failure
  //       print(jsonData['message']);
  //     }
  //   } catch (e) {
  //     // Handle error
  //     print(e.toString());
  //   }
  // }

  void _searchPost(String query) {
    final filteredQuestions = questions.where((question) {
      final titleLower = question.questionTitle?.toLowerCase() ??
          ''; // Use null-aware operator
      final contentLower = question.questionContent?.toLowerCase() ??
          ''; // Use null-aware operator
      final searchLower = query.toLowerCase();

      return titleLower.contains(searchLower) ||
          contentLower.contains(searchLower);
    }).toList();

    setState(() {
      displayedQuestions = filteredQuestions;
    });
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String searchQuery = '';
        return AlertDialog(
          title: Text("Search Question"),
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
