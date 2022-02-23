import 'package:flutter/material.dart';
import 'package:amulet/utils/color_resources.dart';
import 'package:amulet/utils/dimensions.dart';

class ShowSnackbar {
  ShowSnackbar._();
  static snackbar(BuildContext context, String content, String label, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: backgroundColor,
        content: Text(
          content, 
          style: const TextStyle(
            fontSize: Dimensions.fontSizeSmall,
            color: ColorResources.white
          )
        ),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          textColor: Colors.white,
          label: label,
          onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar()
        ),
      )
    );
  }
}