import 'package:bzuappgraduation/utilities/tools.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../animation/animation.dart';
import '../model/api.dart';
import '../model/post.dart';
import '../widgets/button_logout.dart';
import '../widgets/card_shimmer.dart';
import '../widgets/card_widget_post_page.dart';
import '../widgets/error_widget.dart';
import 'create_post_page.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  List<Post> list = [];
  List<Post> list1 = [];

  int index1 = 1;
  int counter = 0;
  bool isUploading = false;

  @override
  Widget build(BuildContext context) {
    API api = context.watch<API>();

    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      body: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        CupertinoIcons.arrow_left,
                        color: Colors.black,
                      )),
                  const Text("My Page",
                      style: TextStyle(
                          decoration: TextDecoration.none,
                          shadows: [
                            Shadow(blurRadius: 10, color: Colors.lightBlue)
                          ],
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontFamily: "Agbalumo")),
                  const Logout()
                ],
              ),
              SizedBox(
                height: 5.h,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(90),
                child: CachedNetworkImage(
                  width: 55.w,
                  height: 55.w,
                  imageUrl: "${api.pageMe?.image}",
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
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Text(api.pageMe!.name.toString(),
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      height: 1,
                      fontSize: 28.sp,
                      color: Colors.black,
                      fontFamily: "Agbalumo")),
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
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.none,
                        onTap: () {
                          Navigator.push(context,
                              Animations(page: const CreatePostPage()));
                        },
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                            floatingLabelAlignment:
                                FloatingLabelAlignment.center,
                            hintText: "What's on your mind?",
                            contentPadding: const EdgeInsets.all(10),
                            alignLabelWithHint: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                    color: Colors.black, width: 2)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide:
                                    BorderSide(color: basicColor, width: 2)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                    color: Colors.black, width: 2))),
                      ),
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
              Text("Posts",
                  style: TextStyle(
                      decoration: TextDecoration.none,
                      shadows: const [
                        Shadow(blurRadius: 10, color: Colors.lightBlue)
                      ],
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: "Agbalumo")),
              Consumer<API>(
                builder: (context, value, child) => Expanded(
                  child: StreamBuilder(
                    stream: value.getAllMyPostsPage(),
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
                        return list.isEmpty
                            ? Center(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.height *
                                          0.20.h),
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Text(
                                          "No have any Post",
                                          style: TextStyle(
                                              fontSize: 30.sp,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              fontFamily: "Agbalumo"),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                itemCount: list.length,
                                itemBuilder: (context, index) {
                                  return CardPageWidget(post: list[index]);
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
