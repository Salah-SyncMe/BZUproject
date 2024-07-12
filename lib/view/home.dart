import 'package:bzuappgraduation/view/add_page.dart';
import 'package:bzuappgraduation/view/profile/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controller/home_controller.dart';
import '../model/api.dart';
import '../widgets/add_pages.dart';
import '../widgets/button_logout.dart';
import 'all_pages_show.dart';
import 'Home/home_show.dart';
import 'friends.dart';
import 'LoginAndRegister/login.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int index = 1;

  final _pageController = PageController(initialPage: 1);

  @override
  void initState() {
    super.initState();
    Provider.of<HomeController>(context, listen: false).changePage = changePage;
  }

  @override
  Widget build(BuildContext context) {
    API api = context.watch<API>();

    List<Widget> pages = (api.isHavePage == true)
        ? const [
            Profile(),
            HomeShow(),
            AllPages(),
            CurrentPage(),
            Friends(),
            CustomAddPages()
          ]
        : const [Profile(), HomeShow(), AllPages(), Friends(), CustomAddPages()];

    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) async {
        return await showDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              actionScrollController: ScrollController(
                  keepScrollOffset: true, initialScrollOffset: 10),
              title: const Text("Log out",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
              content: const Text("Are you sure to log out",
                  style: TextStyle(
                      fontFamily: 'CrimsonText',
                      fontSize: 15,
                      color: Colors.black87)),
              actions: [
                TextButton(
                    onPressed: () async {
                      // await API.updateActiveStatus(false);
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const Login(),
                      ));
                    },
                    child: const Text(
                      "Yes",
                      style: TextStyle(color: Colors.black),
                    )),
                TextButton(
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                    child:
                        const Text("No", style: TextStyle(color: Colors.black)))
              ],
            );
          },
        );
      },
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          bottomNavigationBar: Container(
            margin:
                const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 5),
            decoration: const BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 25,
                    blurStyle: BlurStyle.outer,
                  )
                ]),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BottomNavigationBar(
                currentIndex: index,
                backgroundColor: Colors.white70,
                selectedItemColor: Colors.blueAccent,
                unselectedItemColor: Colors.black,
                showUnselectedLabels: false,
                onTap: (value) {
                  _pageController.jumpToPage(value);
                },
                items: (api.isHavePage == true)
                    ? const [
                        BottomNavigationBarItem(
                            icon: Icon(Icons.person), label: "Profile"),

                        BottomNavigationBarItem(
                            icon: Icon(Icons.home), label: "Home"),
                        BottomNavigationBarItem(
                            icon: Icon(Icons.pages), label: "Pages"),
                        BottomNavigationBarItem(
                            icon: Icon(Icons.contact_page_rounded),
                            label: "Page"),

                        BottomNavigationBarItem(
                            icon: Icon(Icons.person_add), label: "Friends"),
                        BottomNavigationBarItem(
                            icon: Icon(Icons.pageview), label: "Add Pages"),
                        // BottomNavigationBarItem(
                        //     icon: Icon(Icons.menu), label: "Menu"),
                      ]
                    : const [
                        BottomNavigationBarItem(
                            icon: Icon(Icons.person_outline), label: "Profile"),

                        BottomNavigationBarItem(
                            icon: Icon(Icons.home), label: "Home"),

                        BottomNavigationBarItem(
                            icon: Icon(Icons.pages), label: "Pages"),
                        BottomNavigationBarItem(
                            icon: Icon(Icons.person_add_alt_outlined),
                            label: "Friends"),
                        BottomNavigationBarItem(
                            icon: Icon(Icons.pageview), label: "Add Pages"),
                        // BottomNavigationBarItem(
                        //     icon: Icon(Icons.menu), label: "Menu"),
                      ],
              ),
            ),
          ),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: (api.isHavePage == true)
                ? (index != 0 && index != 3 && index != 2)
                    ? Text(
                        api.me!.name.toString(),
                        style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            height: 1,
                            fontSize: 25,
                            color: Colors.black,
                            fontFamily: "Agbalumo"),
                      )
                    : (index == 0)
                        ? text("My Profile")
                        : (index == 2)
                            ? text("Pages")
                            : text("My Pages")
                : (index != 0)
                    ? Text(
                        api.me!.name.toString(),
                        style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            height: 1,
                            fontSize: 25,
                            color: Colors.black,
                            fontFamily: "Agbalumo"),
                      )
                    : text("My Profile"),
            actions: const [Logout()],
          ),
          body: PageView(
            controller: _pageController,
            onPageChanged: (x) {
              setState(() {
                index = x;
              });
            },
            physics: const ScrollPhysics(),
            children: pages,
          ),
        ),
      ),
    );
  }

  void changePage(int index, Function(BuildContext context) onFinish) {
    _pageController.jumpToPage(index);
    onFinish(context);
  }

  Widget text(String title) {
    return Text(title,
        style: TextStyle(
            decoration: TextDecoration.none,
            shadows: const [Shadow(blurRadius: 10, color: Colors.lightBlue)],
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: "Agbalumo"));
  }
}
