import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:panic_button/views/screens/notification/notification.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:panic_button/basewidgets/drawer/drawer.dart';
import 'package:panic_button/utils/color_resources.dart';
import 'package:panic_button/utils/dimensions.dart';
import 'package:panic_button/views/screens/category/category.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({ Key? key }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  Completer<GoogleMapController> mapsController = Completer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: globalKey,
      drawer: DrawerWidget(key: UniqueKey()),
      backgroundColor: ColorResources.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Stack(
              children: [

                RefreshIndicator(
                  backgroundColor: ColorResources.white,
                  color: ColorResources.redPrimary,
                  onRefresh: () {
                    return Future.sync(() {});
                  },
                  child: CustomScrollView(
                    physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                    slivers: [
                      
                      SliverAppBar(
                        toolbarHeight: 80.0,
                        backgroundColor: ColorResources.transparent,
                        title: Image.asset('assets/images/logo.png',
                          width: 70.0,
                          height: 70.0,
                          fit: BoxFit.scaleDown,
                        ),
                        centerTitle: true,
                        iconTheme: const IconThemeData(
                          color: ColorResources.black
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
                        actions: [
                          Container(
                            margin: const EdgeInsets.only(right: Dimensions.marginSizeDefault),
                            child: Material(
                              color: ColorResources.transparent,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(context,
                                    PageRouteBuilder(pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
                                      return NotificationScreen(key: UniqueKey());
                                    },
                                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                      Offset begin = const Offset(1.0, 0.0);
                                      Offset end = Offset.zero;
                                      Cubic curve = Curves.ease;
                                      Animatable<Offset> tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                      return SlideTransition(
                                        position: animation.drive(tween),
                                        child: child,
                                      );
                                    })
                                  );
                                },
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.notifications,
                                    size: 25.0,
                                    color: ColorResources.black,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                        bottom: PreferredSize(
                          child:  Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(left: Dimensions.marginSizeDefault),
                                alignment: Alignment.centerLeft,
                                child: const Text("Hello",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: Dimensions.fontSizeOverLarge
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5.0),
                              Container(
                                margin: const EdgeInsets.only(left: Dimensions.marginSizeDefault),
                                alignment: Alignment.centerLeft,
                                child: const Text("Edwin",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: Dimensions.fontSizeExtraLarge
                                  ),
                                ),
                              )
                            ],
                          ),
                          preferredSize: const Size.fromHeight(60.0) 
                        ),
                      ),
                      
                
                    ],
                  ),
                ),

                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 160.0),
                    child: GoogleMap(
                      mapType: MapType.normal,
                      gestureRecognizers: {}..add(Factory<EagerGestureRecognizer>(() => EagerGestureRecognizer())),
                      myLocationEnabled: false,
                      initialCameraPosition: const CameraPosition(
                        target: LatLng(-6.175392, 106.827153),
                        zoom: 15.0,
                      ),
                      markers: const {},
                      onMapCreated: (GoogleMapController controller) {
                        mapsController.complete(controller);
                      },
                    ),
                  )
                ),

                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: const EdgeInsets.only(
                      top: 175.0,
                      left: Dimensions.marginSizeDefault, 
                      right: Dimensions.marginSizeDefault
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: ColorResources.redPrimary
                    ),
                    child: InkWell(
                      onTap: () { 
                        Navigator.push(context,
                          PageRouteBuilder(pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
                            return CategoryScreen(key: UniqueKey());
                          },
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            Offset begin = const Offset(1.0, 0.0);
                            Offset end = Offset.zero;
                            Cubic curve = Curves.ease;
                            Animatable<Offset> tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                            return SlideTransition(
                              position: animation.drive(tween),
                              child: child,
                            );
                          })
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Kategori",
                          style: TextStyle(
                            fontSize: Dimensions.fontSizeSmall,
                            color: ColorResources.white
                          ),
                        ),
                      ),
                    )
                  ),
                ),
                                
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: const EdgeInsets.only(
                      top: 50.0, 
                      bottom: 110.0,
                      left: Dimensions.marginSizeDefault,
                      right: Dimensions.marginSizeDefault,
                    ),
                    child: ConfirmationSlider(
                      foregroundShape: BorderRadius.circular(10.0),
                      backgroundShape:BorderRadius.circular(10.0) ,
                      foregroundColor: ColorResources.redPrimary,
                      text: "Slide to Send Alert",
                      width: double.infinity,
                      height: 60.0,
                      onConfirmation: () {},
                    ),
                  ),
                ),

              ],
            );
          },
        ),
      ),
    );
  }
}