import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:panic_button/providers/videos.dart';
import 'package:panic_button/utils/box_shadow.dart';

import 'package:panic_button/utils/color_resources.dart';
import 'package:panic_button/utils/dimensions.dart';
import 'package:panic_button/views/basewidgets/drawer/drawer.dart';

class ListVideoScreen extends StatefulWidget {
  const ListVideoScreen({ Key? key }) : super(key: key);

  @override
  _ListVideoScreenState createState() => _ListVideoScreenState();
}

class _ListVideoScreenState extends State<ListVideoScreen> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  late VideoProvider videoProvider;

  @override 
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: globalKey,
      drawer: DrawerWidget(key: UniqueKey()),
      backgroundColor: ColorResources.backgroundColor,
      body: RefreshIndicator(
        backgroundColor: ColorResources.white,
        color: ColorResources.redPrimary,
        onRefresh: () {
          return Future.sync(() {

          });
        },
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          slivers: [
      
            SliverAppBar(
              backgroundColor: ColorResources.white,
              centerTitle: true,
              title: Image.asset("assets/images/logo-panic-button.png",
                width: 80.0,
                height: 80.0,
              ),
              leading: Container(
                margin: const EdgeInsets.only(left: Dimensions.marginSizeDefault),
                child: InkWell(
                  onTap: () {
                    globalKey.currentState!.openDrawer();
                  },
                  child: const Icon(
                    Icons.menu,
                    color: ColorResources.black,
                  ),
                )
              ),
            ),

            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.only(
                  top: 50.0,
                  left: Dimensions.marginSizeLarge,
                  right: Dimensions.marginSizeLarge,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Expanded(
                      flex: 5,
                      child: Text("Thumbnail",
                        style: TextStyle(
                          fontSize: Dimensions.fontSizeDefault,
                          fontWeight: FontWeight.w500
                        ),
                      )
                    ),
                    Expanded(
                      flex: 5,
                      child: Text("Keterangan",
                        style: TextStyle(
                          fontSize: Dimensions.fontSizeDefault,
                          fontWeight: FontWeight.w500
                        ),
                      )
                    ),
                    Expanded(
                      flex: 5,
                      child: Text("Pengirim",
                        style: TextStyle(
                          fontSize: Dimensions.fontSizeDefault,
                          fontWeight: FontWeight.w500
                        ),
                      )
                    ),
                    Expanded(
                      flex: 3,
                      child: Text("Info",
                        style: TextStyle(
                          fontSize: Dimensions.fontSizeDefault,
                          fontWeight: FontWeight.w500
                        ),
                      )
                    ),
                  ],
                ),
              )
            ),

            SliverPadding(
              padding: const EdgeInsets.only(
                top: 20.0, 
                bottom: 20.0
              ),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int i) {
                    return Container(
                      margin: const EdgeInsets.only(
                        left: Dimensions.marginSizeLarge, 
                        right: Dimensions.marginSizeLarge
                      ),
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: i % 2 == 1 
                        ? ColorResources.greyTable 
                        : ColorResources.white,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            flex: 6,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: CachedNetworkImage(
                                    imageUrl: "https://i.pravatar.cc/300",
                                    width: 50.0,
                                    height: 50.0,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              ],
                            ) 
                          ),
                          Expanded(
                            flex: 6,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text("Kebakaran",
                                  style: TextStyle(
                                    color: ColorResources.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: Dimensions.fontSizeDefault
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 8,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text("Reihan Agam",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: ColorResources.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: Dimensions.fontSizeDefault
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Icons.info,
                                  color: ColorResources.blue,
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                  childCount: 20          
                )
              ),
            )
      
          ],
        ),
      ),
    );
  }
}