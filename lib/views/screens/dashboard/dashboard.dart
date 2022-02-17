import 'package:flutter/material.dart';

import 'package:panic_button/utils/color_resources.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({ Key? key }) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.backgroundColor,
      endDrawer: Drawer(
        
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/home-decoration.png"),
                  fit: BoxFit.cover
                )
              ),
              child: Stack(
                children: [
                  
                ],
              ),
            );
          },
        ),
      )
    );
  }
}