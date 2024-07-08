import 'dart:io';

import 'package:bzuappgraduation/utilities/tools.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../model/api.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({super.key});

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  bool isUploading = false, isButtonClick = false;
  TextEditingController textcontrol = TextEditingController();
  List<XFile>? images;
  XFile? imageCamera;
  bool circle = false;

  @override
  Widget build(BuildContext context) {
    API api = context.watch<API>();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: SafeArea(
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back),
                    color: Colors.black,
                  ),
                  Text(
                    "Create Post",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        height: 1,
                        fontSize: 18.sp,
                        color: Colors.black,
                        fontFamily: "VarelaRound"),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: ElevatedButton(
                        onPressed: isButtonClick
                            ? () async {
                                if (images?.length == null &&
                                    imageCamera?.length() == null) {
                                  setState(() {
                                    circle = true;
                                  });
                                  await api.savedPost(
                                      textcontrol.value.text.toString());
                                  setState(() {
                                    circle = false;
                                  });
                                  Navigator.pop(context);
                                  Fluttertoast.showToast(
                                      msg:
                                          "Was add post to ${api.me?.name.toString() ?? ''}",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.blue,
                                      textColor: Colors.black,
                                      fontSize: 16.sp);
                                } else if (images?.length != null) {
                                  setState(() {
                                    circle = true;
                                  });
                                  await api.savedPostWithPicture(
                                      textcontrol.value.text.toString(),
                                      images);
                                  setState(() {
                                    circle = false;
                                  });
                                  Navigator.pop(context);
                                  Fluttertoast.showToast(
                                      msg:
                                          "Was add post to ${api.me?.name.toString() ?? ''}",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.blue,
                                      textColor: Colors.black,
                                      fontSize: 16.sp);
                                } else if (imageCamera?.length() != null) {
                                  setState(() {
                                    circle = true;
                                  });
                                  await api.savedPostWithCamera(
                                      textcontrol.value.text.toString(),
                                      imageCamera);
                                  setState(() {
                                    circle = false;
                                  });
                                  Navigator.pop(context);
                                  Fluttertoast.showToast(
                                      msg:
                                          "Was add post to ${api.me?.name.toString() ?? ''}",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.blue,
                                      textColor: Colors.black,
                                      fontSize: 16.0);
                                }
                              }
                            : null,
                        style: circle == false
                            ? ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                backgroundColor: isButtonClick
                                    ? basicColor
                                    : Colors.transparent,
                              )
                            : ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                elevation: 0),
                        child: circle == false
                            ? Text(
                                "Post",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    height: 0,
                                    fontSize: 16.sp,
                                    color: isButtonClick
                                        ? Colors.white
                                        : Colors.black,
                                    fontFamily: "VarelaRound"),
                              )
                            : const CircularProgressIndicator(
                                color: Colors.black, strokeWidth: 0)),
                  )
                ],
              ),
              const Divider(color: Colors.black45),
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(90),
                      child: CachedNetworkImage(
                        width: 40.w,
                        height: 40.w,
                        imageUrl: "${api.me?.image}",
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(
                          color: Colors.black,
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        api.me?.name.toString() ?? '',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            height: 1,
                            fontSize: 16.sp,
                            color: Colors.black,
                            fontFamily: "CrimsonText"),
                      ),
                      Text(
                        api.me?.email.toString() ?? '',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            height: 2,
                            fontSize: 14.sp,
                            color: Colors.black54,
                            fontFamily: "CrimsonText"),
                      )
                    ],
                  )
                ],
              ),
              Expanded(
                child: TextFormField(
                  maxLines: null,
                  onChanged: (value) {
                    if (value.toString().isEmpty &&
                        images?.length == null &&
                        imageCamera?.length() == null) {
                      setState(() {
                        isButtonClick = false;
                      });
                    } else {
                      setState(() {
                        isButtonClick = true;
                      });
                    }
                  },
                  controller: textcontrol,
                  keyboardType: TextInputType.multiline,
                  // expands: SnackbarController.isSnackbarBeingShown,
                  // scrollPhysics: PageScrollPhysics(),
                  onTap: () {},
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      height: 1,
                      fontSize: 23,
                      color: Colors.black,
                      fontFamily: "VarelaRound"),
                  decoration: const InputDecoration(
                    hintText: "What's on your mind?",
                    hintStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        height: 1,
                        fontSize: 23,
                        color: Colors.black54,
                        fontFamily: "VarelaRound"),
                    contentPadding: EdgeInsets.all(10),
                    alignLabelWithHint: true,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                  ),
                ),
              ),
              isUploading == true
                  ? images?.length == null
                      ? (imageCamera == null)
                          ? const SizedBox()
                          : Expanded(
                              child: ListView.builder(
                                  physics: const PageScrollPhysics(),
                                  itemCount: 1,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return Stack(
                                      alignment:
                                          const FractionalOffset(1.2, -0.1),
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.all(10),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            child: Image(
                                              image: FileImage(
                                                  File(imageCamera!.path)),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              setState(() {
                                                imageCamera = null;
                                              });
                                            },
                                            icon: const Icon(Icons.cancel))
                                      ],
                                    );
                                  })

                              // Align(
                              //     alignment: Alignment.center,
                              //     child: Padding(
                              //       padding: EdgeInsets.symmetric(
                              //           vertical: 8, horizontal: 16),
                              //       child: CircularProgressIndicator(
                              //         color: Colors.black,
                              //         strokeWidth: 1,
                              //       ),
                              //     )),
                              )
                      : (images?.length == 0)
                          ? const SizedBox()
                          : Expanded(
                              child: ListView.builder(
                                  physics: const PageScrollPhysics(),
                                  itemCount: images?.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return Stack(
                                      alignment:
                                          const FractionalOffset(1.2, -0.1),
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.all(10),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            child: Image(
                                              image: FileImage(
                                                  File(images![index].path)),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              images?.removeAt(index);
                                              setState(() {});
                                            },
                                            icon: const Icon(Icons.cancel))
                                      ],
                                    );
                                  }))
                  : const SizedBox(),
              const Divider(color: Colors.black45),
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 50.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.black,
                                        spreadRadius: 3,
                                        blurStyle: BlurStyle.outer,
                                        blurRadius: 25)
                                  ]),
                              child: ElevatedButton(
                                onPressed: () async {
                                  final ImagePicker picker = ImagePicker();
                                  images = await picker.pickMultiImage(
                                      imageQuality: 70);

                                  // for (var i in images!) {
                                  imageCamera = null;

                                  setState(() {
                                    isUploading = true;
                                  });
                                  setState(() {
                                    isButtonClick = true;
                                  });

                                  // }
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    shadowColor: Colors.transparent,
                                    alignment: Alignment.center,
                                    foregroundColor: Colors.transparent),
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.perm_media_outlined,
                                      color: Colors.green,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "  Photo/video   ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          height: 1,
                                          fontSize: 20,
                                          color: Colors.black,
                                          fontFamily: "VarelaRound"),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.black,
                                        spreadRadius: 3,
                                        blurStyle: BlurStyle.outer,
                                        blurRadius: 25)
                                  ]),
                              child: ElevatedButton(
                                onPressed: () async {
                                  final ImagePicker picker = ImagePicker();
                                  imageCamera = await picker.pickImage(
                                      source: ImageSource.camera,
                                      imageQuality: 70);
                                  if (imageCamera?.length() != null) {
                                    images = null;

                                    setState(() {
                                      isUploading = true;
                                    });
                                    setState(() {
                                      isButtonClick = true;
                                    });
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    shadowColor: Colors.transparent,
                                    alignment: Alignment.center,
                                    foregroundColor: Colors.transparent),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.camera_alt_outlined,
                                      color: Colors.blue.shade400,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "     Camera     ",
                                      style: styleItems(),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  styleItems() {
    return const TextStyle(
        fontWeight: FontWeight.w500,
        height: 1,
        fontSize: 20,
        color: Colors.black,
        fontFamily: "VarelaRound");
  }

  void openFile(PlatformFile file) {
    OpenFile.open(file.path!);
  }

  Future<File> saveFile(PlatformFile file) async {
    final appStrorage = await getApplicationDocumentsDirectory();
    final newFile = File('${appStrorage.path}/${file.name}');

    return File(file.path!).copy(newFile.path);
  }
}
