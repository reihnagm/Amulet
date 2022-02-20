import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:panic_button/providers/videos.dart';
import 'package:panic_button/services/navigation.dart';
import 'package:provider/provider.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:panic_button/views/screens/media/record.dart';
import 'package:panic_button/providers/location.dart';
import 'package:panic_button/views/basewidgets/drawer/drawer.dart';
import 'package:panic_button/providers/auth.dart';
import 'package:panic_button/views/screens/notification/notification.dart';
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

  late AuthProvider authProvider;
  late LocationProvider locationProvider;
  late VideoProvider videoProvider;
  late NavigationService navigationService;

  void openRecord() {
    navigationService.pushNav(context,  RecordScreen(key: UniqueKey()));
  }

  @override 
  void initState() {
    super.initState();

    Future.delayed((Duration.zero), () {
      if(mounted) {
        locationProvider.getCurrentPosition(context);
      }
      if(mounted) {
        videoProvider.initFcm(context);
      }
      if(mounted) {
        videoProvider.fetchFcm(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return buildUI();
  }

  Widget buildUI() {
    return Builder(
      builder: (context) {
        authProvider = context.read<AuthProvider>();
        locationProvider = context.read<LocationProvider>();
        videoProvider = context.read<VideoProvider>();
        navigationService = NavigationService();
        return Scaffold(
          resizeToAvoidBottomInset: false,
          key: globalKey,
          drawer: DrawerWidget(key: UniqueKey()),
          backgroundColor: ColorResources.white,
          body: SafeArea(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Stack(
                  clipBehavior: Clip.none,
                  children: [

                    RefreshIndicator(
                      backgroundColor: ColorResources.white,
                      color: ColorResources.redPrimary,
                      onRefresh: () {
                        return Future.sync(() {
                          locationProvider.getCurrentPosition(context);
                          videoProvider.initFcm(context);
                          videoProvider.fetchFcm(context);
                        });
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
                                      navigationService.pushNav(context, NotificationScreen(key: UniqueKey()));
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
                                        fontSize: Dimensions.fontSizeLarge
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5.0),
                                  Container(
                                    margin: const EdgeInsets.only(left: Dimensions.marginSizeDefault),
                                    alignment: Alignment.centerLeft,
                                    child: Text(authProvider.getUserFullname(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: Dimensions.fontSizeOverLarge
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

                    Consumer<VideoProvider>(
                      builder: (BuildContext context, VideoProvider vp, Widget? child) {
                        if(vp.fcmStatus == FcmStatus.loading) {
                          return Container();
                        }
                        
                        return Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(top: 160.0),
                            child: GoogleMap(
                              mapType: MapType.normal,
                              gestureRecognizers: {}..add(Factory<EagerGestureRecognizer>(() => EagerGestureRecognizer())),
                              myLocationEnabled: false,
                              initialCameraPosition: CameraPosition(
                                target: LatLng(
                                  locationProvider.getCurrentLat, 
                                  locationProvider.getCurrentLng
                                ),
                                zoom: 10.0,
                              ),
                              markers: Set.from(vp.markers),
                              onMapCreated: (GoogleMapController controller) {
                                mapsController.complete(controller);
                                locationProvider.controller = controller;
                              },
                            ),
                          )
                        );
                      },
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
                          bottom: 100.0,
                        ),
                        child: ConfirmationSlider(
                          foregroundShape: BorderRadius.circular(10.0),
                          backgroundShape:BorderRadius.circular(10.0) ,
                          foregroundColor: ColorResources.redPrimary,
                          text: "Slide to Send Alert",
                          height: 60.0,
                          onConfirmation: () => openRecord()
                        ),
                      ),
                    ),

                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}