import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../model/api.dart';
import '../view/LoginAndRegister/login.dart';

class Logout extends StatelessWidget {
  const Logout({super.key});

  @override
  Widget build(BuildContext context) {
    API api = context.watch<API>();

    return IconButton(
      onPressed: () {
        showCupertinoDialog<String>(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                actionScrollController: ScrollController(
                    keepScrollOffset: true, initialScrollOffset: 10),
                title: Text("Log out",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16.sp)),
                content: Text("Are you sure to log out",
                    style: TextStyle(
                        fontFamily: 'CrimsonText',
                        fontSize: 14.sp,
                        color: Colors.black87)),
                actions: [
                  TextButton(
                      onPressed: () async {
                        // await API.updateActiveStatus(false);
                        await api.exitData();
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const Login(),
                        ));
                      },
                      child: const Text(
                        "Yes",
                        style: TextStyle(color: Colors.black),
                      )),
                  TextButton(
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                      child: const Text("No",
                          style: TextStyle(color: Colors.black)))
                ],
              );
            });
      },
      icon: const Icon(
        Icons.logout,
        color: Colors.black,
      ),
    );
  }
}
