import 'package:flutter/material.dart';

import 'package:amulet/utils/dimensions.dart';
import 'package:amulet/views/screens/home/home.dart';
import 'package:amulet/utils/color_resources.dart';

class CashOutSuccessScreen extends StatelessWidget {
  final String? title;

  const CashOutSuccessScreen({Key? key, 
    this.title
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[300],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [

            const Icon(
              Icons.verified,
              color: ColorResources.white,
              size: 100.0,
            ),
            
            const SizedBox(height: 20.0),

            Container(
              margin: const EdgeInsets.only(left: Dimensions.marginSizeSmall, right: Dimensions.marginSizeSmall),
              child: Text("Permintaan Anda akan segera kami proses,",
                softWrap: true,
                style: TextStyle(
                  fontSize: Dimensions.fontSizeSmall,
                  height: 1.4,
                  fontWeight: FontWeight.bold,
                  color: ColorResources.white
                ),
              ),
            ),

            Container(
              margin: const EdgeInsets.only(left: Dimensions.marginSizeSmall, right: Dimensions.marginSizeSmall),
              child: Text("Notifikasi akan masuk ke Inbox Anda.",
                softWrap: true,
                style: TextStyle(
                  fontSize: Dimensions.fontSizeDefault,
                  height: 1.4,
                  fontWeight: FontWeight.bold,
                  color: ColorResources.white
                ),
              ),
            ),

            const SizedBox(height: 20.0),

            SizedBox(
              width: 140.0,
              child: ElevatedButton(
                style: ButtonStyle(
                  elevation: MaterialStateProperty.resolveWith<double>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.disabled)) {
                        return 0;
                      }
                      return 0;
                    },
                  ),
                  backgroundColor: MaterialStateProperty.all(Colors.blue[600]),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    )
                  )
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(
                    key: UniqueKey(),
                  )));
                },
                child: Text("OK",
                  style: TextStyle(
                    color: ColorResources.white
                  ),
                ),
              ),
            )

          ],
        ),
      ),
    );
  }
}