import 'package:flutter/material.dart';

import 'package:panic_button/utils/color_resources.dart';
import 'package:panic_button/utils/dimensions.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({ Key? key }) : super(key: key);

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
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
                  child: const Text("Home",
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
                  child: const Text("Emergency Contact",
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
                  child: const Text("My Subscription",
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
                  child: const Text("Log out",
                    style: TextStyle(
                      color: ColorResources.redPrimary,
                      fontWeight: FontWeight.w500,
                      fontSize: Dimensions.fontSizeDefault
                    ),
                  ),
                ),
              ],
            )
    
          ],
        ),
      ),
    );
  }
}