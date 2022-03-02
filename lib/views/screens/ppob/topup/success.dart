import 'package:flutter/material.dart';

import 'package:amulet/utils/color_resources.dart';
import 'package:amulet/views/screens/home/home.dart';

class TopUpSuccessScreen extends StatelessWidget {
  final String? title;

  const TopUpSuccessScreen({Key? key, 
    this.title
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[300],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          const Center(
            child: Icon(
              Icons.verified,
              color: ColorResources.white,
              size: 100.0,
            ),
          ),

          const SizedBox(height: 16.0),

          Container(
            margin: const EdgeInsets.only(left: 40.0, right: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Text("Permintaan Anda akan segera kami proses,",
                    softWrap: true,
                    style: TextStyle(
                      fontSize: 14.0,
                      height: 1.4,
                      fontWeight: FontWeight.bold,
                      color: ColorResources.white
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text("segera lakukan pembayaran.",
                    softWrap: true,
                    style: TextStyle(
                      fontSize: 14.0,
                      height: 1.4,
                      fontWeight: FontWeight.bold,
                      color: ColorResources.white
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text("Notifikasi akan masuk ke Inbox Anda.",
                    softWrap: true,
                    style: TextStyle(
                      fontSize: 14.0,
                      height: 1.4,
                      fontWeight: FontWeight.bold,
                      color: ColorResources.white
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20.0),

          Center(
            child: SizedBox(
              width: 100.0,
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(key: UniqueKey())));
                },
                child: Text("OK",
                  style: TextStyle(
                    color: Colors.white
                  ),
                ),
              ),
            ),
          )

        ],
      ),
    );
  }
}