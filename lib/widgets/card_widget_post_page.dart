import 'package:bzuappgraduation/utilities/tools.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../model/api.dart';
import '../model/post.dart';
import '../view/comment_screen.dart'; // Ensure this import is correct

class CardPageWidget extends StatefulWidget {
  final Post post;

  const CardPageWidget({super.key, required this.post});

  @override
  State<CardPageWidget> createState() => _CardPageWidgetState();
}

class _CardPageWidgetState extends State<CardPageWidget> {

  @override
  Widget build(BuildContext context) {
    API api = context.watch<API>();

    return widget.post.images.isEmpty
        ? Card(
      shape: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black, width: 1),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Container(
        padding: EdgeInsets.all(5.w),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(90),
                      child: CachedNetworkImage(
                        width: 40.w,
                        height: 40.w,
                        imageUrl: widget.post.imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: Colors.grey[500]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: double.maxFinite,
                            height: 10,
                            color: Colors.white,
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.post.name.toString(),
                            maxLines: null,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16.sp,
                                color: Colors.black,
                                fontFamily: "Agbalumo")),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(api.me?.name.toString() ?? '',
                            maxLines: null,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14.sp,
                                color: Colors.black,
                                fontFamily: "CrimsonText")),
                      ],
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    widget.post.email == api.me?.email
                        ? IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return CupertinoAlertDialog(
                                actionScrollController:
                                ScrollController(
                                    keepScrollOffset: true,
                                    initialScrollOffset: 10),
                                title: Text("Delete Post",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.sp)),
                                content: Text(
                                    "Are you sure to Delete post",
                                    style: TextStyle(
                                        fontFamily: 'CrimsonText',
                                        fontSize: 14.sp,
                                        color: Colors.black87)),
                                actions: [
                                  TextButton(
                                      onPressed: () async {
                                        Navigator.pop(context);

                                        await api.deletePostPage(
                                            widget.post);

                                        Fluttertoast.showToast(
                                            msg:
                                            "Was Delete post to ${api.me?.name}",
                                            toastLength:
                                            Toast.LENGTH_SHORT,
                                            gravity:
                                            ToastGravity.CENTER,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor:
                                            Colors.blue,
                                            textColor: Colors.black,
                                            fontSize: 18.sp);
                                      },
                                      child: const Text("Yes",
                                          style: TextStyle(
                                              color: Colors.black))),
                                  TextButton(
                                      onPressed: () async {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("No",
                                          style: TextStyle(
                                              color: Colors.black)))
                                ],
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.cancel))
                        : const SizedBox(),
                  ],
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 5.h, bottom: 5.h),
              width: double.maxFinite,
              padding: const EdgeInsets.all(0),
              child: Text(widget.post.text.toString().trim(),
                  style: TextStyle(
                      decoration: TextDecoration.none,
                      shadows: const [
                        Shadow(blurRadius: 10, color: Colors.greenAccent)
                      ],
                      fontSize: 18.sp,
                      color: Colors.black,
                      fontFamily: "CrimsonText")),
            ),
            widget.post.images.isEmpty == true
                ? const SizedBox()
                : Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25.r),
                child: CachedNetworkImage(
                  imageUrl: widget.post.images[0],
                  fit: BoxFit.cover,
                  placeholder: (context, url) {
                    return Shimmer.fromColors(
                      baseColor: Colors.grey[500]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: double.maxFinite,
                        height: 10,
                        color: Colors.white,
                      ),
                    );
                  },
                  errorWidget: (context, url, error) =>
                  const Icon(Icons.error),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            api.state == false
                ? const SizedBox()
                : Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Text(widget.post.name.toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15.sp,
                          color: Colors.black,
                          fontFamily: "CrimsonText")),
                )
              ],
            ),
            const Divider(
              color: Colors.black,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(),
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                    );

                    api.state = !api.state;
                  },
                  onFocusChange: (value) {
                    ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(),
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                    );
                  },
                  icon: api.state == false
                      ? const Icon(
                    Icons.favorite_border,
                    color: Colors.black,
                  )
                      : const Icon(
                    Icons.favorite,
                    color: Colors.red,
                  ),
                  label: api.state == true
                      ? const Text(
                    "like",
                    style: TextStyle(color: Colors.black),
                  )
                      : const Text(
                    "liked",
                    style: TextStyle(color: Colors.black),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(),
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  ),
                  onLongPress: () {
                    ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(),
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                    );
                  },
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CommentScreen(postId: widget.post.id),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.mode_comment_outlined,
                    color: Colors.black,
                  ),
                  label: const Text(
                    "comment",
                    style: TextStyle(color: Colors.black),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(),
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.share,
                    color: Colors.black,
                  ),
                  label: const Text(
                    "share",
                    style: TextStyle(color: Colors.black),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(),
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    )
        : SizedBox(
      height: MediaQuery.of(context).size.height * 0.65,
      child: Card(
        shape: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 1),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(90),
                        child: CachedNetworkImage(
                          width: MediaQuery.of(context).size.width < 600
                              ? MediaQuery.of(context).size.height * 0.055
                              : MediaQuery.of(context).size.height *
                              0.085,
                          height: MediaQuery.of(context).size.width < 600
                              ? MediaQuery.of(context).size.height * 0.055
                              : MediaQuery.of(context).size.height *
                              0.085,
                          imageUrl: widget.post.imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              Shimmer.fromColors(
                                baseColor: Colors.grey[500]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  width: double.maxFinite,
                                  height: 10,
                                  color: Colors.white,
                                ),
                              ),
                          errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width:
                            MediaQuery.of(context).size.width * 0.5,
                            child: Text(widget.post.name.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18.sp,
                                    color: Colors.black,
                                    fontFamily: "Agbalumo")),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            width:
                            MediaQuery.of(context).size.width * 0.5,
                            child: Text(api.me?.name.toString() ?? '',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15.sp,
                                    color: Colors.black,
                                    fontFamily: "CrimsonText")),
                          ),
                        ],
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.more_horiz)),
                      widget.post.email == api.me?.email
                          ? IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return CupertinoAlertDialog(
                                  actionScrollController:
                                  ScrollController(
                                      keepScrollOffset: true,
                                      initialScrollOffset: 10),
                                  title: const Text("Delete Post",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22)),
                                  content: const Text(
                                      "Are you sure to Delete post",
                                      style: TextStyle(
                                          fontFamily: 'CrimsonText',
                                          fontSize: 15,
                                          color: Colors.black87)),
                                  actions: [
                                    TextButton(
                                        onPressed: () async {
                                          Navigator.pop(context);
                                          await api.deletePostPage(
                                              widget.post);

                                          Fluttertoast.showToast(
                                              msg:
                                              "Was Delete post to ${api.me?.name}",
                                              toastLength:
                                              Toast.LENGTH_SHORT,
                                              gravity:
                                              ToastGravity.CENTER,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor:
                                              Colors.blue,
                                              textColor: Colors.black,
                                              fontSize: 16.0);
                                        },
                                        child: const Text("Yes")),
                                    TextButton(
                                        onPressed: () async {
                                          Navigator.pop(context);
                                        },
                                        child: const Text("No"))
                                  ],
                                );
                              },
                            );
                          },
                          icon: const Icon(Icons.cancel))
                          : const SizedBox(),
                    ],
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(top: 5, bottom: 5),
                width: double.maxFinite,
                padding: const EdgeInsets.all(0),
                child: Text(widget.post.text.toString().trim(),
                    style: TextStyle(
                        decoration: TextDecoration.none,
                        shadows: const [
                          Shadow(
                              blurRadius: 10, color: Colors.greenAccent)
                        ],
                        fontSize: 18.sp,
                        color: Colors.black,
                        fontFamily: "CrimsonText")),
              ),
              widget.post.images.isEmpty == true
                  ? const SizedBox()
                  : Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: CachedNetworkImage(
                    imageUrl: widget.post.images[0],
                    fit: BoxFit.cover,
                    placeholder: (context, url) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey[500]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: double.maxFinite,
                          height: 10,
                          color: Colors.white,
                        ),
                      );
                    },
                    errorWidget: (context, url, error) =>
                    const Icon(Icons.error),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              api.state == true
                  ? const SizedBox()
                  : Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Text(widget.post.name.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15.sp,
                            color: Colors.black,
                            fontFamily: "CrimsonText")),
                  )
                ],
              ),
              const Divider(
                color: Colors.black,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(),
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                      );

                      api.state = !api.state;
                    },
                    onFocusChange: (value) {
                      ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(),
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                      );
                    },
                    icon: api.state == true
                        ? const Icon(
                      Icons.favorite_border,
                      color: Colors.black,
                    )
                        : const Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                    label: api.state == true
                        ? const Text(
                      "like",
                      style: TextStyle(color: Colors.black),
                    )
                        : const Text(
                      "liked",
                      style: TextStyle(color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(),
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                    ),
                    onLongPress: () {
                      ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(),
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                      );
                    },
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      printLog('Navigating to CommentScreen');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CommentScreen(postId: '${widget.post.createAt}_${widget.post.email.substring(0, widget.post.email.indexOf('@'))}'
                              .toString()
                              .toLowerCase()
                              .trim()),
                        ),
                      );
                    },
                    icon: const Icon(Icons.mode_comment_outlined,color: Colors.black,),
                    label: const Text("comment",style: TextStyle(color: Colors.black),),
                    style: ElevatedButton.styleFrom(
                      backgroundColor : Colors.transparent,
                      elevation: 0,
                    ),
                  ),

                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.share,
                      color: Colors.black,
                    ),
                    label: const Text(
                      "share",
                      style: TextStyle(color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(),
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
