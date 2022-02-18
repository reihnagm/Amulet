import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:panic_button/views/basewidgets/button/custom.dart';
import 'package:panic_button/data/models/user/user.dart';
import 'package:panic_button/providers/auth.dart';
import 'package:panic_button/utils/color_resources.dart';
import 'package:panic_button/utils/dimensions.dart';
import 'package:panic_button/views/screens/auth/forget_password.dart';
import 'package:panic_button/views/screens/auth/sign_up.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({ Key? key }) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

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

  Future<void> login() async {
    String phoneNumber = noHpC.text;
    String pass = passwordC.text;
    User user = User();
    user.phoneNumber = phoneNumber;
    user.password = pass;
    try {
      await context.read<AuthProvider>().login(context, user);
    } catch(e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: globalKey,
      backgroundColor: ColorResources.backgroundColor,
      body: Stack(
        fit: StackFit.expand,
        children: [
          
          Align(
            alignment: Alignment.topCenter,
            child: Image.asset("assets/images/logo.png",
              width: 150.0,
              height: 150.0,
            ),
          ),

          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset("assets/images/decoration.png", 
              fit: BoxFit.scaleDown,
              ),
            ),
          ),

          CustomScrollView(
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            slivers: [
              
              SliverFillRemaining(
                child: Container(
                  alignment: Alignment.bottomCenter,
                  padding: const EdgeInsets.only(
                    top: Dimensions.paddingSizeDefault, 
                    bottom: Dimensions.paddingSizeDefault
                  ),
                  child: Padding(
                    padding: MediaQuery.of(context).viewInsets / 1.5,
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
                                  fontSize: Dimensions.fontSizeDefault
                                ),
                                cursorColor: ColorResources.black,
                                // keyboardType: TextInputType.phone,
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
                                  fontSize: Dimensions.fontSizeDefault
                                ),
                                cursorColor: ColorResources.black,
                                keyboardType: TextInputType.text,
                                obscureText: passwordObscure,
                                decoration: InputDecoration(
                                  suffixIcon: InkWell(
                                    onTap: () {
                                      setState(() => passwordObscure = !passwordObscure);
                                    },
                                    child: passwordObscure 
                                    ? const Icon(
                                      Icons.visibility,
                                      color: ColorResources.black,
                                    )
                                    : const Icon(
                                      Icons.visibility_off,
                                      color: ColorResources.black,
                                    ),
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
                            onTap: login, 
                            height: 40.0,
                            btnTxt: "Masuk",
                            loadingColor: ColorResources.redPrimary,
                            isLoading: context.watch<AuthProvider>().loginStatus == LoginStatus.loading 
                            ? true 
                            : false,
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
                  ),
                ),
              )
    
            ],
          ),
        ],
      )    
    );
  }
}