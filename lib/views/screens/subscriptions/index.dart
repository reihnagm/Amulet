import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:amulet/data/models/user/user.dart';
import 'package:amulet/localization/language_constraints.dart';
import 'package:amulet/providers/auth.dart';
import 'package:amulet/utils/box_shadow.dart';
import 'package:amulet/utils/color_resources.dart';
import 'package:amulet/utils/dimensions.dart';

class SubscriptionsScreen extends StatefulWidget {
  const SubscriptionsScreen({ Key? key }) : super(key: key);

  @override
  State<SubscriptionsScreen> createState() => _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends State<SubscriptionsScreen> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  User user = User();

  late AuthProvider authProvider;

  Future<void> buyNow({required String duration}) async {
    try {
      user.role = duration;
      await context.read<AuthProvider>().verify(context, globalKey, user);
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
          key: globalKey,
          resizeToAvoidBottomInset: false,
          backgroundColor: ColorResources.backgroundColor,
          body: SafeArea(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return CustomScrollView(
                  physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                  slivers: [

                    SliverAppBar(
                      elevation: 0.0,
                      pinned: true,
                      backgroundColor: ColorResources.transparent,

                      title: Text(getTranslated("SELECT_SUBSCRIPTION", context),
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: Dimensions.fontSizeDefault,
                          color: ColorResources.black
                        ),
                      ),
                      leading: CupertinoNavigationBarBackButton(
                        color: ColorResources.black,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    
                    SliverPadding(
                      padding: EdgeInsets.only(
                        top: 20.0, 
                        bottom: 20.0
                      ),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          
                          Stack(
                            clipBehavior: Clip.none,
                            children: [

                              Container(
                                width: double.infinity,
                                height: 320.0,
                                margin: EdgeInsets.only(
                                  top: Dimensions.marginSizeDefault,
                                  left: 90, 
                                  right: 90
                                ),
                                padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
                                decoration: BoxDecoration(
                                  boxShadow: boxShadow,
                                  color: ColorResources.white,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(80.0),
                                    bottomLeft: Radius.circular(80.0)
                                  )
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(getTranslated("ONE_DAY", context),
                                          style: TextStyle(
                                            fontSize: Dimensions.fontSizeExtraLarge,
                                            fontWeight: FontWeight.bold,
                                            color: ColorResources.redPrimary
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ) 
                              ),

                              Positioned(
                                top: 65.0,
                                left: 60.0,
                                bottom: 220.0,
                                child: Container(
                                  width: 160.0,
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                                  decoration: BoxDecoration(
                                    color: ColorResources.redPrimary,
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(60.0),
                                      bottomLeft: Radius.circular(60.0)
                                    )
                                  ),
                                  child: Text("Rp 30.000",
                                    style: TextStyle(
                                      fontSize: Dimensions.fontSizeExtraLarge,
                                      fontWeight: FontWeight.w500,
                                      color: ColorResources.white
                                    ),
                                  ),
                                )
                              ),

                              Positioned.fill(
                                top: 50.0,
                                left: 0.0,
                                right: 0.0,
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      
                                      Text(getTranslated("SOS_EMERGENCY", context),
                                        style: TextStyle(
                                          fontSize: Dimensions.fontSizeDefault,
                                          fontWeight: FontWeight.w400,
                                          color: ColorResources.redPrimary
                                        ),
                                      ),

                                      const SizedBox(height: 12.0),

                                      Container(
                                        width: 180.0,
                                        child: Text(getTranslated("SHARE_TO_EMERGENCY_CONTACT", context),
                                          style: TextStyle(
                                            height: 1.5,
                                            fontSize: Dimensions.fontSizeDefault,
                                            fontWeight: FontWeight.w400,
                                            color: ColorResources.redPrimary
                                          ),
                                        ),
                                      ),

                                    ],
                                  )
                                
                                ),
                              ),

                              Positioned(
                                right: 100.0,
                                bottom: 10.0,
                                child: Material(
                                  color: ColorResources.transparent,
                                  child: InkWell(
                                    onTap: () => buyNow(duration: '1d'),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(getTranslated("BUY_NOW", context),
                                        style: TextStyle(
                                          fontSize: Dimensions.fontSizeLarge,
                                          fontWeight: FontWeight.w500,
                                          color: ColorResources.redPrimary
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ),

                            ],
                          ),

                          const SizedBox(height: 30.0),

                          Stack(
                            clipBehavior: Clip.none,
                            children: [

                              Container(
                                width: double.infinity,
                                height: 320.0,
                                margin: EdgeInsets.only(
                                  top: Dimensions.marginSizeDefault,
                                  left: 90.0, 
                                  right: 90.0
                                ),
                                padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
                                decoration: BoxDecoration(
                                  boxShadow: boxShadow,
                                  color: ColorResources.white,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(80.0),
                                    bottomLeft: Radius.circular(80.0)
                                  )
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(getTranslated("ONE_MONTH", context),
                                          style: TextStyle(
                                            fontSize: Dimensions.fontSizeExtraLarge,
                                            fontWeight: FontWeight.bold,
                                            color: ColorResources.redPrimary
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ) 
                              ),

                              Positioned(
                                top: 65.0,
                                left: 60.0,
                                bottom: 220.0,
                                child: Container(
                                  width: 160.0,
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                                  decoration: BoxDecoration(
                                    color: ColorResources.redPrimary,
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(60.0),
                                      bottomLeft: Radius.circular(60.0)
                                    )
                                  ),
                                  child: Text("Rp 300.000",
                                    style: TextStyle(
                                      fontSize: Dimensions.fontSizeExtraLarge,
                                      fontWeight: FontWeight.w500,
                                      color: ColorResources.white
                                    ),
                                  ),
                                )
                              ),

                              Positioned.fill(
                                top: 50.0,
                                left: 0.0,
                                right: 0.0,
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      
                                      Text(getTranslated("SOS_EMERGENCY", context),
                                        style: TextStyle(
                                          fontSize: Dimensions.fontSizeDefault,
                                          fontWeight: FontWeight.w400,
                                          color: ColorResources.redPrimary
                                        ),
                                      ),

                                      const SizedBox(height: 12.0),

                                      Container(
                                        width: 180.0,
                                        child: Text(getTranslated("SHARE_TO_EMERGENCY_CONTACT", context),
                                          style: TextStyle(
                                            height: 1.5,
                                            fontSize: Dimensions.fontSizeDefault,
                                            fontWeight: FontWeight.w400,
                                            color: ColorResources.redPrimary
                                          ),
                                        ),
                                      ),

                                    ],
                                  )
                                
                                ),
                              ),

                              Positioned(
                                right: 100.0,
                                bottom: 10.0,
                                child: Material(
                                  color: ColorResources.transparent,
                                  child: InkWell(
                                    onTap: () => buyNow(duration: '30d'),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(getTranslated("BUY_NOW", context),
                                        style: TextStyle(
                                          fontSize: Dimensions.fontSizeLarge,
                                          fontWeight: FontWeight.w500,
                                          color: ColorResources.redPrimary
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ),

                            ],
                          ),
                      

                        ]),
                      )
                    )

                  ],
                );            
              },
            )
          ),
          
        );
      },
    );
  }
}