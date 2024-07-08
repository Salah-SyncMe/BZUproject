import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../model/api.dart';
import '../model/api_page.dart';
import '../model/chat_user.dart';
import '../utilities/tools.dart';

class PageControllers extends ChangeNotifier {
  bool isSearching = false;
  bool isSearchingPage = false;
  List<ChatUser> searchUser = [];
  List<PageUser> searchPage = [];
  TextEditingController name = TextEditingController();
  File? pathImage;

  Future<bool> checkPage(BuildContext context) async {
    try {
      return await context.read<API>().checkPages(name.text);
    } catch (e) {
      printLog(e);
      Fluttertoast.showToast(msg: 'error : $e');

      return false;
    }
  }

  void addSearch(var user) {
    searchUser.add(user);
    notifyListeners();
  }

  void clear() {
    searchUser.clear();
    notifyListeners();
  }

  void addSearchPage(var user) {
    searchPage.add(user);
    notifyListeners();
  }

  void clearPage() {
    searchPage.clear();
    notifyListeners();
  }

  Future<void> changeSearchPage(bool value) async {
    isSearchingPage = value;

    notifyListeners();
  }

  Future<void> changeSearch(bool value) async {
    isSearching = value;

    notifyListeners();
  }

  Future<void> createPage(BuildContext context) async {
    printLog(name.text.toString());
    printLog(pathImage);

    await Provider.of<API>(context, listen: false)
        .createPage(name.text, pathImage);

    await Fluttertoast.showToast(
        msg: "Add page successes",
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.blue,
        fontSize: 18.sp,
        gravity: ToastGravity.TOP);

    Navigator.pop(context);

    notifyListeners();
  }
}
