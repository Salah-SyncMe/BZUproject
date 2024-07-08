import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../model/api.dart';
import '../model/api_page.dart';
import '../model/chat_user.dart';
import '../model/post.dart';
import '../utilities/tools.dart';
import '../view/show_custom_friend.dart';
import '../view/show_custom_page.dart';

class CardPostWithPicture extends StatefulWidget {
  final Post post;
  final String image;
  const CardPostWithPicture(
      {super.key, required this.post, required this.image});

  @override
  State<CardPostWithPicture> createState() => _CardPostWithPictureState();
}

class _CardPostWithPictureState extends State<CardPostWithPicture> {
  late ChatUser chatUser;
  late PageUser pageUser;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      API api = context.read<API>();
      chatUser = await api.getUser(widget.post.email);
      pageUser = await api.getPage(widget.post.email, widget.post.name);
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    API api = context.watch<API>();

    return SizedBox(
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
                InkWell(
                  onTap: () {
                    ((widget.post.type == PostType.user.name))
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    CustomFriend(chatUser: chatUser)))
                        : Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    CustomPage(pageUser: pageUser)));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          // CircleAvatar(
                          //   backgroundImage: AssetImage("images/Curves.png"),
                          //   radius: 20,
                          // ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(95.r),
                            child: CachedNetworkImage(
                              width: 50.w,
                              height: 50.w,
                              imageUrl:
                                  ((widget.post.type == PostType.user.name) &&
                                          (widget.post.email == api.me!.email))
                                      ? api.me!.image
                                      : widget.post.imageUrl,
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
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Text(
                                    ((widget.post.type == PostType.user.name) &&
                                            (widget.post.email ==
                                                api.me!.email))
                                        ? api.me!.name
                                        : widget.post.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20,
                                        color: Colors.black,
                                        fontFamily: "Agbalumo")),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Text(
                                    ((widget.post.type == PostType.user.name) &&
                                            (widget.post.email ==
                                                api.me!.email))
                                        ? api.me!.email
                                        : ((widget.post.type ==
                                                PostType.user.name))
                                            ? widget.post.email
                                            : widget.post.adminName,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15,
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
                          // IconButton(
                          //     onPressed: () {},
                          //     icon: const Icon(Icons.more_horiz)),
                          IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return CupertinoAlertDialog(
                                      actionScrollController: ScrollController(
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

                                              ((widget.post.type ==
                                                          PostType.user.name) &&
                                                      (widget.post.email ==
                                                          api.me!.email))
                                                  ? await api
                                                      .deletePost(widget.post)
                                                  : await api.deletePostPage(
                                                      widget.post);

                                              Fluttertoast.showToast(
                                                  msg:
                                                      "Was Delete post to ${api.me?.name ?? ''}",
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.CENTER,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor: Colors.blue,
                                                  textColor: Colors.black,
                                                  fontSize: 16.0);
                                            },
                                            child: const Text(
                                              "Yes",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            )),
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
                              icon: widget.post.email == api.me?.email
                                  ? const Icon(Icons.cancel)
                                  : const SizedBox()),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5, bottom: 5),
                  width: double.maxFinite,
                  padding: const EdgeInsets.all(0),
                  child: Text(widget.post.text.toString().trim(),
                      style: const TextStyle(
                          decoration: TextDecoration.none,
                          shadows: [
                            Shadow(blurRadius: 10, color: Colors.greenAccent)
                          ],
                          fontSize: 20,
                          color: Colors.black,
                          fontFamily: "CrimsonText")),
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.r),
                    child: CachedNetworkImage(
                      imageUrl: widget.image,
                      // widget.post.images[0].toString(),

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
                        // CircularProgressIndicator(
                        //    color: Colors.black,
                        // strokeWidth: 0,
                        // value: 30,
                        //
                        //  );
                      },
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                ),
                const Divider(
                  color: Colors.black,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.favorite_border,
                        color: Colors.black,
                      ),
                      label: const Text(
                        "like",
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
        ));
  }
}
