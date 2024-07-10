import 'package:flutter/material.dart';

class CommentController extends ChangeNotifier {
  final List<String> _comments = [];

  List<String> get comments => _comments;

  void addComment(String comment) {
    _comments.add(comment);
    notifyListeners();
  }

  void deleteComment(int index) {
    _comments.removeAt(index);
    notifyListeners();
  }
}
