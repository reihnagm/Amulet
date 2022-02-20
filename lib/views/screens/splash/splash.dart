import 'dart:async';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'package:panic_button/providers/location.dart';
import 'package:panic_button/providers/splash.dart';
import 'package:panic_button/providers/videos.dart';
import 'package:panic_button/utils/dimensions.dart';
import 'package:panic_button/providers/auth.dart';
import 'package:panic_button/views/screens/home/home.dart';
import 'package:panic_button/utils/color_resources.dart';
import 'package:panic_button/views/screens/welcome/welcome.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  late VideoProvider videoProvider;
  late LocationProvider locationProvider;

  PackageInfo? packageInfo;

  @override
  void initState() {
    super.initState();

    locationProvider = context.read<LocationProvider>();
    videoProvider = context.read<VideoProvider>();

    Timer(const Duration(seconds: 3), () {
      Provider.of<SplashProvider>(context, listen: false).initConfig().then((_) {
        if (context.read<AuthProvider>().isLoggedIn()) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => HomeScreen(key: UniqueKey())));
        } else {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => WelcomeScreen
          (key: UniqueKey())));
        }
      });
    });
    (() async {      
      PermissionStatus permissionStorage = await Permission.storage.status;
      if(!permissionStorage.isGranted) {
        await Permission.storage.request();
      } 
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
    Future.delayed(Duration.zero, () async {
      if(mounted) {
        await locationProvider.getCurrentPosition(context);
      }
      if(mounted) {
        await videoProvider.initFcm(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorResources.backgroundColor,
      key: scaffoldKey,
      body: Stack(
        fit: StackFit.expand,
        children: [

          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: const EdgeInsets.only(top: 50.0),
              child: Image.asset("assets/images/logo.png",
                width: 180.0,
                height: 180.0,
                fit: BoxFit.scaleDown,
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset("assets/images/decoration.png"),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.only(bottom: 40.0),
              child: packageInfo == null 
              ? const Text("") 
              : Text("Version ${packageInfo?.version} + ${packageInfo?.buildNumber}",
                style: const TextStyle(
                  fontSize: Dimensions.fontSizeDefault,
                  fontWeight: FontWeight.w500,
                  color: ColorResources.white
                ),
              ) 
            ),
          ),
        ],
      )
    );
  }
}