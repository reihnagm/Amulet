import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:amulet/localization/language_constraints.dart';

import 'package:amulet/providers/localization.dart';
import 'package:amulet/providers/auth.dart';

import 'package:amulet/views/basewidgets/dialog/animated/animated.dart';
import 'package:amulet/views/basewidgets/dialog/language/language.dart';
import 'package:amulet/views/basewidgets/button/custom.dart';

import 'package:amulet/data/models/user/user.dart';

import 'package:amulet/utils/color_resources.dart';
import 'package:amulet/utils/dimensions.dart';
import 'package:amulet/utils/constant.dart';

import 'package:amulet/views/basewidgets/snackbar/snackbar.dart';
import 'package:amulet/views/screens/auth/forget_password.dart';
import 'package:amulet/views/screens/auth/sign_up.dart';

class SignInScreen extends StatefulWidget {
  final bool isBack;
  const SignInScreen({ 
    this.isBack = false,
    Key? key 
  }) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  late AuthProvider authProvider;

  late TextEditingController phoneC;
  late TextEditingController passwordC;

  bool passwordObscure = true;

  @override 
  void initState() {
    super.initState();
    phoneC = TextEditingController();
    passwordC = TextEditingController();
  }

  @override 
  void dispose() {
    phoneC.dispose();
    passwordC.dispose();
    super.dispose();
  }

  Future<void> login() async {
    String phone = phoneC.text;
    String pass = passwordC.text;
    User user = User();
    user.phoneNumber = phone;
    user.password = pass;
    if(phone.trim().isEmpty) {
      ShowSnackbar.snackbar(context, getTranslated("EMAIL_MUST_BE_REQUIRED", context), "", ColorResources.purpleDark);
      return;
    }

    if(phone.trim().length < 6) {
      ShowSnackbar.snackbar(context, getTranslated("PHONE_NUMBER_6_REQUIRED", context), "", ColorResources.purpleDark);
      return;
    }

    if(pass.trim().isEmpty) {
      ShowSnackbar.snackbar(context,  getTranslated("PASSWORD_MUST_BE_REQUIRED", context), "", ColorResources.purpleDark);
      return;
    }   
    try {
      await authProvider.login(context, globalKey, user);
    } catch(e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildUI();
  }

  Widget buildUI() {
    return Builder(
      builder: (BuildContext context) {
        authProvider = context.read<AuthProvider>();
        return Scaffold(
          resizeToAvoidBottomInset: false,
          key: globalKey,
          backgroundColor: ColorResources.backgroundColor,
          body: SafeArea(
            child: Stack(
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
                                    Text(getTranslated("PHONE_NUMBER", context),
                                      style: const TextStyle(
                                        color: ColorResources.black,
                                        fontSize: Dimensions.fontSizeDefault
                                      ),
                                    ),
                                    const SizedBox(height: 12.0),
                                    TextField(
                                      controller: phoneC,
                                      style: const TextStyle(
                                        fontSize: Dimensions.fontSizeDefault
                                      ),
                                      cursorColor: ColorResources.black,
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
                                    Text(getTranslated("PASSWORD", context),
                                      style: const TextStyle(
                                        color: ColorResources.black,
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
                                            Icons.visibility_off,
                                            color: ColorResources.black,
                                          )
                                          : const Icon(
                                            Icons.visibility,
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
                                  btnTxt: getTranslated("LOGIN", context),
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
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(getTranslated("REGISTER", context),
                                            style: const TextStyle(
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
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(getTranslated("FORGET_PASSWORD", context),
                                            style: const TextStyle(
                                              color: ColorResources.white,
                                              fontSize: Dimensions.fontSizeDefault
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ) 
                              ),
          
                              Container(
                                margin: const EdgeInsets.only(
                                  left: Dimensions.marginSizeDefault,
                                  right: Dimensions.marginSizeDefault
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    showAnimatedDialog(context, const LanguageDialog());
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(getTranslated("CHOOSE_LANGUAGE", context),
                                        style: const TextStyle(
                                          color: ColorResources.white,
                                          fontSize:  Dimensions.fontSizeDefault,
                                        ), 
                                      ), 
                                      const SizedBox(width: 5.0),
                                      const Text("-",
                                        style: TextStyle(
                                          color: ColorResources.white,
                                          fontSize: Dimensions.fontSizeDefault
                                        ), 
                                      ),  
                                      const SizedBox(width: 5.0),
                                      Text(AppConstants.languages[context.read<LocalizationProvider>().languageIndex].languageName!,
                                        style: const TextStyle(
                                          color: ColorResources.white,
                                          fontSize:  Dimensions.fontSizeDefault,
                                        ), 
                                      ), 
                                    ]
                                  ),
                                ),
                              ),
                    
                            ],
                          ),
                        ),
                      ),
                    )
                  
                  ],
                ),
              ],
            ),
          )    
        );
      },
    );
  }
}