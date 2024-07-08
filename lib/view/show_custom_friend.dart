import 'package:bzuappgraduation/model/chat_user.dart';
import 'package:bzuappgraduation/utilities/tools.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../model/api.dart';
import '../model/post.dart';
import '../widgets/card_post.dart';
import '../widgets/card_post_with_picture.dart';
import '../widgets/card_shimmer.dart';
import '../widgets/error_widget.dart';
import '../widgets/flutter_toast.dart';
import '../widgets/logout.dart';

class CustomFriend extends StatefulWidget {
  final ChatUser chatUser;

  const CustomFriend({super.key, required this.chatUser});

  @override
  State<CustomFriend> createState() => _CustomFriendState();
}

class _CustomFriendState extends State<CustomFriend> {
  List<Post> list = [];
  List<Post> list1 = [];

  int index1 = 1;
  int counter = 0;
  bool isUploading = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      API api = context.read<API>();

      await api.isAddedFriendBefore(widget.chatUser.email);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    API api = context.watch<API>();
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      body: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          actions: const [Logout()],
        ),
        body: SafeArea(
          child: Column(
            children: [
              IntrinsicHeight(
                child: Padding(
                  padding: EdgeInsets.all(10.w),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(90),
                        child: CachedNetworkImage(
                          width: 55.w,
                          height: 55.w,
                          imageUrl: widget.chatUser.image,
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
                      SizedBox(
                        width: 5.w,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.chatUser.name.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  height: 1,
                                  fontSize: 16.sp,
                                  color: Colors.black,
                                  fontFamily: "Agbalumo")),
                          Text(widget.chatUser.email.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.sp,
                                  color: Colors.black,
                                  fontFamily: "CrimsonText")),
                        ],
                      ),
                      const Spacer(),
                      Visibility(
                        visible: (widget.chatUser.email == api.me?.email)
                            ? false
                            : true,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          child: InkWell(
                            child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    boxShadow: const [
                                      BoxShadow(
                                          color: Colors.black,
                                          spreadRadius: 2,
                                          blurRadius: 10,
                                          blurStyle: BlurStyle.outer)
                                    ],
                                    // border: Border.all(color: Colors.black,width: 2),
                                    color: basicColor,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20))),
                                child: Row(
                                  children: [
                                    Icon(
                                      (!api.isAdded)
                                          ? Icons.add
                                          : CupertinoIcons.minus,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 7.w,
                                    ),
                                    Text(
                                      (api.isAdded)
                                          ? "  UnFollow  "
                                          : "  Follow  ",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 13.sp,
                                          fontFamily: "Agbalumo"),
                                    )
                                  ],
                                )),
                            onTap: () async {
                              if (await api.addFriend(widget.chatUser.email
                                      .trim()
                                      .toString()) ==
                                  true) {
                                await api.addFriends(widget.chatUser);
                                api.isAdded = await api
                                    .isAddedFriendBefore(widget.chatUser.email);

                                setState(() {
                                  api.isAdded = true;
                                });
                                flutterToast("Was Follow successfully");
                              } else {
                                await api.unfollowFriend(widget.chatUser);
                                api.isAdded = await api
                                    .isAddedFriendBefore(widget.chatUser.email);

                                setState(() {
                                  api.isAdded = api.isAdded;
                                });
                                flutterToast("Was Un Follow successfully");
                              }
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
              Container(
                width: double.maxFinite,
                margin: const EdgeInsets.only(left: 10, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 5.w,
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text("Posts",
                  style: TextStyle(
                      decoration: TextDecoration.none,
                      shadows: [
                        Shadow(blurRadius: 10, color: Colors.lightBlue)
                      ],
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: "Agbalumo")),
              Consumer<API>(
                builder: (context, value, child) => Expanded(
                  child: StreamBuilder(
                    stream: value.getAllCertainPostsFriend(widget.chatUser),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.3),
                          child: const CustomErrorWidget(),
                        );
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return ListView.builder(
                          itemCount: 5,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return const CardShimmer();
                          },
                        );
                      } else {
                        final d = snapshot.data?.docs;
                        list = d!.map((e) => Post.fromJson(e.data())).toList();
                        return ListView.builder(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemCount: list.length,
                            itemBuilder: (context, index) {
                              return (list[index].images.isEmpty
                                  ? CardPost(post: list[index])
                                  : CardPostWithPicture(
                                      post: list[index],
                                      image: list[index].images[0]));
                              //
                            });
                      }
                    },
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
}
