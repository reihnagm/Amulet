import 'package:amulet/localization/language_constraints.dart';
import 'package:amulet/utils/box_shadow.dart';
import 'package:amulet/utils/color_resources.dart';
import 'package:amulet/utils/dimensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SubscriptionsScreen extends StatefulWidget {
  const SubscriptionsScreen({ Key? key }) : super(key: key);

  @override
  State<SubscriptionsScreen> createState() => _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends State<SubscriptionsScreen> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
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
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                   
                                  Text("Lorem ipsum dolor sit amet",
                                    style: TextStyle(
                                      fontSize: Dimensions.fontSizeSmall,
                                      fontWeight: FontWeight.w400,
                                      color: ColorResources.redPrimary
                                    ),
                                  ),

                                  const SizedBox(height: 12.0),

                                  Text("Lorem ipsum dolor sit amet",
                                    style: TextStyle(
                                      fontSize: Dimensions.fontSizeSmall,
                                      fontWeight: FontWeight.w400,
                                      color: ColorResources.redPrimary
                                    ),
                                  ),

                                  const SizedBox(height: 12.0),

                                  Text("Lorem ipsum dolor sit amet",
                                    style: TextStyle(
                                      fontSize: Dimensions.fontSizeSmall,
                                      fontWeight: FontWeight.w400,
                                      color: ColorResources.redPrimary
                                    ),
                                  ),

                                  const SizedBox(height: 12.0),

                                  Text("Lorem ipsum dolor sit amet",
                                    style: TextStyle(
                                      fontSize: Dimensions.fontSizeSmall,
                                      fontWeight: FontWeight.w400,
                                      color: ColorResources.redPrimary
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
                                onTap: () {
                                  
                                },
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
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                   
                                  Text("Lorem ipsum dolor sit amet",
                                    style: TextStyle(
                                      fontSize: Dimensions.fontSizeSmall,
                                      fontWeight: FontWeight.w400,
                                      color: ColorResources.redPrimary
                                    ),
                                  ),

                                  const SizedBox(height: 12.0),

                                  Text("Lorem ipsum dolor sit amet",
                                    style: TextStyle(
                                      fontSize: Dimensions.fontSizeSmall,
                                      fontWeight: FontWeight.w400,
                                      color: ColorResources.redPrimary
                                    ),
                                  ),

                                  const SizedBox(height: 12.0),

                                  Text("Lorem ipsum dolor sit amet",
                                    style: TextStyle(
                                      fontSize: Dimensions.fontSizeSmall,
                                      fontWeight: FontWeight.w400,
                                      color: ColorResources.redPrimary
                                    ),
                                  ),

                                  const SizedBox(height: 12.0),

                                  Text("Lorem ipsum dolor sit amet",
                                    style: TextStyle(
                                      fontSize: Dimensions.fontSizeSmall,
                                      fontWeight: FontWeight.w400,
                                      color: ColorResources.redPrimary
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
                                onTap: () {
                                  
                                },
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
  }
}