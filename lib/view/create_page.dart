import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../controller/page_controller.dart';
import '../controller/provider_file.dart';
import '../model/api.dart';
import '../utilities/tools.dart';
import '../widgets/flutter_toast.dart';

class CreatePage extends StatefulWidget {
  final API api;

  const CreatePage({super.key, required this.api});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  String? verify;

  TextEditingController name = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;
  bool visible = true;
  String number = "";

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      CustomFileImage customFileImage = context.read<CustomFileImage>();

      PageControllers page = context.read<PageControllers>();

      await customFileImage.getImageFileFromAssets("images/profile.jpg");
      page.pathImage = customFileImage.file;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PageControllers page = context.watch<PageControllers>();

    CustomFileImage value = context.watch<CustomFileImage>();

    return Scaffold(
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        body: SafeArea(
            child: Form(
                key: _formKey,
                child: SafeArea(
                  child: Center(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Padding(
                        padding: EdgeInsets.only(left: 30.w, right: 30.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Center(
                              child: Text(
                                "Create page",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 40.sp,
                                    color: Colors.black,
                                    fontFamily: "Pacifico"),
                              ),
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            Stack(
                              alignment: const FractionalOffset(1.2, 1.2),
                              children: [
                                (value.file.path != "")
                                    ? CircleAvatar(
                                        backgroundImage:
                                            FileImage(value.file2()),
                                        radius: 50,
                                      )
                                    : Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(52),
                                                border: Border.all(
                                                    color: Colors.black,
                                                    width: 2)),
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
                                                        alignment:
                                                            Alignment.center,
                                                        child: AlertDialog(
                                                          elevation: 19,
                                                          alignment:
                                                              Alignment.center,
                                                          shadowColor:
                                                              Colors.red,
                                                          shape:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                const BorderSide(
                                                                    width: 5,
                                                                    color: Colors
                                                                        .black),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        25),
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
                                                                      setState(
                                                                          () {
                                                                        page.pathImage =
                                                                            value.file;
                                                                      });
                                                                      setState(
                                                                          () {});
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    child: Text(
                                                                      "Take a Camera"
                                                                          .toUpperCase(),
                                                                      style: TextStyle(
                                                                          fontSize: 14
                                                                              .sp,
                                                                          color: Colors
                                                                              .blue,
                                                                          fontWeight:
                                                                              FontWeight.bold),
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
                                                                      setState(
                                                                          () {
                                                                        page.pathImage =
                                                                            value.file;
                                                                      });
                                                                      setState(
                                                                          () {});
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    child: Text(
                                                                        "Select a Gallary"
                                                                            .toUpperCase(),
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                14.sp,
                                                                            color: Colors.blue,
                                                                            fontWeight: FontWeight.bold)))
                                                              ],
                                                            ),
                                                          ),
                                                          title: Text(
                                                            "Choose the Picture",
                                                            style: TextStyle(
                                                                fontSize: 18.sp,
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    "Pacifico",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                            textAlign: TextAlign
                                                                .center,
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
                                                      width: 5,
                                                      color: Colors.black),
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
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      TextButton(
                                                          onPressed: () async {
                                                            setState(() {});
                                                            await value
                                                                .changeFileCamera();
                                                            setState(() {
                                                              page.pathImage =
                                                                  value.file;
                                                            });
                                                            setState(() {});
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text(
                                                            "Take a Camera"
                                                                .toUpperCase(),
                                                            style: TextStyle(
                                                                fontSize: 14.sp,
                                                                color:
                                                                    Colors.blue,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                            textAlign: TextAlign
                                                                .center,
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
                                                              page.pathImage =
                                                                  value.file;
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
                                                      fontFamily: "Pacifico",
                                                      fontWeight:
                                                          FontWeight.bold),
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
                              height: 20.h,
                            ),
                            TextFormField(
                              // autovalidateMode: AutovalidateMode.onUserInteraction,
                              controller: page.name,

                              validator: (value) {
                                if (value.toString().isEmpty) {
                                  return 'fill the name';
                                }
                                return null;
                              },
                              style: TextStyle(
                                  color: Colors.black, fontSize: 14.sp),
                              decoration: const InputDecoration(
                                  filled: true,
                                  fillColor: Colors.transparent,
                                  labelText: "Name Page",
                                  labelStyle: TextStyle(
                                      color: Colors.black, fontSize: 15),
                                  hintStyle: TextStyle(color: Colors.black),
                                  prefixIcon: Icon(
                                    Icons.drive_file_rename_outline,
                                    color: Colors.black,
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      borderSide:
                                          BorderSide(color: Colors.black)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      borderSide:
                                          BorderSide(color: Colors.black)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.lightBlue, width: 2),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20)))),
                              cursorColor: Colors.black,
                              keyboardType: TextInputType.name,
                              autofillHints: const [AutofillHints.name],
                            ),
                            SizedBox(
                              height: 25.h,
                            ),
                            Container(
                                decoration: BoxDecoration(
                                    color: basicColor,
                                    boxShadow: const [
                                      BoxShadow(
                                          color: Colors.black,
                                          spreadRadius: 2,
                                          blurRadius: 30,
                                          blurStyle: BlurStyle.outer)
                                    ],
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10))),
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

                                      if (_formKey.currentState!.validate()) {
                                        //
                                        if (await page.checkPage(context) ==
                                            true) {
                                          await page.createPage(context);

                                          value.file = File('');
                                          setState(() {
                                            isLoading = false;
                                          });
                                        } else {
                                          setState(() {
                                            flutterToast(
                                                'Error: the name page was added before');
                                            isLoading = false;
                                          });
                                        }
                                      } else {
                                        setState(() {
                                          isLoading = false;
                                        });
                                      }
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
                                                Text("Create".toUpperCase(),
                                                    style: TextStyle(
                                                        fontSize: 14.sp,
                                                        color: Colors.white,
                                                        fontFamily:
                                                            "fonts/TrajanPro.ttf"))
                                              ])
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                Icons.create_outlined,
                                                color: Colors.white,
                                              ),
                                              SizedBox(
                                                width: 15.w,
                                              ),
                                              Text(
                                                "Create".toUpperCase(),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14.sp,
                                                    fontFamily:
                                                        "fonts/TrajanPro.ttf"),
                                              ),
                                            ],
                                          ))),
                          ],
                        ),
                      ),
                    ),
                  ),
                ))));
  }
}
