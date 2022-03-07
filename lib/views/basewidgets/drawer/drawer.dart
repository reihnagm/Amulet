import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:amulet/providers/videos.dart';
import 'package:amulet/providers/auth.dart';

import 'package:amulet/views/screens/contacts/contacts.dart';
import 'package:amulet/localization/language_constraints.dart';
import 'package:amulet/services/navigation.dart';

import 'package:amulet/utils/color_resources.dart';
import 'package:amulet/utils/dimensions.dart';

import 'package:amulet/views/basewidgets/button/custom.dart';
import 'package:amulet/views/basewidgets/dialog/animated/animated.dart';
import 'package:amulet/views/basewidgets/dialog/logout/logout.dart';

import 'package:amulet/views/screens/reports/index.dart';
import 'package:amulet/views/screens/home/home.dart';
import 'package:amulet/views/screens/settings/settings.dart';

import 'package:amulet/views/screens/history/history.dart';
import 'package:amulet/views/screens/subscriptions/index.dart';
import 'package:amulet/views/screens/auth/sign_in.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({ Key? key }) : super(key: key);

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  late NavigationService navigationService;
  late AuthProvider authProvider;

  @override
  Widget build(BuildContext context) {
    return buildUI();
  }

  Widget buildUI() {
    return Builder(
      builder: ((BuildContext context) {
        authProvider = context.read<AuthProvider>();
        navigationService = NavigationService();
        return SafeArea(
        child: Drawer(
          backgroundColor: ColorResources.backgroundColor,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [

              DrawerHeader(
                decoration: BoxDecoration(
                  color: ColorResources.backgroundColor,
                  border: Border.all(
                    color: ColorResources.backgroundColor
                  )
                ),
                padding: const EdgeInsets.all(40.0),
                child: Image.asset("assets/images/logo.png")
              ),
              if(!authProvider.isLoggedIn()!) 
                Container(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  child: Material(
                    color: ColorResources.transparent,
                    child: InkWell(
                      onTap: () {
                        navigationService.pushNav(context, SignInScreen(key: UniqueKey()));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(getTranslated("LOGIN", context),
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: Dimensions.fontSizeDefault
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              if(authProvider.isLoggedIn()!)    
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      child: Material(
                        color: ColorResources.transparent,
                        child: InkWell(
                          onTap: () {
                            navigationService.pushNav(context, HomeScreen(key: UniqueKey()));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(getTranslated("HOME", context),
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: Dimensions.fontSizeDefault
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        left: Dimensions.marginSizeExtraLarge, 
                        right: Dimensions.marginSizeExtraLarge
                      ),
                      child: const Divider(
                        color: ColorResources.grey,
                      )
                    ),
                    Container(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      child: Material(
                        color: ColorResources.transparent,
                        child: InkWell(
                          onTap: () {
                            navigationService.pushNav(context, SettingsScreen(key: UniqueKey()));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(getTranslated("SETTINGS", context),
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: Dimensions.fontSizeDefault
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        left: Dimensions.marginSizeExtraLarge, 
                        right: Dimensions.marginSizeExtraLarge
                      ),
                      child: const Divider(
                        color: ColorResources.grey,
                      )
                    ),
                    Container(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      child: InkWell(
                        onTap: () {
                          navigationService.pushNav(context, HistoryScreen(key: UniqueKey()));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(getTranslated("HISTORY", context),
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: Dimensions.fontSizeDefault,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        left: Dimensions.marginSizeExtraLarge, 
                        right: Dimensions.marginSizeExtraLarge
                      ),
                      child: const Divider(
                        color: ColorResources.grey,
                      )
                    ),
                    Container(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      child: InkWell(
                        onTap: () async {
                          await context.read<VideoProvider>().checkSubscription(context); 
                          context.read<VideoProvider>().subscriptionStatus == SubscriptionStatus.loading 
                          ? showAnimatedDialog(
                              context, 
                              Builder(
                                builder: (ctx) {
                                  return Container();
                                }
                              )
                            )
                          : context.read<VideoProvider>().resCheckSubscription?.statusCode != 200 
                          ? showAnimatedDialog(
                              context,
                              Builder(
                                builder: (ctx) {
                                  return Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      
                                      Dialog(
                                        backgroundColor: ColorResources.white,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(70.0),
                                            topRight: Radius.circular(70.0)
                                          )
                                        ),
                                        alignment: Alignment.center,
                                        child: SizedBox(
                                          height: 220.0,
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                              top: Dimensions.marginSizeLarge,
                                              left: Dimensions.marginSizeSmall, 
                                              right: Dimensions.marginSizeSmall
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text("${getTranslated("SUBSCRIBE_NOW", context)}! \n\n- ${getTranslated("SOS_EMERGENCY", context)}\n- ${getTranslated("SHARE_TO_EMERGENCY_CONTACT", context)}",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    height: 1.5,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: Dimensions.fontSizeLarge
                                                  ),
                                                ),

                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  mainAxisSize: MainAxisSize.max,
                                                  children: [
                                                    
                                                    Expanded(
                                                      child: Container(
                                                        margin: const EdgeInsets.only(top: Dimensions.marginSizeDefault),
                                                        child: CustomButton(
                                                          onTap: () {
                                                            Navigator.of(ctx, rootNavigator: true).pop();
                                                          },
                                                          height: 35.0,
                                                          btnColor: ColorResources.redPrimary,
                                                          btnTextColor: ColorResources.white,
                                                          isBoxShadow: true,
                                                          isBorder: false,
                                                          isBorderRadius: false, 
                                                          btnTxt: getTranslated("NO", context)
                                                        ),
                                                      ),
                                                    ),

                                                    SizedBox(width: 20.0),

                                                    Expanded(
                                                      child: Container(
                                                        margin: const EdgeInsets.only(top: Dimensions.marginSizeDefault),
                                                        child: CustomButton(
                                                          onTap: () {
                                                            navigationService.pushNav(context, SubscriptionsScreen(key: UniqueKey()));
                                                          },
                                                          height: 35.0,
                                                          btnColor: ColorResources.redPrimary,
                                                          btnTextColor: ColorResources.white,
                                                          isBoxShadow: true,
                                                          isBorder: false,
                                                          isBorderRadius: false, 
                                                          btnTxt: getTranslated("SUBSCRIBE", context)
                                                        ),
                                                      ),
                                                    )

                                                  ],
                                                )

                                              ],
                                            ),
                                          ),
                                        )
                                      ),

                                      Positioned(
                                        bottom: 500.0,
                                        left: 0.0,
                                        right: 0.0,
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Image.asset('assets/images/amulet-icon-logo.png',
                                            width: 100.0,
                                            height: 100.0,
                                            fit: BoxFit.scaleDown,
                                          ),
                                        ),
                                      ),

                                    ]
                                  );
                                },
                              ),
                              dismissible: false
                            )
                          : navigationService.pushNav(context, ContactsScreen(key: UniqueKey()));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(getTranslated("CONTACT_EMERGENCY", context),
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: Dimensions.fontSizeDefault,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        left: Dimensions.marginSizeExtraLarge, 
                        right: Dimensions.marginSizeExtraLarge
                      ),
                      child: const Divider(
                        color: ColorResources.grey,
                      )
                    ),
                    Container(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      child: Material(
                        color: ColorResources.transparent,
                        child: InkWell(
                          onTap: () {
                            navigationService.pushNav(context, ReportsScreen(key: UniqueKey()));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(getTranslated("LIST_REPORT", context),
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: Dimensions.fontSizeDefault
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        left: Dimensions.marginSizeExtraLarge, 
                        right: Dimensions.marginSizeExtraLarge
                      ),
                      child: const Divider(
                        color: ColorResources.grey,
                      )
                    ),
                    Container(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      child: Material(
                        color: ColorResources.transparent,
                        child: InkWell(
                          onTap: () {
                            navigationService.pushNav(context, SubscriptionsScreen(key: UniqueKey()));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(getTranslated("SUBSCRIPTION", context),
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: Dimensions.fontSizeDefault,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        left: Dimensions.marginSizeExtraLarge, 
                        right: Dimensions.marginSizeExtraLarge
                      ),
                      child: const Divider(
                        color: ColorResources.grey,
                      )
                    ),
                    Container(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      child: Material(
                        color: ColorResources.transparent,
                        child: InkWell(
                          onTap: () {
                            showAnimatedDialog(
                              context,
                              const SignOutConfirmationDialog(),
                              isFlip: true
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(getTranslated("LOGOUT", context),
                              style: const TextStyle(
                                color: ColorResources.redPrimary,
                                fontWeight: FontWeight.w500,
                                fontSize: Dimensions.fontSizeDefault
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
      
            ],
          ),
        ),
      );  
      }),
    );
  }
}