import 'package:bzuappgraduation/model/chat_user.dart';
import 'package:bzuappgraduation/utilities/tools.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../model/api.dart';
import '../model/api_page.dart';
import '../model/post.dart';
import '../view/show_custom_friend.dart';
import '../view/show_custom_page.dart';

class CardPost extends StatefulWidget {
  final Post post;

  const CardPost({super.key, required this.post});

  @override
  State<CardPost> createState() => _CardPostState();
}

class _CardPostState extends State<CardPost> {
  late ChatUser chatUser;
  late PageUser pageUser;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      API api = context.read<API>();
      chatUser = await api.getUser(widget.post.email);
      pageUser = await api.getPage(widget.post.email, widget.post.name);

      printLog(widget.post.type);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    API api = context.watch<API>();
    return Card(
      shape: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black, width: 1),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            InkWell(
              overlayColor: const MaterialStatePropertyAll(Colors.transparent),
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
                      ClipRRect(
                        borderRadius: BorderRadius.circular(90),
                        child: CachedNetworkImage(
                          width: 40.w,
                          height: 40.w,
                          imageUrl: ((widget.post.type == PostType.user.name) &&
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
                                        (widget.post.email == api.me!.email))
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
                                        (widget.post.email == api.me!.email))
                                    ? api.me!.email
                                    : ((widget.post.type == PostType.user.name))
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
                      //     onPressed: () {}, icon: const Icon(Icons.more_horiz)),

                      // (widget.post.type == PostType.user)?:

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
                                  content: Text("Are you sure to Delete post",
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
                                              : await api
                                                  .deletePostPage(widget.post);

                                          Fluttertoast.showToast(
                                              msg:
                                                  "Was Delete post to ${api.me?.name ?? ''}",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.CENTER,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.blue,
                                              textColor: Colors.black,
                                              fontSize: 16.0);
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
                                            style:
                                                TextStyle(color: Colors.black)))
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
    );
  }
}
