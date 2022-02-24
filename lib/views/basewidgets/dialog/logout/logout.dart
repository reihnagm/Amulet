import 'package:amulet/localization/language_constraints.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:amulet/providers/auth.dart';
import 'package:amulet/utils/color_resources.dart';
import 'package:amulet/utils/dimensions.dart';
import 'package:amulet/views/screens/auth/sign_in.dart';

class SignOutConfirmationDialog extends StatelessWidget {
  const SignOutConfirmationDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0)
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, 
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: 50),
            child: Text(getTranslated("ARE_YOU_SURE_LOGOUT", context), 
              style: TextStyle(
                fontSize: Dimensions.fontSizeDefault,
                fontWeight: FontWeight.w500
              ), 
              textAlign: TextAlign.center
            ),
          ),
          const Divider(
            height: 0.0, 
            color: ColorResources.hintColor
          ),
          Row(
            children: [
            Expanded(
              child: InkWell(
              onTap: () {
                Provider.of<AuthProvider>(context, listen: false).logout(context);
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const SignInScreen()), (route) => false);
              },
              child: Container(
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: ColorResources.redPrimary,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10.0)
                  )
                ),
                child: const Text("OK", style: TextStyle(
                  color: ColorResources.white,
                  fontSize: Dimensions.fontSizeSmall
                )),
              ),
            )
          ),
          Expanded(
            child: InkWell(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: ColorResources.white, 
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(10.0)
                  )
                ),
                child: Text(getTranslated("NO", context), style: TextStyle(
                    color: ColorResources.black,
                    fontSize: Dimensions.fontSizeSmall,
                  )
                ),
              ),
            )
          ),
        ]),
      ]),
    );
  }
}
