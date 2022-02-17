import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:panic_button/basewidgets/button/custom.dart';
import 'package:panic_button/utils/color_resources.dart';
import 'package:panic_button/utils/dimensions.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({ Key? key }) : super(key: key);

  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  late TextEditingController emailAddressC;

  bool passwordObscure = true;
  bool passwordConfirmObscure = true;

  @override 
  void initState() {
    super.initState();
    emailAddressC = TextEditingController();
  }

  @override 
  void dispose() {
    emailAddressC.dispose();
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
                              Text("Lupa Kata Sandi",
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
                  btnTxt: "Ubah",
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