import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ConnectionNetwork extends ChangeNotifier {
  late StreamSubscription subscription;
  var isDeviceConnected = false;
  bool isAlertSet = false;
  late BuildContext context;
  Future<void> checkActivity() async {
    var result = await Connectivity().checkConnectivity();

    if (result.isEmpty) {
      isDeviceConnected = false;
      if (!isDeviceConnected && isAlertSet == false) {
        showDialogBox();

        isAlertSet = true;
      }
    }
    notifyListeners();
  }

  Future<void> getConnectivity() async {
    subscription = Connectivity().onConnectivityChanged.listen((event) async {
      isDeviceConnected = await InternetConnectionChecker().hasConnection;
      if (!isDeviceConnected && isAlertSet == false) {
        await showDialogBox();
        isAlertSet = true;
      }
    });
    notifyListeners();
  }

  showDialogBox() => showCupertinoDialog<String>(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            actionScrollController: ScrollController(
                keepScrollOffset: true, initialScrollOffset: 10),
            title: const Text("No Connection",
                style: TextStyle(fontWeight: FontWeight.bold)),
            content: const Text(
              "Please Check your internet Connectivity",
              style: TextStyle(
                  fontFamily: 'CrimsonText',
                  fontSize: 15,
                  color: Colors.black87),
            ),
            actions: [
              TextButton(
                  onPressed: () async {
                    Navigator.pop(context, 'Cancel');

                    isAlertSet = false;

                    isDeviceConnected =
                        await InternetConnectionChecker().hasConnection;
                    if (!isDeviceConnected) {
                      showDialogBox();

                      isAlertSet = true;
                    }
                  },
                  child: const Text(
                    "OK",
                    style: TextStyle(color: Colors.black),
                  ))
            ],
          );
        },
      );
}
