import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:panic_button/providers/auth.dart';
import 'package:panic_button/utils/color_resources.dart';
import 'package:panic_button/utils/dimensions.dart';
import 'package:panic_button/views/screens/auth/sign_in.dart';

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
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: 50),
            child: Text("Apakah kamu yakin ingin keluar ?", 
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
                child: const Text("Ya", style: TextStyle(
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
                child: const Text("Tidak", style: TextStyle(
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
