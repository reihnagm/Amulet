import 'dart:async';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'package:amulet/views/basewidgets/snackbar/snackbar.dart';
import 'package:amulet/providers/location.dart';
import 'package:amulet/providers/splash.dart';
import 'package:amulet/providers/videos.dart';
import 'package:amulet/utils/dimensions.dart';
import 'package:amulet/views/screens/home/home.dart';
import 'package:amulet/utils/color_resources.dart';

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
        // if (context.read<AuthProvider>().isLoggedIn()) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => HomeScreen(key: UniqueKey())));
        // } else {
        //   Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => WelcomeScreen
        //   (key: UniqueKey())));
        // }
      });
    });
    (() async {      
      bool contactsIsDenied = await Permission.contacts.isDenied;
      bool storageIsDenied = await Permission.storage.isDenied;
      bool microphoneIsDenied = await Permission.microphone.isDenied;
      bool cameraIsDenied = await Permission.camera.isDenied;
      
      if(contactsIsDenied) {
        PermissionStatus permissionStatus = await Permission.contacts.request();
        if(permissionStatus == PermissionStatus.denied) {
          ShowSnackbar.snackbar(context, "Please granted permission Contacts", "", ColorResources.error);
          await openAppSettings();
        }
      } 
      if(microphoneIsDenied) {
        PermissionStatus permissionStatus = await Permission.microphone.request();
        if(permissionStatus == PermissionStatus.denied) { 
          await openAppSettings();
          ShowSnackbar.snackbar(context, "Please granted permission Microphone", "", ColorResources.error);
        }
      } 
      if(storageIsDenied) {
        PermissionStatus permissionStatus = await Permission.storage.request();
        if(permissionStatus == PermissionStatus.denied) {
          ShowSnackbar.snackbar(context, "Please granted permission Storage", "", ColorResources.error);
          await openAppSettings();
        }
      } 
      if(cameraIsDenied) {
        PermissionStatus permissionStatus = await Permission.camera.request();
        if(permissionStatus == PermissionStatus.denied) {
          ShowSnackbar.snackbar(context, "Please granted permission Camera", "", ColorResources.error);
          await openAppSettings();
        }
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
              ? const SizedBox() 
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