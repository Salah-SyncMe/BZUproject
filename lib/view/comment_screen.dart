import 'package:bzuappgraduation/utilities/tools.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/api.dart';

class CommentScreen extends StatefulWidget {
  final String postId;

  CommentScreen({required this.postId});

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController _commentController = TextEditingController();
  List<Map<String, dynamic>> comments = [];
  bool isLoading = true;
  String? userId;

  @override
  void initState() {
    super.initState();
    _fetchComments();
  }

  void _fetchComments() async {
    final api = Provider.of<API>(context, listen: false);
    userId = api.me?.id; // Get the current user's ID from the API class
    List<Map<String, dynamic>> fetchedComments = await api.fetchComments(widget.postId);
    setState(() {
      comments = fetchedComments;
      isLoading = false;
    });
  }

  void _addComment() async {
    final comment = _commentController.text.trim();
    if (comment.isNotEmpty) {
      final api = Provider.of<API>(context, listen: false);
      await api.addComment(widget.postId, comment);
      _commentController.clear();
      _fetchComments(); // Refresh comments
    }
  }

  Future<void> _deleteComment(String commentId) async {
    final api = Provider.of<API>(context, listen: false);
    await api.deleteComment(widget.postId, commentId);
    _fetchComments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : comments.isEmpty
                  ? Center(child: Text('No comments yet'))
                  : ListView.builder(
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  final comment = comments[index];
                  final isAuthor = comment['userId'] == userId; // Check user ID
                  final commentId = comment['id'];
                  print("Comment ID: $commentId, Comment: ${comment['comment']}"); // Debug statement

                  return ListTile(
                    title: Text(comment['userName']),
                    subtitle: Text(comment['comment']),
                    trailing: isAuthor
                        ? IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        if (commentId != null) {
                          _deleteComment(commentId);
                        } else {
                          print("Error: Comment ID is null");
                        }
                      },
                    )
                        : null,
                  );
                },
              ),
            ),
            TextField(
              controller: _commentController,
              decoration: const InputDecoration(
                labelText: 'Write your comment',
                border: OutlineInputBorder(),
              ),
              maxLines: null,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _addComment,
              child:  Text('Add Comment',style: TextStyle(color: basicColor),),
            ),
          ],
        ),
      ),
    );
  }
}
