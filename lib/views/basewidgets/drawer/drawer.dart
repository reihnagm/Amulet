import 'package:flutter/material.dart';
import 'package:panic_button/services/navigation.dart';

import 'package:panic_button/utils/color_resources.dart';
import 'package:panic_button/utils/dimensions.dart';
import 'package:panic_button/views/basewidgets/dialog/animated/animated.dart';
import 'package:panic_button/views/basewidgets/dialog/logout/logout.dart';
import 'package:panic_button/views/screens/reports/index.dart';
import 'package:panic_button/views/screens/home/home.dart';

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
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Beranda",
                            style: TextStyle(
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
                    child: const Text("Settings",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: Dimensions.fontSizeDefault
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
                    child: const Text("Kontak Darurat",
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
                    child: Material(
                      color: ColorResources.transparent,
                      child: InkWell(
                        onTap: () {
                          navigationService.pushNav(context, ReportsScreen(key: UniqueKey()));
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Daftar Video",
                            style: TextStyle(
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
                    child: const Text("Berlangganan",
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
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Log out",
                            style: TextStyle(
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