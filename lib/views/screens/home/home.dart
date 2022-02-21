import 'dart:async';

import 'package:badges/badges.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:panic_button/views/basewidgets/button/custom.dart';
import 'package:panic_button/views/screens/media/record.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:panic_button/localization/language_constraints.dart';
import 'package:panic_button/providers/inbox.dart';
import 'package:panic_button/providers/videos.dart';
import 'package:panic_button/services/navigation.dart';
import 'package:panic_button/views/basewidgets/snackbar/snackbar.dart';
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

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  Completer<GoogleMapController> mapsController = Completer();

  late AuthProvider authProvider;
  late LocationProvider locationProvider;
  late InboxProvider inboxProvider;
  late VideoProvider videoProvider;
  late NavigationService navigationService;

  String selectedTextCat = "";
  int selectedCatIdx = -1;
  int selectedChildCatIdx = -1;

  bool isRecordPressed = false;

  List categories = [
    {
      "id": 1,
      "name": "Pencurian",
      "suggestions": [
        {
          "cat_id": 1,
          "contents": [
            {
              "id": 1,
              "name": "Tolong, Barang Saya di jambret !"
            },
            {
              "id": 2,
              "name": "Terjadi Penjambretan !"
            }
          ] 
        },
      ]
    },
    {
      "id": 2,
      "name": "Kebakaran", 
      "suggestions": [
        {
          "cat_id": 2,
          "contents": [
            {
              "id": 1,
              "name": "Ada Kebakaran !"
            },
            {
              "id": 2,
              "name": "Telah terjadi Kebakaran !"
            }
          ]
        }
      ]
    },
    {
      "id": 3,
      "name": "Kecelakaan",
      "suggestions": [
        {
          "cat_id": 3,
          "contents": [
            {
              "id": 1,
              "name": "Telah terjadi kecelakaan !"
            },
            {
              "id": 2,
              "name": "Kecelakaan di"
            }
          ]
        }
      ]
    },
    {
      "id": 4,
      "name": "Bencana Alam",
      "suggestions": [
        {
          "cat_id": 4,
          "contents": [
            {
              "id": 1,
              "name": "Telah terjadi bencana alam !"
            },
            {
              "id": 2,
              "name": "Banjir / Gempa / Longsor di"
            }
          ]
        }
      ]
    },
    {
      "id": 5,
      "name": "Perampokan",
      "suggestions": [
        {
          "cat_id": 5,
          "contents": [
            {
              "id": 1,
              "name": "Tolong di rampok !"
            },
            {
              "id": 2,
              "name": "Telah terjadi perampokan di"
            }
          ]
        }
      ]
    },
    {
      "id": 6,
      "name": "Kerusuhan",
      "suggestions": [
        {
          "cat_id": 6,
          "contents": [
            {
              "id": 1,
              "name": "Telah terjadi aksi"
            },
            {
              "id": 2,
              "name": "Ada tawuran di"
            }
          ]
        }
      ]
    }
  ];

  void openRecord() {
    showAnimatedDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          child: StatefulBuilder(
            builder: (BuildContext context, Function s) {
              return Container(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      maxLines: 4,
                      style: const TextStyle(
                        fontSize: Dimensions.fontSizeDefault
                      ),
                      controller: TextEditingController(text: selectedTextCat),
                      cursorColor: ColorResources.black,
                      onChanged: (val) {
                        s(() {
                          selectedTextCat = val;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: "",
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: getTranslated("DESCRIPTION", context), 
                        labelStyle: const TextStyle(
                          color: ColorResources.black,
                          fontSize: Dimensions.fontSizeDefault
                        ),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: ColorResources.black
                          )
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: ColorResources.black
                          )
                        )
                      )
                    ),

                    Container(
                      margin: EdgeInsets.only(top: 12.0),
                      height: 48.0,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: ListView.builder(
                          itemCount: categories.length,
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int i) {
                            return Container(
                              width: 100.0,
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(5.0),
                              margin: EdgeInsets.only(right: 8.0),
                              decoration: BoxDecoration(
                                color: selectedCatIdx == i 
                                ? ColorResources.purpleDark 
                                : ColorResources.purpleLight,
                                borderRadius: BorderRadius.circular(30.0)
                              ),
                              child: InkWell(
                                onTap: () {
                                  s(() {
                                    selectedCatIdx = i;
                                  });
                                },
                                child: Text(categories[i]["name"],
                                  style: TextStyle(
                                    fontSize: Dimensions.fontSizeSmall,
                                    fontWeight: FontWeight.w500,
                                    color: ColorResources.white
                                  ),
                                ),
                              )
                            );
                          },
                        ),
                      ),
                    ),

                  if(selectedCatIdx != -1)
                    Container(
                      margin: EdgeInsets.only(top: 12.0),
                      height: 48.0,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: ListView.builder(
                          itemCount: categories[selectedCatIdx]["suggestions"][0]["contents"].length,
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int i) {
                            return Container(
                              width: 200.0,
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(5.0),
                              margin: EdgeInsets.only(right: 8.0),
                              decoration: BoxDecoration(
                                color: selectedChildCatIdx == i 
                                ? ColorResources.green 
                                : ColorResources.white,
                                border: Border.all(
                                  color: selectedChildCatIdx == i 
                                  ? ColorResources.transparent 
                                  : ColorResources.green
                                ),
                                borderRadius: BorderRadius.circular(30.0)
                              ),
                              child: InkWell(
                                onTap: () {
                                  s(() {
                                    selectedChildCatIdx = i;
                                    selectedTextCat = categories[selectedCatIdx]["suggestions"][0]["contents"][i]["name"];
                                  });
                                },
                                child: Text(categories[selectedCatIdx]["suggestions"][0]["contents"][i]["name"],
                                  style: TextStyle(
                                    fontSize: Dimensions.fontSizeSmall,
                                    fontWeight: FontWeight.w500,
                                    color: selectedChildCatIdx == i 
                                    ? ColorResources.white
                                    : ColorResources.green
                                  ),
                                ),
                              )
                            );
                          },
                        ),
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(top: 15.0),
                      child: CustomButton(
                        onTap: () async {
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          prefs.setString("selectedTextCat", selectedTextCat);
                          navigationService.pushNav(
                            context,
                            RecordScreen(
                              key: UniqueKey()
                            )
                          );
                        }, 
                        btnColor: ColorResources.redPrimary,
                        isBorder: false,
                        isBoxShadow: false,
                        height: 40.0,
                        isBorderRadius: false,
                        isLoading: isRecordPressed 
                        ? true 
                        : false ,
                        btnTxt: "Record"
                      ),
                    )

                  ],
                ),
              );
            },
          )
        );
      }
    );
  }

  @override 
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state); 
    /* Lifecycle */
    // - Resumed (App in Foreground)
    // - Inactive (App Partially Visible - App not focused)
    // - Paused (App in Background)
    // - Detached (View Destroyed - App Closed)
    if(state == AppLifecycleState.resumed) {
      debugPrint("=== APP RESUME ===");
      bool storageIsDenied = await Permission.storage.isDenied;
      bool microphoneIsDenied = await Permission.microphone.isDenied;
      bool cameraIsDenied = await Permission.camera.isDenied;
      if(cameraIsDenied) {
        ShowSnackbar.snackbar(context, "Please granted permission Camera", "", ColorResources.error);
        await openAppSettings();
      } 
      if(microphoneIsDenied) {
        ShowSnackbar.snackbar(context, "Please granted permission Microphone", "", ColorResources.error);
        await openAppSettings();
      }
      if(storageIsDenied) {
        ShowSnackbar.snackbar(context, "Please granted permission Storage", "", ColorResources.error);
        await openAppSettings();
      }
    }
    if(state == AppLifecycleState.inactive) {
      debugPrint("=== APP INACTIVE ===");
    }
    if(state == AppLifecycleState.paused) {
      debugPrint("=== APP PAUSED ===");
    }
    if(state == AppLifecycleState.detached) {
      debugPrint("=== APP CLOSED ===");
    }
  }

  @override 
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    (() async {   
      bool storageIsDenied = await Permission.storage.isDenied;
      bool microphoneIsDenied = await Permission.microphone.isDenied;
      bool cameraIsDenied = await Permission.camera.isDenied;
      if(cameraIsDenied) {
        ShowSnackbar.snackbar(context, "Please granted permission Camera", "", ColorResources.error);
        await openAppSettings();
      } else {
        await Permission.camera.request();
      }
      if(microphoneIsDenied) {
        ShowSnackbar.snackbar(context, "Please granted permission Microphone", "", ColorResources.error);
        await openAppSettings();
      } else {
        await Permission.microphone.request();
      }
      if(storageIsDenied) {
        ShowSnackbar.snackbar(context, "Please granted permission Storage", "", ColorResources.error);
        await openAppSettings();
      } else {
        await Permission.storage.request();
      }
    })();
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
      if(mounted) {
        inboxProvider.fetchInbox(context);
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
        inboxProvider = context.read<InboxProvider>();
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
                              Consumer<InboxProvider>(
                                builder: (BuildContext context, InboxProvider ip, Widget? child) {
                                  if(ip.inboxStatus == InboxStatus.loading) {
                                    return Container(
                                      margin: const EdgeInsets.only(right: Dimensions.marginSizeDefault),
                                       child: InkWell(
                                        onTap: () {
                                          navigationService.pushNav(context, NotificationScreen(key: UniqueKey()));
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.notifications,
                                            size: 25.0,
                                            color: ColorResources.black,
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  if(ip.inboxStatus == InboxStatus.empty) {
                                    return Container(
                                      margin: const EdgeInsets.only(right: Dimensions.marginSizeDefault),
                                       child: InkWell(
                                        onTap: () {
                                          navigationService.pushNav(context, NotificationScreen(key: UniqueKey()));
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.notifications,
                                            size: 25.0,
                                            color: ColorResources.black,
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  return Container(
                                    margin: const EdgeInsets.only(right: Dimensions.marginSizeDefault),
                                    child: Material(
                                      color: ColorResources.transparent,
                                      child: InkWell(
                                        onTap: () {
                                          navigationService.pushNav(context, NotificationScreen(key: UniqueKey()));
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: ip.totalUnread == 0 
                                          ? Icon(
                                              Icons.notifications,
                                              size: 25.0,
                                              color: ColorResources.black,
                                            )
                                          : Badge(
                                            position: BadgePosition.topEnd(top: 12.0, end: -12),
                                            animationDuration: Duration.zero,
                                            badgeContent: Text(ip.totalUnread.toString(),
                                              style: TextStyle(
                                                fontSize: Dimensions.fontSizeSmall,
                                                color: ColorResources.white
                                              ),
                                            ),
                                            child: Icon(
                                              Icons.notifications,
                                              size: 25.0,
                                              color: ColorResources.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              )
                            ],
                            bottom: PreferredSize(
                              child:  Column(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(left: Dimensions.marginSizeDefault),
                                    alignment: Alignment.centerLeft,
                                    child: const Text("Halo",
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
                       
                    Align(
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
                            zoom: 15.0,
                          ),
                          markers: Set.from(locationProvider.markers),
                          onMapCreated: (GoogleMapController controller) {
                            mapsController.complete(controller);
                            locationProvider.controller = controller;
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