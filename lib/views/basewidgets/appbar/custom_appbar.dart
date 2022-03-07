import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:amulet/utils/color_resources.dart';
import 'package:amulet/utils/dimensions.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final bool isBackButtonExist;
  final IconData? icon;
  final Function? onPressed;

  const CustomAppBar({Key? key, 
    required this.title, 
    this.isBackButtonExist = true, 
    this.icon, 
    this.onPressed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
      Container(
        color: ColorResources.redPrimary,
        margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        height: 50.0,
        alignment: Alignment.center,
        child: Row(
          children: [
            isBackButtonExist 
            ? Container(
              margin: const EdgeInsets.only(left: 15.0),
              child: CupertinoNavigationBarBackButton(
              onPressed: () => Navigator.of(context).pop(),
                color: Colors.white,
              )
            )
            : const SizedBox.shrink(),
            const SizedBox(width: Dimensions.paddingSizeSmall),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: Dimensions.fontSizeDefault, 
                  color: ColorResources.white
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          icon != null
          ? IconButton(
              icon: Icon(
                icon, 
                size: Dimensions.iconSizeLarge, 
                color: Colors.white
              ),
              onPressed: () => onPressed!(),
            )
          : const SizedBox.shrink(),
        ]),
      ),
    ]);
  }
}
