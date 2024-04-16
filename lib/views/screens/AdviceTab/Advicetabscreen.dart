import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uum_career_advisor_app/myconfig.dart';
import 'package:flutter/material.dart';
import 'package:uum_career_advisor_app/models/post.dart';
import 'package:uum_career_advisor_app/views/screens/AdviceTab/PostDetailPage.dart';
import 'package:uum_career_advisor_app/views/screens/AdviceTab/postCreationPage.dart';
import 'package:uum_career_advisor_app/models/question.dart';
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
  List<Post> userPosts = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
    loadPosts();
  }

  void _handleTabSelection() {
    if (_tabController.index == 1) {
      // When My Posts tab is selected
      _filterUserPosts();
    } else {
      // When Advice Posts tab is selected
      setState(() {
        displayedPosts = List.from(posts);
      });
    }
  }

  void _filterUserPosts() {
    setState(() {
      userPosts = posts.where((post) => post.userId == widget.user.id).toList();
      displayedPosts = userPosts; // Only show user's posts in My Posts tab
    });
  }

  Future<void> loadPosts() async {
    var url = Uri.parse(
        "${MyConfig().SERVER}/uum_career_advisor_app/php/load_post.php");
    try {
      var response = await http.post(url, body: {
        'user_id': widget.user.id,
      });
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        if (jsonData['status'] == 'success') {
          var postsData = jsonData['data']['posts'];
          setState(() {
            posts =
                List<Post>.from(postsData.map((item) => Post.fromJson(item)));
            displayedPosts = List.from(posts); // Initially show all posts
          });
        } else {
          print('Failed to load posts');
        }
      } else {
        print('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  Widget _buildMyPostsTab() {
    return ListView.builder(
      itemCount: userPosts.length, // Use userPosts for this tab
      itemBuilder: (context, index) {
        final post = userPosts[index];
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PostDetailPage(post: post),
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
                  Text(post.postTitle ?? 'No Title',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  SizedBox(height: 14),
                  Text(post.postContent ?? 'No Content',
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
            Tab(text: 'Advice posts'),
            Tab(text: 'My Posts'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAdvicePostsTab(),
          _buildMyPostsTab(),
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
                              "Sorry, students are not allowed to create advice posts."),
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
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PostDetailPage(post: post),
              ),
            );
          },
          child: Card(
            margin: EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.postTitle ?? 'No Title',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.0),
                  Text(post.postContent ?? 'No Content'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton.icon(
                        // Toggle like button
                        icon: Icon(
                          post.userHasLiked == 1
                              ? Icons.thumb_up
                              : Icons.thumb_up_alt_outlined,
                          color: post.userHasLiked == 1
                              ? Colors.blue
                              : Colors.grey,
                        ),
                        label: Text(
                            '${post.likes}'), // Display the total number of likes
                        onPressed: () {
                          toggleLike(post);
                        },
                      ),

                      // Other buttons or information can be added here
                      IconButton(
                        icon: Icon(posts[index].isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border),
                        onPressed: () {
                          addToFavourites(post.postId.toString());
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  //Function for handling backend for updating post like status
  void toggleLike(Post post) async {
    // Assuming your User model has a userId attribute that stores the user ID
    String? userId = widget.user.id;
    print("Sending like status update for user_id: $userId");

    // Update the UI immediately
    setState(() {
      post.userHasLiked = post.userHasLiked == 1 ? 0 : 1;
      post.likes += post.userHasLiked == 1 ? 1 : -1;
    });

    // Send the update to the backend
    try {
      final response = await http.post(
        Uri.parse(
            "${MyConfig().SERVER}/uum_career_advisor_app/php/update_post_likes.php"),
        body: {
          'post_id': post.postId.toString(),
          'user_id': userId,
          'user_has_liked': post.userHasLiked
              .toString(), // Corrected to send userHasLiked status
        },
      );

      if (response.statusCode == 200) {
        // Handle successful response
        print("Like status updated successfully");
      } else {
        // Handle server error
        print(
            "Failed to update like status, server returned: ${response.statusCode}");
      }
    } catch (e) {
      // Handle error
      print("Error updating like status: $e");
    }
  }

  Future<void> addToFavourites(String postId) async {
    var url = Uri.parse(
        "${MyConfig().SERVER}/uum_career_advisor_app/php/add_to_favourites.php");
    try {
      var response = await http.post(url, body: {
        'user_id': widget.user.id,
        'post_id': postId,
      });
      var jsonData = json.decode(response.body);
      if (jsonData['status'] == 'success') {
        // Update UI or show a message
        print(jsonData['message']);
      } else {
        // Handle failure
        print(jsonData['message']);
      }
    } catch (e) {
      // Handle error
      print(e.toString());
    }
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
