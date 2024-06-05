import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uum_career_advisor_app/myconfig.dart';
import 'package:flutter/material.dart';
import 'package:uum_career_advisor_app/models/post.dart';
import 'package:uum_career_advisor_app/views/screens/AdviceTab/EditPostPage.dart';
import 'package:uum_career_advisor_app/views/screens/AdviceTab/PostDetailPage.dart';
import 'package:uum_career_advisor_app/views/screens/AdviceTab/postCreationPage.dart';
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
      _filterUserPosts();
    } else {
      setState(() {
        displayedPosts = List.from(posts);
      });
    }
  }

  void _filterUserPosts() {
    setState(() {
      userPosts = posts.where((post) => post.userId == widget.user.id).toList();
      displayedPosts = userPosts;
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
          // Print the posts data for debugging
          print('Posts data: $postsData');
          setState(() {
            posts =
                List<Post>.from(postsData.map((item) => Post.fromJson(item)));
            displayedPosts = List.from(posts);
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
    if (widget.user.name == "admin") {
      return ListView.builder(
        itemCount: userPosts.length,
        itemBuilder: (context, index) {
          final post = userPosts[index];
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyPostDetailPage(post: post),
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
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
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
    } else {
      return Center(
        child: Text(
          'Only for Adminstrator.',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      );
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
            Tab(text: 'Advice'),
            Tab(text: 'Admin only'),
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
                  if (_checkUserRole() == 'senior' &&
                      widget.user.name == 'admin') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PostCreationPage(user: widget.user),
                      ),
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Restricted Access"),
                          content: Text(
                              "Sorry, only admin is allowed to create new advice banner."),
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
        // Debug print statements to verify the post data
        print('Post ID: ${post.postId}');
        print('Post Title: ${post.postTitle}');
        print('Post Likes: ${post.likes}');
        print('User Has Liked: ${post.userHasLiked}');
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    PostDetailPage(user: widget.user, post: post),
              ),
            );
          },
          child: Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
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
                  post.postTitle ?? 'No Title',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Improved Like button
                    IconButton(
                      icon: Icon(
                        post.userHasLiked == 1
                            ? Icons.thumb_up
                            : Icons.thumb_up_alt_outlined,
                        color:
                            post.userHasLiked == 1 ? Colors.blue : Colors.grey,
                        size: 30.0, // Increase the size for better visibility
                      ),
                      onPressed: () {
                        toggleLike(post);
                      },
                    ),
                    Text('${post.likes}'),
                    // Favorite button
                    IconButton(
                      icon: Icon(
                        post.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: post.isFavorite ? Colors.red : Colors.grey,
                      ),
                      onPressed: () {
                        addToFavourites(post.postId.toString());
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void toggleLike(Post post) async {
    String? userId = widget.user.id;
    print("Sending like status update for user_id: $userId");

    // Toggle the like status and update the UI immediately
    setState(() {
      post.userHasLiked = post.userHasLiked == 1 ? 0 : 1;
      post.likes += post.userHasLiked == 1 ? 1 : -1;
      print("Updated post: ${post.toJson()}"); // Debug statement
    });

    // Send the update to the backend
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
        print(jsonData['message']);
      } else {
        print(jsonData['message']);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void _searchPost(String query) {
    final filteredPosts = posts.where((post) {
      final titleLower = post.postTitle?.toLowerCase() ?? '';
      final contentLower = post.postContent?.toLowerCase() ?? '';
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

  String _checkUserRole() {
    return widget.user.role == "Senior" ? 'senior' : 'student';
  }

  bool _showAddButton() {
    return true;
  }
}
