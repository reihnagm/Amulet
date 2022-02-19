import 'package:flutter/material.dart';

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
          return Future.sync(() {});
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

            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int i) {
                  return Container();
                }

              )
            )
      
      
          
          ],
        ),
      ),
    );
  }
}