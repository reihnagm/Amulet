import 'package:flutter/material.dart';

import 'package:amulet/localization/language_constraints.dart';
import 'package:amulet/utils/dimensions.dart';
import 'package:amulet/views/screens/home/home.dart';
import 'package:amulet/utils/color_resources.dart';

class PaymentSuccessScreen extends StatefulWidget {
  final String? title;

  const PaymentSuccessScreen({Key? key, 
    this.title
  }) : super(key: key);

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return buildUI();
  }

  Widget buildUI() {
    return Scaffold(
      key: globalKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorResources.backgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return CustomScrollView(
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              slivers: [
                SliverFillRemaining(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      const Icon(
                        Icons.verified,
                        color: ColorResources.primaryOrange,
                        size: 100.0,
                      ),

                      const SizedBox(height: 18.0),

                      Container(
                        margin: const EdgeInsets.only(
                          left: Dimensions.marginSizeDefault, 
                          right: Dimensions.marginSizeDefault
                        ),
                        child: Text(getTranslated("PURCHASE_SUCCESSFUL", context),
                          style: TextStyle(
                            fontSize: Dimensions.fontSizeDefault,
                            fontWeight: FontWeight.bold,
                            color: ColorResources.white
                          ),
                        ),
                      ),

                      SizedBox(
                        width: 140.0,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            elevation: MaterialStateProperty.resolveWith<double>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.disabled)) {
                                  return 0;
                                }
                                return 0;
                              },
                            ),
                            backgroundColor: MaterialStateProperty.all(ColorResources.primaryOrange),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              )
                            )
                          ),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(key: UniqueKey())));
                          },
                          child: Text("OK",
                            style: TextStyle(
                              fontSize: Dimensions.fontSizeDefault,
                              color: ColorResources.white
                            ),
                          ),
                        ),
                      )

                    ],
                  )
                )
              ],
            );
          },
        )
      ),
    );
  }
}