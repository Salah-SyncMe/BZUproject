import 'package:bzuappgraduation/controller/provider_file.dart';
import 'package:bzuappgraduation/utilities/tools.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../controller/registeration_controller.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register>
    with AutomaticKeepAliveClientMixin<Register> {
  String? verify;

  bool password = true;
  bool conPassword = true;
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController conPass = TextEditingController();
  TextEditingController name = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool isloading = false;
  bool isloadingphone = false;
  bool visible = true;
  String number = "";
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      CustomFileImage customFileImage = context.read<CustomFileImage>();

      RegisterController register = context.read<RegisterController>();

      await customFileImage.getImageFileFromAssets("images/profile.jpg");
      register.pathImage = customFileImage.file;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    RegisterController register = context.watch<RegisterController>();
    CustomFileImage value = context.watch<CustomFileImage>();
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      // ),
      body: Form(
          key: _formKey,
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 35.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          "Register",
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
                      Stack(
                        alignment: const FractionalOffset(1.2, 1.2),
                        children: [
                          (value.file.path != "")
                              ? CircleAvatar(
                                  backgroundImage: FileImage(value.file2()),
                                  radius: 50.r,
                                )
                              : Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(52),
                                          border: Border.all(
                                              color: Colors.black, width: 2)),
                                      child: CircleAvatar(
                                        backgroundImage:
                                            FileImage(value.file2()),
                                        radius: 50,
                                        backgroundColor: Colors.white,
                                      ),
                                    ),
                                    InkWell(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return Container(
                                                  alignment: Alignment.center,
                                                  child: AlertDialog(
                                                    elevation: 19,
                                                    alignment: Alignment.center,
                                                    shadowColor: Colors.red,
                                                    shape: OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                              width: 5,
                                                              color:
                                                                  Colors.black),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              25.r),
                                                    ),
                                                    content: SizedBox(
                                                      height: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .shortestSide *
                                                          0.4,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          TextButton(
                                                              onPressed:
                                                                  () async {
                                                                await value
                                                                    .changeFileCamera();
                                                                setState(() {
                                                                  register.pathImage =
                                                                      value
                                                                          .file;
                                                                });
                                                                setState(() {});
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Text(
                                                                "Take a Camera"
                                                                    .toUpperCase(),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14.sp,
                                                                    color: Colors
                                                                        .blue,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              )),
                                                          const SizedBox(
                                                            height: 20,
                                                          ),
                                                          TextButton(
                                                              onPressed:
                                                                  () async {
                                                                await value
                                                                    .changeFileGalary();
                                                                setState(() {
                                                                  register.pathImage =
                                                                      value
                                                                          .file;
                                                                });
                                                                setState(() {});
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Text(
                                                                  "Select a Gallary"
                                                                      .toUpperCase(),
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14.sp,
                                                                      color: Colors
                                                                          .blue,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold)))
                                                        ],
                                                      ),
                                                    ),
                                                    title: Text(
                                                      "Choose the Picture",
                                                      style: TextStyle(
                                                          fontSize: 18.sp,
                                                          color: Colors.black,
                                                          fontFamily:
                                                              "Pacifico",
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ));
                                            },
                                          );
                                        },
                                        child: Icon(Icons.add_a_photo,
                                            size: 20.w)),
                                  ],
                                ),
                          IconButton(
                              splashRadius: 100,
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Container(
                                        alignment: Alignment.center,
                                        child: AlertDialog(
                                          elevation: 19,
                                          alignment: Alignment.center,
                                          shadowColor: Colors.red,
                                          shape: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                width: 5, color: Colors.black),
                                            borderRadius:
                                                BorderRadius.circular(25),
                                          ),
                                          content: SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .shortestSide *
                                                0.4,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                TextButton(
                                                    onPressed: () async {
                                                      setState(() {});
                                                      await value
                                                          .changeFileCamera();
                                                      setState(() {
                                                        register.pathImage =
                                                            value.file;
                                                      });
                                                      setState(() {});
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text(
                                                      "Take a Camera"
                                                          .toUpperCase(),
                                                      style: TextStyle(
                                                          fontSize: 14.sp,
                                                          color: Colors.blue,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      textAlign:
                                                          TextAlign.center,
                                                    )),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                TextButton(
                                                    onPressed: () async {
                                                      setState(() {});
                                                      await value
                                                          .changeFileGalary();
                                                      setState(() {
                                                        register.pathImage =
                                                            value.file;
                                                      });
                                                      setState(() {});
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text(
                                                        "Select a Gallary"
                                                            .toUpperCase(),
                                                        style: TextStyle(
                                                            fontSize: 14.sp,
                                                            color: Colors.blue,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)))
                                              ],
                                            ),
                                          ),
                                          title: Text(
                                            "Choose the Picture",
                                            style: TextStyle(
                                                fontSize: 18.sp,
                                                color: Colors.black,
                                                fontFamily: "Pacifico",
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                        ));
                                  },
                                );
                              },
                              icon: (value.file.path != "")
                                  ? Icon(Icons.add_a_photo, size: 20.w)
                                  : const SizedBox(),
                              color: Colors.black)
                        ],
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      TextFormField(
                        // autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: register.name,

                        validator: (value) {
                          if (value.toString().isEmpty) {
                            return 'fill the name';
                          }
                          return null;
                        },
                        style: TextStyle(color: Colors.black, fontSize: 14.sp),
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.transparent,
                            labelText: "Name",
                            labelStyle:
                                TextStyle(color: Colors.black, fontSize: 14.sp),
                            hintStyle: const TextStyle(color: Colors.black),
                            prefixIcon: const Icon(
                              Icons.person,
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
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.name,
                        autofillHints: const [AutofillHints.name],
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      TextFormField(
                        // autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: register.email,
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
                          }
                          return null;
                        },
                        style: TextStyle(color: Colors.black, fontSize: 14.sp),
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.transparent,
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
                        controller: register.password,
                        obscureText: password,

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
                            fillColor: Colors.transparent,
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.lightBlue, width: 2),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
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
                            labelText: "Password",
                            labelStyle: const TextStyle(color: Colors.black),
                            hintText: "Enter password at least 6 character ",
                            hintStyle: TextStyle(
                                color: Colors.black45, fontSize: 14.sp),
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
                                borderSide: BorderSide(color: Colors.black))),

                        keyboardType: TextInputType.visiblePassword,
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      TextFormField(
                        // autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: register.coPassword,
                        obscureText: conPassword,

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
                            fillColor: Colors.transparent,
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.lightBlue, width: 2),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  //
                                  conPassword = !conPassword;
                                  //
                                });
                              },
                              icon: Icon(
                                (conPassword == true
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                                color: Colors.black,
                              ),
                            ),
                            filled: true,
                            labelText: "Confirm Password",
                            labelStyle: const TextStyle(color: Colors.black),
                            hintText: "Enter password at least 6 character ",
                            hintStyle: TextStyle(
                                color: Colors.black45, fontSize: 14.sp),
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
                                borderSide: BorderSide(color: Colors.black))),

                        keyboardType: TextInputType.visiblePassword,
                      ),
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
                                  isloading = true;
                                });

                                if (_formKey.currentState!.validate()) {
                                  if (register.coPassword.text.toString() ==
                                      (register.password.text.toString())) {
                                    await register.registerWithEmail(context);

                                    // await sendEmail(
                                    //     "${register.name.text}",
                                    //     register.email.text
                                    //         .toString()
                                    //         .toString());

                                    setState(() async {
                                      isloading = false;

                                      await value.getImageFileFromAssets(
                                          "images/profile.jpg");
                                      register.clear();
                                    });
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: "Thr password not match",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.blue,
                                        textColor: Colors.black,
                                        fontSize: 16.0);
                                    setState(() {
                                      isloading = false;
                                    });
                                  }
                                } else {
                                  setState(() {
                                    isloading = false;
                                  });
                                }
                              },
                              child: isloading
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
                                          Text("Sign up".toUpperCase(),
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
                                          width: 15.w,
                                        ),
                                        Text(
                                          "Sign up".toUpperCase(),
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
                        children: [
                          Text("Have an account?",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15.sp,
                                  fontFamily: "fonts/TrajanPro.ttf")),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    fontSize: 15.sp, color: Colors.black),
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

  @override
  bool get wantKeepAlive => true;
}
