import 'package:flutter/material.dart';

import 'package:amulet/views/basewidgets/emoney/emoney.dart';
import 'package:amulet/localization/language_constraints.dart';
import 'package:amulet/utils/color_resources.dart';
import 'package:amulet/views/basewidgets/appbar/custom_appbar.dart';
import 'package:amulet/views/screens/ppob/emoney/detail.dart';

class VoucherEmoneyScreen extends StatelessWidget {
  const VoucherEmoneyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [

            CustomAppBar(title: getTranslated("E_MONEY", context)),

            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 10.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 0.0,
                    mainAxisSpacing: 0.0,
                    childAspectRatio: 2 / 1
                  ),
                  itemCount: emoneyMenus.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int i) {
                    return Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.all(5.0),
                            height: 80.0,
                            child: Card(
                              elevation: 1.0,
                              color: ColorResources.white,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => DetailVoucherEmoneyScreen(
                                      type: emoneyMenus[i]["type"],
                                    )),
                                  );
                                },
                                child: Container(
                                  width: 100.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius .circular(4.0)
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          emoneyMenus[i]["icons"] == null ? Text(emoneyMenus[i]["text"],
                                            style: TextStyle(
                                              color: ColorResources.primary,
                                              fontSize: 12.0
                                            )) : Center(
                                            child: Image.asset("${emoneyMenus[i]["icons"]}",
                                              height: 40.0,
                                              width: 40.0,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ),
                        )
                      ]
                    );
                  },
                ),
              ),
            ),
      

          ],
        ),
      ),
    );
  }
}