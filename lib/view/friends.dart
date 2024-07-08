import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bzuappgraduation/utilities/tools.dart';
import 'package:bzuappgraduation/view/show_custom_friend.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../controller/page_controller.dart';
import '../model/api.dart';
import '../model/chat_user.dart';
import '../widgets/error_widget.dart';
import '../widgets/flutter_toast.dart';

class Friends extends StatefulWidget {
  const Friends({super.key});

  @override
  State<Friends> createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {
  List<ChatUser> list = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var pageController = context.read<PageControllers>();
      await pageController.changeSearch(false);
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      String? title = message.notification!.title;
      String? body = message.notification!.body;
      String image = message.data['image'];
      AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: 3,
            channelKey: "call_channel",
            title: title,
            displayOnBackground: true,
            displayOnForeground: true,
            body: body,
            color: Colors.green,
            category: NotificationCategory.Service,
            wakeUpScreen: true,
            fullScreenIntent: true,
            backgroundColor: Colors.orange,
            autoDismissible: false,
            largeIcon: image,
            roundedLargeIcon: true,
          ),
          actionButtons: [
            NotificationActionButton(
                key: "Accept",
                label: "Add friend",
                color: Colors.blue,
                autoDismissible: true),
            NotificationActionButton(
                key: "DISMISS",
                label: "Dismiss",
                color: Colors.black54,
                autoDismissible: true),
          ]);
      // AwesomeNotifications().actionStream.listen((event) {
      //   if (event.buttonKeyPressed == "DISMISS") {
      //     // print("DISMISS");
      //   } else if (event.buttonKeyPressed == "Accept") {
      //     // print("Accept");
      //   }
      // });
    });

    super.initState();
  }

  // final dataProvider = StreamProvider.autoDispose((ref) => api.getAllUsers());

  @override
  Widget build(BuildContext context) {
    var pageController = context.watch<PageControllers>();
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(left: 10.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              (pageController.isSearching == true)
                  ? Padding(
                      padding: EdgeInsets.only(right: 10.w),
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        onChanged: (value) {
                          pageController.clear();
                          for (var user in list) {
                            if (user.name
                                    .toLowerCase()
                                    .contains(value.toLowerCase()) ||
                                user.email
                                    .toLowerCase()
                                    .contains(value.toLowerCase())) {
                              pageController.addSearch(user);
                            }
                            pageController.searchUser;
                          }
                        },
                        decoration: InputDecoration(
                            floatingLabelAlignment:
                                FloatingLabelAlignment.center,
                            hintText: "Search by name or email",
                            contentPadding: const EdgeInsets.all(10),
                            suffixIcon: InkWell(
                                onTap: () {
                                  pageController.changeSearch(false);
                                },
                                child: Icon(
                                  Icons.cancel_outlined,
                                  size: 18.w,
                                )),
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
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Friends",
                            style: TextStyle(
                                decoration: TextDecoration.none,
                                shadows: [
                                  Shadow(
                                      blurRadius: 10, color: Colors.lightBlue)
                                ],
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontFamily: "Agbalumo")),
                        ElevatedButton(
                          onPressed: () {
                            pageController.changeSearch(true);
                            pageController.searchUser = list;
                          },
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            alignment: Alignment.center,
                          ),
                          child: const Icon(Icons.person_search,
                              color: Colors.black, size: 30),
                        ),
                      ],
                    ),
              const SizedBox(
                height: 20,
              ),
              Consumer<API>(
                builder: (context, ref, child) {
                  return Expanded(
                    child: StreamBuilder(
                      stream: ref.getFilteredFriends(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Padding(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.3),
                            child: const CustomErrorWidget(),
                          );
                        }

                        // else if (snapshot.connectionState ==
                        //     ConnectionState.waiting  && pageController.isSearching==false) {
                        //   return ListView.builder(
                        //     itemCount: 5,
                        //     shrinkWrap: true,
                        //     itemBuilder: (context, index) {
                        //       return const CardShimmer();
                        //     },
                        //   );
                        // }

                        else {
                          list = snapshot.data?.toList() ?? [];
                          return list.isEmpty
                              ? Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top:
                                            MediaQuery.of(context).size.height *
                                                0.20.h),
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Text(
                                            "No have any Friends",
                                            textAlign: TextAlign.center,
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
                                  itemCount:
                                      (pageController.isSearching == true)
                                          ? (pageController.searchUser == [])
                                              ? list.length
                                              : pageController.searchUser.length
                                          : list.length,
                                  itemBuilder: (context, index) {
                                    return (pageController.isSearching == true)
                                        ? (pageController.searchUser == [])
                                            ? card(list[index], index)
                                            : card(
                                                pageController
                                                    .searchUser[index],
                                                index)
                                        : card(list[index], index);
                                  });
                        }
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget card(ChatUser user, int values) {
    API api = context.watch<API>();

    return SizedBox(
        child: InkWell(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CustomFriend(chatUser: user))),
      child: Card(
        shape: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 1),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(90),
                child: CachedNetworkImage(
                  width: 50.w,
                  height: 50.w,
                  imageUrl: user.image,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: Colors.grey[500]!,
                    highlightColor: Colors.grey[100]!,
                    child: Expanded(
                      child: Container(
                        width: double.maxFinite,
                        height: 10,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 120.w,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user.name.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13.sp,
                                  color: Colors.black,
                                  fontFamily: "Agbalumo")),
                          SizedBox(
                            height: 5.h,
                          ),
                          Text(user.email.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 11.sp,
                                  color: Colors.black,
                                  fontFamily: "CrimsonText")),
                        ],
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
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
                                  color: basicColor,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20))),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.person_add_alt,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Text(
                                    "Add friend",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13.sp,
                                        fontFamily: "Agbalumo"),
                                  )
                                ],
                              )),
                          onTap: () async {
                            if (await api
                                    .addFriend(user.email.trim().toString()) ==
                                true) {
                              await api.addFriends(user);
                              flutterToast("Was successfully access");
                            } else {
                              flutterToast("Error");
                            }
                          },
                        ),
                        // SizedBox(
                        //   width: 10.w,
                        // ),
                        // InkWell(
                        //   onTap: () async {
                        //     await api.addFriend(user.email).then((value) {
                        //       if (!value) {
                        //         Fluttertoast.showToast(
                        //             msg: 'User not join the app',
                        //             fontSize: 20,
                        //             toastLength: Toast.LENGTH_LONG);
                        //       } else {
                        //         Fluttertoast.showToast(
                        //             msg: 'Was Added successfully',
                        //             fontSize: 20,
                        //             toastLength: Toast.LENGTH_LONG);
                        //       }
                        //     });
                        //     //show notification
                        //     // await NotificationService.showNotification(title: user.name, body: user.email);
                        //
                        //     //show notification with summary
                        //     //  await NotificationService.showNotification(title: user.name, body: user.email,summry: "Small summary",
                        //     //  notificationLayout: NotificationLayout.Inbox);
                        //
                        //     // Notification progress Bar
                        //     // await NotificationService.showNotification(title: user.name, body: user.email,summry: "Small summary",
                        //     //     notificationLayout: NotificationLayout.ProgressBar);
                        //
                        //     //Notification Message Notification
                        //     // await NotificationService.showNotification(title: user.name, body: user.email,summry: "Small summary",
                        //     //     notificationLayout: NotificationLayout.Messaging);
                        //
                        //     //Notification big image
                        //     // await NotificationService.showNotification(title: user.name, body: user.email,summry: "Small summary",
                        //     //     notificationLayout: NotificationLayout.BigPicture,bigPicture: user.image);
                        //
                        //     //notification button
                        //     // await NotificationService.showNotification(
                        //     //
                        //     //     title: user.name,
                        //     //     body: user.email,
                        //     //     summry: "Small summary",
                        //     //     actionButtons: [
                        //     //       NotificationActionButton(
                        //     //           key: "Accept",
                        //     //           label: "Add friend",
                        //     //           color: Colors.blue,
                        //     //           autoDismissible: true),
                        //     //       NotificationActionButton(
                        //     //           key: "DISMISS",
                        //     //           label: "Dismiss",
                        //     //           color: Colors.black54,
                        //     //           autoDismissible: true),
                        //     //     ]);
                        //
                        //     // //show buttons with summary
                        //     // await NotificationService.showNotification(
                        //     //     summry: "Small summary",
                        //     //         notificationLayout: NotificationLayout.Messaging,
                        //     //     title: user.name,
                        //     //     body: user.email,
                        //     //     actionButtons: [
                        //     //       NotificationActionButton(
                        //     //           key: "Accept",
                        //     //           label: "Add friend",
                        //     //           color: Colors.blue,
                        //     //           autoDismissible: true),
                        //     //       NotificationActionButton(
                        //     //           key: "DISMISS",
                        //     //           label: "Dismiss",
                        //     //           color: Colors.black54,
                        //     //           autoDismissible: true),
                        //     //     ]);
                        //
                        //     //show notification Schadule waiting 5 seconds
                        //
                        //     await api.sendNotificationPage(user);
                        //     // await NotificationService.showNotification(
                        //     //     summry: "Small summary",
                        //     //     notificationLayout:
                        //     //         NotificationLayout.Default,
                        //     //     title: user.name,
                        //     //     body: user.email,
                        //     //
                        //     //
                        //     //
                        //     //     actionType: ActionType.KeepOnTop,
                        //     //     imageProfile: user.image,
                        //     //     actionButtons: [
                        //     //       NotificationActionButton(
                        //     //           key: "Accept",
                        //     //           label: "Add friend",
                        //     //           color: Colors.blue,
                        //     //           autoDismissible: true),
                        //     //       NotificationActionButton(
                        //     //           key: "DISMISS",
                        //     //           label: "Dismiss",
                        //     //           color: Colors.black54,
                        //     //           autoDismissible: true),
                        //     //     ]);
                        //   },
                        //   child: Container(
                        //       padding: const EdgeInsets.all(10),
                        //       decoration: const BoxDecoration(
                        //           boxShadow: [
                        //             BoxShadow(
                        //                 color: Colors.black,
                        //                 spreadRadius: 2,
                        //                 blurRadius: 10,
                        //                 blurStyle: BlurStyle.outer)
                        //           ],
                        //           // border: Border.all(color: Colors.black,width: 2),
                        //           gradient: LinearGradient(colors: [
                        //             Colors.white,
                        //             Colors.white54,
                        //
                        //             // Colors.white38,
                        //           ], transform: GradientRotation(90)),
                        //           borderRadius:
                        //           BorderRadius.all(Radius.circular(20))),
                        //       child: const Row(
                        //         children: [
                        //           Icon(
                        //             Icons.person_remove_outlined,
                        //             color: Colors.black,
                        //           ),
                        //           SizedBox(
                        //             width: 10,
                        //           ),
                        //           Text(
                        //             "  Remove  ",
                        //             style: TextStyle(
                        //                 color: Colors.black,
                        //                 fontFamily: "Agbalumo"),
                        //           )
                        //         ],
                        //       )),
                        // ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
