import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:panic_button/utils/box_shadow.dart';
import 'package:panic_button/utils/color_resources.dart';
import 'package:panic_button/utils/dimensions.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({ Key? key }) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorResources.backgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return RefreshIndicator(
              backgroundColor: ColorResources.redPrimary,
              color: ColorResources.white,
              onRefresh: () {
                return Future.sync((){

                });
              },
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                slivers: [

                  SliverAppBar(
                    backgroundColor: ColorResources.white,
                    centerTitle: true,
                    title: const Text("Notifikasi",
                      style: TextStyle(
                        color: ColorResources.black,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                    leading: CupertinoNavigationBarBackButton(
                      color: ColorResources.black,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ),

                  SliverPadding(
                    padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int i) {
                          return Container(
                            padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                            margin: const EdgeInsets.all(Dimensions.marginSizeDefault),
                            decoration: BoxDecoration(
                              color: ColorResources.white,
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: boxShadow
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Image.asset("assets/images/info-sos.png",
                                    width: 35.0,
                                    height: 35.0,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container()
                                ),
                                Expanded(
                                  flex: 16,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const SizedBox(
                                        width: 200.0,
                                        child: Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
                                          softWrap: true,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: ColorResources.black,
                                            fontWeight: FontWeight.w400,
                                            fontSize: Dimensions.fontSizeSmall,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 12.0),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Text(DateFormat('M/d/y').format(DateTime.now()),
                                            style: const TextStyle(
                                              color: ColorResources.greyDarkPrimary,
                                              fontWeight: FontWeight.w300,
                                              fontSize: Dimensions.fontSizeExtraSmall
                                            ),
                                          ),
                                          const Text("15:38",
                                            style: TextStyle(
                                              color: ColorResources.greyDarkPrimary,
                                              fontWeight: FontWeight.w300,
                                              fontSize: Dimensions.fontSizeExtraSmall
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                )

                              ],
                            ),
                          );
                        },
                        childCount: 5
                      )
                    ),
                  )

                ],
              ),
            );
          },  
        ),
      ),
    );  
  }
}