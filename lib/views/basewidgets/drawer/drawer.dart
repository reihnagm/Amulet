import 'package:flutter/material.dart';

import 'package:amulet/views/screens/contacts/contacts.dart';
import 'package:amulet/localization/language_constraints.dart';
import 'package:amulet/services/navigation.dart';
import 'package:amulet/utils/color_resources.dart';
import 'package:amulet/utils/dimensions.dart';
import 'package:amulet/views/basewidgets/dialog/animated/animated.dart';
import 'package:amulet/views/basewidgets/dialog/logout/logout.dart';
import 'package:amulet/views/screens/reports/index.dart';
import 'package:amulet/views/screens/home/home.dart';
import 'package:amulet/views/screens/settings/settings.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({ Key? key }) : super(key: key);

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  late NavigationService navigationService;

  @override
  Widget build(BuildContext context) {
    return buildUI();
  }

  Widget buildUI() {
    return Builder(
      builder: ((BuildContext context) {
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
                    child: const Text("History",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: Dimensions.fontSizeDefault,
                        decoration: TextDecoration.lineThrough
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
                       navigationService.pushNav(context, ContactsScreen(key: UniqueKey()));
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
                    child: Text(getTranslated("SUBSCRIPTION", context),
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: Dimensions.fontSizeDefault,
                        decoration: TextDecoration.lineThrough
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