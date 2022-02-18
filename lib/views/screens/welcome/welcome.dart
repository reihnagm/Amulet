import 'package:flutter/material.dart';

import 'package:package_info_plus/package_info_plus.dart';

import 'package:panic_button/utils/color_resources.dart';
import 'package:panic_button/views/basewidgets/button/custom.dart';
import 'package:panic_button/views/screens/auth/sign_in.dart';
import 'package:panic_button/views/screens/auth/sign_up.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({ Key? key }) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  PackageInfo? packageInfo;

  @override
  void initState() {
    super.initState();
  
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
      key: scaffoldKey,
      backgroundColor: ColorResources.backgroundColor,
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

          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
                child: Image.asset("assets/images/decoration.png", 
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 140.0),
              child: CustomButton(
                onTap: () {
                  Navigator.push(context,
                    PageRouteBuilder(pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
                      return SignUpScreen(key: UniqueKey());
                    },
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      const begin = Offset(1.0, 0.0);
                      const end = Offset.zero;
                      const curve = Curves.ease;
                      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                      return SlideTransition(
                        position: animation.drive(tween),
                        child: child,
                      );
                    })
                  );
                }, 
                height: 40.0,
                btnTxt: "Daftar",
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
                  Navigator.push(context,
                    PageRouteBuilder(pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
                      return SignInScreen(key: UniqueKey());
                    },
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      const begin = Offset(1.0, 0.0);
                      const end = Offset.zero;
                      const curve = Curves.ease;
                      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                      return SlideTransition(
                        position: animation.drive(tween),
                        child: child,
                      );
                    })
                  );
                }, 
                height: 40.0,
                btnTxt: "Masuk",
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
      ),
    );
  }
}