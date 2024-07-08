import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../controller/provider_file.dart';
import '../controller/registeration_controller.dart';
import 'LoginAndRegister/login.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool loading = true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      CustomFileImage customFileImage = context.read<CustomFileImage>();

      RegisterController register = context.read<RegisterController>();

      await customFileImage.getImageFileFromAssets("images/profile.jpg");
      register.pathImage = customFileImage.file;
    });

    Future.delayed(const Duration(seconds: 2)).then((value) async {
      await Future.delayed(const Duration(seconds: 2)).then((value) async {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const Login(),
        ));

        // if(API.auth.currentUser!=null)  {
        //   await API.getSelfInfo();
        //   Get.off(()=> const Home());
        //
        //
        // }else{
        //   Get.off(()=>const Login());
        //   await API.getSelfInfo();
        //
        //
        // }
      });
    });

    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: Padding(
          padding:
              EdgeInsets.only(left: 8.w, right: 8.w, top: 8.h, bottom: 4.h),
          child: Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("BZU Application",
                    textAlign: TextAlign.center,
                    maxLines: null,
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: "CrimsonText",
                        fontWeight: FontWeight.bold,
                        fontSize: 32.sp)),
                const Expanded(
                  child: Image(
                    image: AssetImage("images/result.png"),
                  ),
                ),
                const SpinKitFadingFour(
                  color: Colors.black,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
