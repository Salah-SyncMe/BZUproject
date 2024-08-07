import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../model/api.dart';
import '../model/post.dart';
import '../widgets/card_post.dart';
import '../widgets/card_post_with_picture.dart';
import '../widgets/card_shimmer.dart';
import '../widgets/error_widget.dart';

class AllPages extends StatefulWidget {
  const AllPages({super.key});

  @override
  State<AllPages> createState() => _AllPagesState();
}

class _AllPagesState extends State<AllPages> {
  List<Post> list = [];
  List<Post> list1 = [];

  int index1 = 1;
  int counter = 0;
  bool isUploading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 5.h,
            ),
            const SizedBox(
              height: 10,
            ),
            const Text("Posts",
                style: TextStyle(
                    decoration: TextDecoration.none,
                    shadows: [Shadow(blurRadius: 10, color: Colors.lightBlue)],
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: "Agbalumo")),
            Consumer<API>(
              builder: (context, value, child) => Expanded(
                child: StreamBuilder(
                  stream: value.getPagesAllMeAndPostsPages(),
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
                      final d = snapshot.data;
                      list = d!.map((e) => Post.fromJson(e)).toList();
                      list.sort(
                        (a, b) => b.createAt.compareTo(a.createAt),
                      );
                      return list.isEmpty
                          ? Center(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.2055.h),
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
