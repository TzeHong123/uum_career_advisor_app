import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uum_career_advisor_app/models/user.dart';
import 'package:uum_career_advisor_app/models/post.dart';
import 'package:uum_career_advisor_app/myconfig.dart';
import 'package:uum_career_advisor_app/views/screens/ProfileTab/PostDetailPage.dart';

class SavedPostsScreen extends StatefulWidget {
  final User user;

  const SavedPostsScreen({super.key, required this.user});

  @override
  State<SavedPostsScreen> createState() => _SavedPostsScreenState();
}

class _SavedPostsScreenState extends State<SavedPostsScreen> {
  List<Post> savedPosts = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadSavedPosts();
  }

  void _loadSavedPosts() async {
    try {
      final response = await http.post(
        Uri.parse(
            "${MyConfig().SERVER}/uum_career_advisor_app/php/load_favorites.php"),
        body: {
          "userid": widget.user.id,
        },
      );

      print(response.body);
      if (response.statusCode == 200) {
        final jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          setState(() {
            savedPosts = (jsondata['data'] as List)
                .map((postJson) => Post.fromJson(postJson))
                .toList();
            isLoading = false;
          });
        } else {
          setState(() {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Failed to load saved posts!")));
            errorMessage = jsondata['message'] ?? 'Failed to load saved posts';
            isLoading = false;
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content:
                Text("Server error, please check your internet connection")));
        setState(() {
          errorMessage = 'Server error: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
    }
  }

  Widget _buildAdvicePostsTab() {
    return ListView.builder(
      itemCount: savedPosts.length,
      itemBuilder: (context, index) {
        final post = savedPosts[index];
        return Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      PostDetailPage(user: widget.user, post: post),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
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
                  SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Like counts: ${post.likes}',
                        style: TextStyle(color: Colors.blueGrey),
                      ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Saved Posts"),
        backgroundColor: Colors.blueGrey,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : savedPosts.isEmpty
                  ? const Center(child: Text("No saved posts available"))
                  : _buildAdvicePostsTab(),
    );
  }
}
