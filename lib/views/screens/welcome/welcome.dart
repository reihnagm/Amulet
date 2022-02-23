import 'package:flutter/material.dart';

import 'package:package_info_plus/package_info_plus.dart';

import 'package:amulet/localization/language_constraints.dart';
import 'package:amulet/services/navigation.dart';
import 'package:amulet/utils/color_resources.dart';
import 'package:amulet/utils/dimensions.dart';
import 'package:amulet/views/basewidgets/button/custom.dart';
import 'package:amulet/views/screens/auth/sign_in.dart';
import 'package:amulet/views/screens/auth/sign_up.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({ Key? key }) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  late NavigationService navigationService;

  PackageInfo? packageInfo;

  @override
  void initState() {
    super.initState();
    navigationService = NavigationService();
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
      resizeToAvoidBottomInset: false,
      key: globalKey,
      backgroundColor: ColorResources.backgroundColor,
      body: Stack(
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
              child: Image.asset("assets/images/decoration.png", 
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 140.0),
              child: CustomButton(
                onTap: () {
                  navigationService.pushNav(context, SignUpScreen(key: UniqueKey()));
                }, 
                height: 40.0,
                btnTxt: getTranslated("REGISTER", context),
                isBorder: false,
                isBorderRadius: false,
                isBoxShadow: true,
                btnTextColor: ColorResources.redPrimary,
                btnColor: ColorResources.white,
              ) ,
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.only(left: 16.0, right: 16.0, top: 30.0, bottom: 90.0),
              child: CustomButton(
                onTap: () {
                  navigationService.pushNav(context, SignInScreen(key: UniqueKey()));
                }, 
                height: 40.0,
                btnTxt: getTranslated("LOGIN", context),
                isBorder: false,
                isBorderRadius: false,
                isBoxShadow: true,
                btnTextColor: ColorResources.redPrimary,
                btnColor: ColorResources.white,
              ) ,
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.only(bottom: 40.0),
              child: packageInfo == null 
              ? const Text("") 
              : Text("${getTranslated("VERSION", context)} ${packageInfo!.version} + ${packageInfo!.buildNumber}",
                style: const TextStyle(
                  fontSize: Dimensions.fontSizeDefault,
                  fontWeight: FontWeight.w500,
                  color: ColorResources.white
                ),
              ) 
            ),
          ),
         
        ],
      ),
    );
  }
}