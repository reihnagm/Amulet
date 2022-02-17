import 'package:flutter/material.dart';

import 'package:panic_button/basewidgets/button/custom.dart';
import 'package:panic_button/utils/color_resources.dart';
import 'package:panic_button/utils/dimensions.dart';
import 'package:panic_button/views/screens/auth/forget_password.dart';
import 'package:panic_button/views/screens/auth/sign_up.dart';
import 'package:panic_button/views/screens/home/home.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({ Key? key }) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  late TextEditingController noHpC;
  late TextEditingController passwordC;

  bool passwordObscure = true;

  @override 
  void initState() {
    super.initState();
    noHpC = TextEditingController();
    passwordC = TextEditingController();
  }

  @override 
  void dispose() {
    noHpC.dispose();
    passwordC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorResources.backgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Stack(
              fit: StackFit.expand,
              children: [
                
                Align(
                  alignment: Alignment.topCenter,
                  child: Image.asset("assets/images/logo.png",
                    width: 250.0,
                    height: 250.0,
                  ),
                ),

                Positioned.fill(
                  child: FractionalTranslation(
                    translation: const Offset(0.0, 0.1),
                    child: Image.asset('assets/images/login-decoration.png',
                      fit: BoxFit.cover,
                    )
                  
                  ),
                ),

                CustomScrollView(
                  physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.only(top: 450.0, bottom: 175.0),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          
                          Container(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                              
                                Container(
                                  margin: const EdgeInsets.only(
                                    top: Dimensions.marginSizeSmall, 
                                    left: Dimensions.marginSizeDefault, 
                                    right: Dimensions.marginSizeDefault,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text("No Ponsel",
                                        style: TextStyle(
                                          color: ColorResources.white,
                                          fontSize: Dimensions.fontSizeDefault
                                        ),
                                      ),
                                      const SizedBox(height: 12.0),
                                      TextField(
                                        controller: noHpC,
                                        style: const TextStyle(
                                          fontSize: 14.0
                                        ),
                                        keyboardType: TextInputType.phone,
                                        decoration: const InputDecoration(
                                          fillColor: ColorResources.white,
                                          filled: true,
                                          hintText: "",
                                          labelText: "", 
                                          floatingLabelBehavior: FloatingLabelBehavior.always,
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide.none
                                          ),
                                          focusedBorder:  OutlineInputBorder(
                                            borderSide: BorderSide.none
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide.none
                                          )
                                        )
                                      ),
                                    ],
                                  ) 
                                ),
              
                                Container(
                                  margin: const EdgeInsets.only(
                                    top: Dimensions.marginSizeDefault, 
                                    left: Dimensions.marginSizeDefault, 
                                    right: Dimensions.marginSizeDefault,
                                    bottom: Dimensions.marginSizeDefault
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text("Kata Sandi",
                                        style: TextStyle(
                                          color: ColorResources.white,
                                          fontSize: Dimensions.fontSizeDefault
                                        ),
                                      ),
                                      const SizedBox(height: 12.0),
                                      TextField(
                                        controller: passwordC,
                                        style: const TextStyle(
                                          fontSize: 14.0
                                        ),
                                        keyboardType: TextInputType.phone,
                                        obscureText: passwordObscure,
                                        decoration: InputDecoration(
                                          suffixIcon: InkWell(
                                            onTap: () {
                                              setState(() => passwordObscure = !passwordObscure);
                                            },
                                            child: passwordObscure 
                                            ? const Icon(Icons.visibility)
                                            : const Icon(Icons.visibility_off),
                                          ),
                                          fillColor: ColorResources.white,
                                          filled: true,
                                          hintText: "",
                                          labelText: "", 
                                          floatingLabelBehavior: FloatingLabelBehavior.always,
                                          border: const OutlineInputBorder(
                                            borderSide: BorderSide.none
                                          ),
                                          enabledBorder: const OutlineInputBorder(
                                            borderSide: BorderSide.none
                                          ),
                                          focusedBorder: const OutlineInputBorder(
                                            borderSide: BorderSide.none
                                          ),
                                          errorBorder: const OutlineInputBorder(
                                            borderSide: BorderSide.none
                                          )
                                        )
                                      ),
                                    ],
                                  ) 
                                ),

                                Container(
                                  margin: const EdgeInsets.only(
                                    top: Dimensions.marginSizeSmall,
                                    left: Dimensions.marginSizeDefault, 
                                    right: Dimensions.marginSizeDefault, 
                                    bottom: Dimensions.marginSizeSmall
                                  ),
                                  child: CustomButton(
                                    onTap: () {
                                      Navigator.pushReplacement(context,
                                        PageRouteBuilder(pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
                                          return HomeScreen(key: UniqueKey());
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
                                    isBorderRadius: true,
                                    isBoxShadow: true,
                                    btnTextColor: ColorResources.redPrimary,
                                    btnColor: ColorResources.white,
                                  ),
                                ),

                                Container(
                                  margin: const EdgeInsets.only(
                                    top: Dimensions.marginSizeSmall,
                                    left: Dimensions.marginSizeDefault,
                                    right: Dimensions.marginSizeDefault
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Material(
                                        color: ColorResources.transparent,
                                        child: InkWell(
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
                                          child: const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text("Daftar Akun",
                                              style: TextStyle(
                                                color: ColorResources.white,
                                                fontSize: Dimensions.fontSizeDefault
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Material(
                                        color: ColorResources.transparent,
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(context,
                                              PageRouteBuilder(pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
                                                return ForgetPasswordScreen(key: UniqueKey());
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
                                          child: const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text("Lupa Kata Sandi ?",
                                              style: TextStyle(
                                                color: ColorResources.white,
                                                fontSize: Dimensions.fontSizeDefault
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ) 
                                )

                              ],
                            ),
                          )
          
                        ])
                      )
                    )
                  ],
                ),

              ],
            );
          },
        ),
      )
    );
  }
}