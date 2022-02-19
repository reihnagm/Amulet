import 'package:flutter/material.dart';

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
      body: CustomScrollView(
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        slivers: [

          SliverAppBar(),



        ],
      ),
    );
  }
}