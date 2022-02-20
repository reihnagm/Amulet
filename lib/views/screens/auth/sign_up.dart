import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:panic_button/localization/language_constraints.dart';
import 'package:panic_button/views/basewidgets/button/custom.dart';
import 'package:panic_button/views/basewidgets/snackbar/snackbar.dart';
import 'package:panic_button/data/models/user/user.dart';
import 'package:panic_button/providers/auth.dart';
import 'package:panic_button/utils/color_resources.dart';
import 'package:panic_button/utils/dimensions.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({ Key? key }) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  late AuthProvider authProvider;

  late TextEditingController noKtpC;
  late TextEditingController fullnameC;
  late TextEditingController addressC;
  late TextEditingController noHpC;
  late TextEditingController emailAddressC;
  late TextEditingController passwordC;
  late TextEditingController passwordConfirmC;

  bool passwordObscure = true;
  bool passwordConfirmObscure = true;

  @override 
  void initState() {
    super.initState();
    noKtpC = TextEditingController();
    fullnameC = TextEditingController();
    addressC = TextEditingController();
    noHpC = TextEditingController();
    emailAddressC = TextEditingController();
    passwordC = TextEditingController();
    passwordConfirmC = TextEditingController(); 
  }

  @override 
  void dispose() {
    noKtpC.dispose();
    fullnameC.dispose();
    addressC.dispose();
    noHpC.dispose();
    emailAddressC.dispose();
    passwordC.dispose();
    passwordConfirmC.dispose();
    super.dispose();
  }

  Future<void> register() async {
    String noKtp = noKtpC.text;
    String fullname = fullnameC.text;
    String address = addressC.text;
    String phone = noHpC.text;
    String email = emailAddressC.text;
    String password = passwordC.text;
    String passwordConfirm = passwordConfirmC.text;
  
    if(fullname.trim().isEmpty) {
      ShowSnackbar.snackbar(context, getTranslated("FULLNAME_MUST_BE_REQUIRED", context), "", ColorResources.purpleDark);
      return;
    }

    if(phone.trim().isEmpty) {
      ShowSnackbar.snackbar(context, getTranslated("PHONE_MUST_BE_REQUIRED", context), "", ColorResources.purpleDark);
      return;
    }

    if(phone.trim().length < 6) {
      ShowSnackbar.snackbar(context, getTranslated("", context), "", ColorResources.purpleDark);
      return;
    }

    bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
    if(!emailValid) {
      ShowSnackbar.snackbar(context, getTranslated("EMAIL_IS_INVALID", context), "", ColorResources.purpleDark);
      return;
    }    

    if(password.trim().isEmpty) {
      ShowSnackbar.snackbar(context, getTranslated("PASSWORD_MUST_BE_REQUIRED", context), "", ColorResources.purpleDark);
      return;
    }

    if(password.trim().length < 8) {
      ShowSnackbar.snackbar(context, getTranslated("PASSWORD_8_REQUIRED", context), "", ColorResources.purpleDark);
      return;
    }

    if(passwordConfirm.trim().length < 8) {
      ShowSnackbar.snackbar(context, getTranslated("PASSWORD_8_REQUIRED", context), "", ColorResources.purpleDark);
      return;
    }

    if(password != passwordConfirm) {
      ShowSnackbar.snackbar(context, getTranslated("PASSWORD_CONFIRM_DOES_NOT_MATCH", context), "", ColorResources.purpleDark);
      return;
    }

    User user = User();
    user.identityNumber = noKtp;
    user.fullname = fullname;
    user.address = address;
    user.phoneNumber = phone;
    user.emailAddress = email;
    user.password = passwordC.text;
    try {
      await authProvider.register(context, user);
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
          backgroundColor: ColorResources.backgroundColor,
          key: globalKey,
          body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Stack(
                children: [

                  CustomScrollView(
                    physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                    slivers: [
                      SliverAppBar(
                        backgroundColor: ColorResources.transparent,
                        leading: CupertinoNavigationBarBackButton(
                          color: ColorResources.black,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        )
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.only(top: 20.0, bottom: 80.0),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate([
                            
                            Container(
                              margin: const EdgeInsets.only(
                                top: Dimensions.marginSizeDefault,
                                left: Dimensions.marginSizeDefault, 
                                right: Dimensions.marginSizeDefault,
                                bottom: Dimensions.marginSizeDefault
                              ),       
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(getTranslated("REGISTER", context),
                                    style: const TextStyle(
                                      fontSize: Dimensions.fontSizeLarge,
                                      fontWeight: FontWeight.bold,
                                      color: ColorResources.black,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            
                            Container(
                              margin: const EdgeInsets.only(
                                top:  Dimensions.marginSizeSmall,
                                left: Dimensions.marginSizeDefault, 
                                right: Dimensions.marginSizeDefault,
                                bottom: Dimensions.marginSizeDefault
                              ),
                              child: TextField(
                                controller: noKtpC,
                                style: const TextStyle(
                                  fontSize: Dimensions.fontSizeDefault
                                ),
                                maxLength: 16,
                                decoration: InputDecoration(
                                  hintText: "",
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                  labelText: getTranslated("ID_CARD_NUMBER", context), 
                                  labelStyle: const TextStyle(
                                    color: ColorResources.black,
                                    fontSize: Dimensions.fontSizeDefault
                                  ),
                                  border: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: ColorResources.black
                                    )
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: ColorResources.black
                                    )
                                  )
                                )
                              ),
                            ),

                            Container(
                              margin: const EdgeInsets.only(
                                top: Dimensions.marginSizeSmall,
                                left: Dimensions.marginSizeDefault, 
                                right: Dimensions.marginSizeDefault,
                                bottom: Dimensions.marginSizeDefault
                              ),
                              child: TextField(
                                controller: fullnameC,
                                style: const TextStyle(
                                  fontSize: Dimensions.fontSizeDefault
                                ),
                                cursorColor: ColorResources.black,
                                decoration: InputDecoration(
                                  hintText: "",
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                  labelText: "${getTranslated("FULLNAME", context)} *", 
                                  labelStyle: const TextStyle(
                                    color: ColorResources.black,
                                    fontSize: Dimensions.fontSizeDefault
                                  ),
                                  border: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: ColorResources.black
                                    )
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: ColorResources.black
                                    )
                                  )
                                )
                              ),
                            ),

                            Container(
                              margin: const EdgeInsets.only(
                                top: Dimensions.marginSizeSmall, 
                                left: Dimensions.marginSizeDefault, 
                                right: Dimensions.marginSizeDefault,
                                bottom: Dimensions.marginSizeDefault
                              ),
                              child: TextField(
                                controller: addressC,
                                maxLines: 2,
                                style: const TextStyle(
                                  fontSize: Dimensions.fontSizeDefault
                                ),
                                cursorColor: ColorResources.black,
                                decoration: InputDecoration(
                                  hintText: "",
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                  labelText: getTranslated("ADDRESS", context), 
                                  labelStyle: const TextStyle(
                                    color: ColorResources.black,
                                    fontSize: Dimensions.fontSizeDefault
                                  ),
                                  border: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: ColorResources.black
                                    )
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: ColorResources.black
                                    )
                                  )
                                )
                              ),
                            ),

                            Container(
                              margin: const EdgeInsets.only(
                                top: Dimensions.marginSizeSmall, 
                                left: Dimensions.marginSizeDefault, 
                                right: Dimensions.marginSizeDefault,
                                bottom: Dimensions.marginSizeDefault
                              ),
                              child: TextField(
                                controller: noHpC,
                                style: const TextStyle(
                                  fontSize: Dimensions.fontSizeDefault
                                ),
                                cursorColor: ColorResources.black,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  hintText: "",
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                  labelText: "${getTranslated("PHONE_NUMBER", context)} *", 
                                  labelStyle: const TextStyle(
                                    color: ColorResources.black,
                                    fontSize: Dimensions.fontSizeDefault
                                  ),
                                  border: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: ColorResources.black
                                    )
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: ColorResources.black
                                    )
                                  )
                                )
                              ),
                            ),

                            Container(
                              margin: const EdgeInsets.only(
                                top: Dimensions.marginSizeSmall,
                                left: Dimensions.marginSizeDefault,
                                right: Dimensions.marginSizeDefault,
                                bottom: Dimensions.marginSizeDefault
                              ),
                              child: TextField(
                                controller: emailAddressC,
                                style: const TextStyle(
                                  fontSize: Dimensions.fontSizeDefault
                                ),
                                cursorColor: ColorResources.black,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  hintText: "",
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                  labelText: "${getTranslated("EMAIL", context)} *", 
                                  labelStyle: const TextStyle(
                                    color: ColorResources.black,
                                    fontSize: Dimensions.fontSizeDefault
                                  ),
                                  border: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: ColorResources.black
                                    )
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: ColorResources.black
                                    )
                                  )
                                )
                              ),
                            ),

                            Container(
                              margin: const EdgeInsets.only(
                                top: Dimensions.marginSizeSmall, 
                                left: Dimensions.marginSizeDefault, 
                                right: Dimensions.marginSizeDefault,
                                bottom: Dimensions.marginSizeDefault
                              ),
                              child: TextField(
                                controller: passwordC,
                                style: const TextStyle(
                                  fontSize: Dimensions.fontSizeDefault
                                ),
                                cursorColor: ColorResources.black,
                                maxLength: 8,
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
                                  hintText: "",
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                  labelText: "${getTranslated("PASSWORD", context)} *", 
                                  labelStyle: const TextStyle(
                                    color: ColorResources.black,
                                    fontSize: Dimensions.fontSizeDefault
                                  ),
                                  border: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: ColorResources.black
                                    )
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: ColorResources.black
                                    )
                                  )
                                )
                              ),
                            ),

                            Container(
                              margin: const EdgeInsets.only(
                                top: Dimensions.marginSizeSmall,
                                left: Dimensions.marginSizeDefault, 
                                right: Dimensions.marginSizeDefault
                              ),
                              child: TextField(
                                controller: passwordConfirmC,
                                style: const TextStyle(
                                  fontSize:  Dimensions.fontSizeDefault
                                ),
                                cursorColor: ColorResources.black,
                                maxLength: 8,
                                obscureText: passwordConfirmObscure,
                                decoration: InputDecoration(
                                  suffixIcon: InkWell(
                                    onTap: () {
                                      setState(() => passwordConfirmObscure = !passwordConfirmObscure);
                                    },
                                    child: Icon(
                                      passwordConfirmObscure 
                                      ? Icons.visibility 
                                      : Icons.visibility_off
                                    ),
                                  ),
                                  hintText: "",
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                  labelText: "${getTranslated("PASSWORD_CONFIRM", context)} *", 
                                  labelStyle: const TextStyle(
                                    color: ColorResources.black,
                                    fontSize: Dimensions.fontSizeDefault
                                  ),
                                  border: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: ColorResources.black
                                    )
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: ColorResources.black
                                    )
                                  )
                                )
                              ),
                            ),

                          ])
                        )
                      )
                    ],
                  ),

                  Align(
                    alignment: Alignment.bottomCenter,
                    child: CustomButton(
                      onTap: register,
                      height: 56.0, 
                      btnTxt: getTranslated("NEXT", context),
                      btnColor: ColorResources.redPrimary,
                      btnTextColor: ColorResources.white,
                      isLoading:  context.watch<AuthProvider>().registerStatus == RegisterStatus.loading 
                      ? true  
                      : false,
                      isBorder: false,
                      isBorderRadius: false,
                      isBoxShadow: true,
                    ),
                  ),

                ],
              );
            },
          )
        );
      }, 
    );
  }
}