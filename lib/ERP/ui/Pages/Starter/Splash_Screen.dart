import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../data/local/AppUtils.dart';
import '../../Utils/colors_constants.dart';
import '../../Utils/images_constants.dart';
import '../../Utils/utils.dart';
import '../Authentication/Login.dart';
import '../Dashbaord/Home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    startSplashScreen();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  startSplashScreen() async {
    var duration = const Duration(seconds: 4);
    return Timer(duration, () async {
      if (!mounted) return;
      // Utils.navigateTo(context,LoginScreen());
      bool isLogin = await AppUtils().getUserLoggedIn();
      if (isLogin) {
        Utils.navigateRemoveAll(context, Home());
      } else {
        Utils.navigateTo(context, LoginScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.background,
        body: Center(
        child: Container(
        // decoration: DecorationConstants.decorationGradient,
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 50.w,
            child: Image.asset(
              ImageConstants.mrlogo,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    )));
  }
}
