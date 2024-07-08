import 'dart:async';
import 'package:bzuappgraduation/controller/login_controller.dart';
import 'package:bzuappgraduation/utilities/tools.dart';
import 'package:bzuappgraduation/view/LoginAndRegister/register.dart';
import 'package:bzuappgraduation/widgets/flutter_toast.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:regexpattern/regexpattern.dart';
import '../../animation/animation.dart';
import '../home.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool password = true;

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool visible = true;
  late StreamSubscription subscription;
  var isDeviceConnected = false;
  bool isAlertSet = false;

  @override
  void initState() {
    getConnectivity();
    checkActivity();
    super.initState();
  }

  checkActivity() async {
    var result = await Connectivity().checkConnectivity();

    if (result.isEmpty) {
      isDeviceConnected = false;
      if (!isDeviceConnected && isAlertSet == false) {
        showDialogBox();
        setState(() {
          isAlertSet = true;
        });
      }
    }
  }

  getConnectivity() {
    subscription = Connectivity().onConnectivityChanged.listen((event) async {
      isDeviceConnected = await InternetConnectionChecker().hasConnection;
      if (!isDeviceConnected && isAlertSet == false) {
        showDialogBox();
        setState(() {
          isAlertSet = true;
        });
      }
    });
  }

  @override
  void dispose() {
    subscription.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    LoginController loginController = context.watch<LoginController>();
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: Form(
          key: _formKey,
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 35.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          "Login",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 40.sp,
                              color: Colors.black,
                              fontFamily: "Pacifico"),
                        ),
                      ),
                      SizedBox(
                        height: 25.h,
                      ),
                      TextFormField(
                        // autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: loginController.email,
                        validator: (value) {
                          if (value.toString().isEmpty) {
                            return 'fill the email';
                          } else if ((value
                                  .toString()
                                  .trim()
                                  .contains("@student.birzeit.edu") ==
                              false)) {
                            return 'Error: you should email end student.birzeit.edu';
                          } else if ((value.toString().split("@").first.length <
                              7)) {
                            return 'Error: you should just have 7 numbers before @';
                          } else if ((value.toString().trim().isEmail()) ==
                              false) {
                            return ' The email is not correct';
                          }
                          return null;
                        },
                        cursorColor: Colors.black,

                        style: TextStyle(color: Colors.black, fontSize: 14.sp),
                        decoration: InputDecoration(
                            // filled: true,
                            // fillColor: Colors.transparent,

                            labelText: "Email",
                            labelStyle:
                                TextStyle(color: Colors.black, fontSize: 14.sp),
                            hintStyle: const TextStyle(color: Colors.black),
                            prefixIcon: const Icon(
                              Icons.email,
                              color: Colors.black,
                            ),
                            border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                borderSide: BorderSide(color: Colors.black)),
                            enabledBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                borderSide: BorderSide(color: Colors.black)),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.lightBlue, width: 2),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)))),

                        keyboardType: TextInputType.emailAddress,
                        autofillHints: const [AutofillHints.email],
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      TextFormField(
                        // autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: loginController.password,
                        obscureText: password,
                        cursorColor: Colors.black,

                        validator: (value) {
                          if (value.toString().isEmpty &&
                              value.toString().length < 6) {
                            return 'Fill the password at least 6 characters';
                          } else if (value.toString().isEmpty) {
                            return 'Fill the password';
                          } else if (value.toString().length < 6) {
                            return 'You should at least 6 characters';
                          }
                          return null;
                        },
                        style: TextStyle(color: Colors.black, fontSize: 14.sp),
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  //
                                  password = !password;
                                  //
                                });
                              },
                              icon: Icon(
                                (password == true
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                                color: Colors.black,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.transparent,
                            labelText: "Password",
                            labelStyle:
                                TextStyle(color: Colors.black, fontSize: 14.sp),
                            hintText: "Enter password at least 6 character ",
                            hintStyle: TextStyle(
                                color: Colors.black45, fontSize: 13.sp),
                            prefixIcon: const Icon(
                              Icons.password,
                              color: Colors.black,
                            ),
                            border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                borderSide: BorderSide(color: Colors.black)),
                            enabledBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                borderSide: BorderSide(color: Colors.black)),
                            focusedBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                borderSide: BorderSide(
                                    color: Colors.lightBlue, width: 2))),

                        keyboardType: TextInputType.visiblePassword,
                      ),
                      // Container(
                      //   margin: const EdgeInsets.only(right: 10),
                      //   width: MediaQuery.of(context).size.width >= 600
                      //       ? MediaQuery.of(context).size.width * 0.5
                      //       : MediaQuery.of(context).size.width * 0.8,
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.end,
                      //     children: [
                      //       TextButton(
                      //           onPressed: () {},
                      //           style: TextButton.styleFrom(
                      //             backgroundColor: Colors.transparent,
                      //             elevation: 0,
                      //           ),
                      //           child: const Text(
                      //             "Forget Password?",
                      //             style: TextStyle(
                      //                 fontSize: 15, color: Colors.black),
                      //           )),
                      //     ],
                      //   ),
                      // ),
                      SizedBox(
                        height: 25.h,
                      ),
                      Container(
                          height: 33.h,
                          decoration: BoxDecoration(
                              color: basicColor,
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.black,
                                    spreadRadius: 2,
                                    blurRadius: 30,
                                    blurStyle: BlurStyle.outer)
                              ],
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10))),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  elevation: 0,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10)))),
                              onPressed: () async {
                                setState(() {
                                  isLoading = true;
                                });
                                setState(() async {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    if (await loginController
                                            .loginWithEmail(context) ==
                                        true) {
                                      Navigator.of(context).pushReplacement(
                                          Animations(page: const Home()));
                                      setState(() {
                                        isLoading = false;
                                      });
                                    } else {
                                      setState(() {
                                        isLoading = false;
                                        flutterToast(
                                            'Error: email or password not correct');
                                      });
                                    }
                                  } else {
                                    isLoading = false;
                                  }
                                });
                              },
                              child: isLoading
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                          const CircularProgressIndicator(
                                              color: Colors.black,
                                              strokeWidth: 1),
                                          SizedBox(
                                            width: 15.w,
                                          ),
                                          Text("LOGIN".toUpperCase(),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14.sp,
                                                  fontFamily:
                                                      "fonts/TrajanPro.ttf"))
                                        ])
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.login,
                                          color: Colors.white,
                                        ),
                                        SizedBox(
                                          width: 14.w,
                                        ),
                                        Text(
                                          "LOGIN".toUpperCase(),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14.sp,
                                              fontFamily:
                                                  "fonts/TrajanPro.ttf"),
                                        ),
                                      ],
                                    ))),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Don't have an account?",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15.sp,
                                  fontFamily: "fonts/TrajanPro.ttf")),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .push(Animations(page: const Register()));
                              },
                              child: Text(
                                "Register",
                                style: TextStyle(
                                    fontSize: 15.sp, color: Colors.blue),
                              ))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
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
                    setState(() {
                      isAlertSet = false;
                    });
                    isDeviceConnected =
                        await InternetConnectionChecker().hasConnection;
                    if (!isDeviceConnected) {
                      showDialogBox();
                      setState(() {
                        isAlertSet = true;
                      });
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
