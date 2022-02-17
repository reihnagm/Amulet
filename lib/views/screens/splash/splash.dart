import 'dart:async';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import 'package:panic_button/utils/color_resources.dart';
import 'package:panic_button/views/screens/welcome/welcome.dart';
import 'package:panic_button/basewidgets/button/custom.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

   void showSnack(String text) {
    if (scaffoldKey.currentContext != null) {
      ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(SnackBar(content: Text(text)));
    }
  }

  PackageInfo? packageInfo;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      // if (context.read<AuthProvider>().isLoggedIn()) {
      //   Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => const DashBoardScreen()));
      // } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => WelcomeScreen
      (key: UniqueKey())));
      // }
    });
      
    (() async {
      PackageInfo p = await PackageInfo.fromPlatform();
      setState(() {      
        packageInfo = PackageInfo(
          appName: p.appName,
          buildNumber: p.buildNumber,
          packageName: p.packageName,
          version: p.version
        );
      });
    })();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.backgroundColor,
      key: scaffoldKey,
      body: Container(
      width:  MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('assets/images/step-first.png')
        )
      ),
      child: Stack(
        children: [
        
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.only(bottom: 80.0),
              child: packageInfo == null 
              ? const Text("") : Text("Version ${packageInfo!.version} + ${packageInfo!.buildNumber}",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Colors.white
                ),
              ) 
            ),
          ),
         
        ],
      ))
    );
  }
}