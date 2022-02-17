import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:panic_button/basewidgets/button/custom.dart';
import 'package:panic_button/utils/color_resources.dart';
import 'package:panic_button/utils/dimensions.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({ Key? key }) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.backgroundColor,
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
                            children: const [
                              Text("Daftar Akun",
                                style: TextStyle(
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
                              fontSize: 14.0
                            ),
                            maxLength: 16,
                            decoration: const InputDecoration(
                              hintText: "",
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              labelText: "Nomor KTP", 
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
                              fontSize: 14.0
                            ),
                            decoration: const InputDecoration(
                              hintText: "",
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              labelText: "Nama Lengkap", 
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
                              fontSize: 14.0
                            ),
                            decoration: const InputDecoration(
                              hintText: "",
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              labelText: "Alamat", 
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
                              fontSize: 14.0
                            ),
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                              hintText: "",
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              labelText: "No HP", 
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
                              fontSize: 14.0
                            ),
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              hintText: "",
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              labelText: "Alamat E-mail", 
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
                              fontSize: 14.0
                            ),
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
                              labelText: "Kata Sandi", 
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
                              fontSize: 14.0
                            ),
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
                              labelText: "Konfirmasi Kata Sandi", 
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
                  onTap: () {},
                  height: 56.0, 
                  btnTxt: "Lanjutkan",
                  btnColor: ColorResources.redPrimary,
                  btnTextColor: ColorResources.white,
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
  }
}