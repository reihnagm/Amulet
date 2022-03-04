import 'dart:async';

import 'package:badges/badges.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:amulet/providers/network.dart';
import 'package:amulet/views/screens/auth/sign_in.dart';
import 'package:amulet/views/screens/media/record.dart';
import 'package:amulet/localization/language_constraints.dart';
import 'package:amulet/providers/inbox.dart';
import 'package:amulet/providers/videos.dart';
import 'package:amulet/services/navigation.dart';
import 'package:amulet/views/basewidgets/snackbar/snackbar.dart';
import 'package:amulet/providers/location.dart';
import 'package:amulet/views/basewidgets/drawer/drawer.dart';
import 'package:amulet/providers/auth.dart';
import 'package:amulet/views/screens/notification/notification.dart';
import 'package:amulet/utils/color_resources.dart';
import 'package:amulet/utils/dimensions.dart';
import 'package:amulet/views/screens/category/category.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({ Key? key }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  Completer<GoogleMapController> mapsController = Completer();

  late AnimationController controller;

  late AuthProvider authProvider;
  late LocationProvider locationProvider;
  late NetworkProvider networkProvider;
  late InboxProvider inboxProvider;
  late VideoProvider videoProvider;
  late NavigationService navigationService;

  // late TextEditingController categeoryC;

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
    navigationService.pushNav(context,
      RecordScreen(
        key: UniqueKey()
      )
    );
    // showAnimatedDialog(
    //   context: context,
    //   barrierDismissible: true,
    //   builder: (BuildContext context) {
    //     return Dialog(
    //       child: StatefulBuilder(
    //         builder: (BuildContext context, Function s) {
    //           return Container(
    //             padding: EdgeInsets.all(20.0),
    //             child: Column(
    //               mainAxisSize: MainAxisSize.min,
    //               children: [
    //                 TextFormField(
    //                   maxLines: 4,
    //                   style: const TextStyle(
    //                     fontSize: Dimensions.fontSizeDefault
    //                   ),
    //                   controller: categeoryC,
    //                   cursorColor: ColorResources.black,
    //                   onChanged: (val) {
    //                     s(() {
    //                       selectedTextCat = val;
    //                     });
    //                   },
    //                   decoration: InputDecoration(
    //                     hintText: "",
    //                     floatingLabelBehavior: FloatingLabelBehavior.always,
    //                     labelText: getTranslated("DESCRIPTION", context), 
    //                     labelStyle: const TextStyle(
    //                       color: ColorResources.black,
    //                       fontSize: Dimensions.fontSizeDefault
    //                     ),
    //                     border: const OutlineInputBorder(
    //                       borderSide: BorderSide(
    //                         color: ColorResources.black
    //                       )
    //                     ),
    //                     focusedBorder: const OutlineInputBorder(
    //                       borderSide: BorderSide(
    //                         color: ColorResources.black
    //                       )
    //                     )
    //                   )
    //                 ),

    //                 Container(
    //                   margin: EdgeInsets.only(top: 12.0),
    //                   height: 48.0,
    //                   child: Padding(
    //                     padding: const EdgeInsets.all(5.0),
    //                     child: ListView.builder(
    //                       itemCount: categories.length,
    //                       scrollDirection: Axis.horizontal,
    //                       shrinkWrap: true,
    //                       itemBuilder: (BuildContext context, int i) {
    //                         return Container(
    //                           width: 100.0,
    //                           alignment: Alignment.center,
    //                           padding: EdgeInsets.all(5.0),
    //                           margin: EdgeInsets.only(right: 8.0),
    //                           decoration: BoxDecoration(
    //                             color: selectedCatIdx == i 
    //                             ? ColorResources.purpleDark 
    //                             : ColorResources.purpleLight,
    //                             borderRadius: BorderRadius.circular(30.0)
    //                           ),
    //                           child: InkWell(
    //                             onTap: () {
    //                               s(() {
    //                                 selectedCatIdx = i;
    //                               });
    //                             },
    //                             child: Text(categories[i]["name"],
    //                               style: TextStyle(
    //                                 fontSize: Dimensions.fontSizeSmall,
    //                                 fontWeight: FontWeight.w500,
    //                                 color: ColorResources.white
    //                               ),
    //                             ),
    //                           )
    //                         );
    //                       },
    //                     ),
    //                   ),
    //                 ),

    //               if(selectedCatIdx != -1)
    //                 Container(
    //                   margin: EdgeInsets.only(top: 12.0),
    //                   height: 48.0,
    //                   child: Padding(
    //                     padding: const EdgeInsets.all(5.0),
    //                     child: ListView.builder(
    //                       itemCount: categories[selectedCatIdx]["suggestions"][0]["contents"].length,
    //                       scrollDirection: Axis.horizontal,
    //                       shrinkWrap: true,
    //                       itemBuilder: (BuildContext context, int i) {
    //                         return Container(
    //                           width: 200.0,
    //                           alignment: Alignment.center,
    //                           padding: EdgeInsets.all(5.0),
    //                           margin: EdgeInsets.only(right: 8.0),
    //                           decoration: BoxDecoration(
    //                             color: selectedChildCatIdx == i 
    //                             ? ColorResources.green 
    //                             : ColorResources.white,
    //                             border: Border.all(
    //                               color: selectedChildCatIdx == i 
    //                               ? ColorResources.transparent 
    //                               : ColorResources.green
    //                             ),
    //                             borderRadius: BorderRadius.circular(30.0)
    //                           ),
    //                           child: InkWell(
    //                             onTap: () {
    //                               s(() {
    //                                 selectedChildCatIdx = i;
    //                                  categeoryC.text = categories[selectedCatIdx]["suggestions"][0]["contents"][i]["name"];
    //                                 selectedTextCat = categories[selectedCatIdx]["suggestions"][0]["contents"][i]["name"];
    //                               });
    //                             },
    //                             child: Text(categories[selectedCatIdx]["suggestions"][0]["contents"][i]["name"],
    //                               style: TextStyle(
    //                                 fontSize: Dimensions.fontSizeSmall,
    //                                 fontWeight: FontWeight.w500,
    //                                 color: selectedChildCatIdx == i 
    //                                 ? ColorResources.white
    //                                 : ColorResources.green
    //                               ),
    //                             ),
    //                           )
    //                         );
    //                       },
    //                     ),
    //                   ),
    //                 ),

    //                 Container(
    //                   margin: EdgeInsets.only(top: 15.0),
    //                   child: CustomButton(
    //                     onTap: () async {
    //                       SharedPreferences prefs = await SharedPreferences.getInstance();
    //                       prefs.setString("selectedTextCat", selectedTextCat);
    //                       navigationService.pushNav(context,
    //                         RecordScreen(
    //                           key: UniqueKey()
    //                         )
    //                       );
    //                     }, 
    //                     btnColor: ColorResources.redPrimary,
    //                     isBorder: false,
    //                     isBoxShadow: false,
    //                     height: 40.0,
    //                     isBorderRadius: false,
    //                     isLoading: isRecordPressed 
    //                     ? true 
    //                     : false ,
    //                     btnTxt: "Record"
    //                   ),
    //                 )

    //               ],
    //             ),
    //           );
    //         },
    //       )
    //     );
    //   }
    // );
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
      bool contactsIsDenied = await Permission.contacts.isDenied;
      bool storageIsDenied = await Permission.storage.isDenied;
      bool microphoneIsDenied = await Permission.microphone.isDenied;
      bool cameraIsDenied = await Permission.camera.isDenied;
      
      if(contactsIsDenied) {
        PermissionStatus permissionStatus = await Permission.contacts.request();
        if(permissionStatus == PermissionStatus.denied) {
          ShowSnackbar.snackbar(context, "Please granted permission Contacts", "", ColorResources.error);
          await openAppSettings();
        }
      } 
      if(microphoneIsDenied) {
        PermissionStatus permissionStatus = await Permission.microphone.request();
        if(permissionStatus == PermissionStatus.denied) { 
          await openAppSettings();
          ShowSnackbar.snackbar(context, "Please granted permission Microphone", "", ColorResources.error);
        }
      } 
      if(storageIsDenied) {
        PermissionStatus permissionStatus = await Permission.storage.request();
        if(permissionStatus == PermissionStatus.denied) {
          ShowSnackbar.snackbar(context, "Please granted permission Storage", "", ColorResources.error);
          await openAppSettings();
        }
      } 
      if(cameraIsDenied) {
        PermissionStatus permissionStatus = await Permission.camera.request();
        if(permissionStatus == PermissionStatus.denied) {
          ShowSnackbar.snackbar(context, "Please granted permission Camera", "", ColorResources.error);
          await openAppSettings();
        }
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
    WidgetsBinding.instance!.addObserver(this);
    controller = AnimationController(vsync: this, duration: Duration(seconds: 1));
    controller.addListener(() {
      setState(() {});
    });
    controller.addStatusListener((status) {
      if(status == AnimationStatus.completed) {
        Future.delayed(Duration(seconds: 1), () {
          navigationService.pushNav(context,
            RecordScreen(
              key: UniqueKey()
            )
          );
          controller.reverse();
        });
      }
    }); 
    // categeoryC = TextEditingController(text: selectedTextCat); 
    if(mounted) {
      setUpTimeFetch();
    }
    Future.delayed((Duration.zero), () {
      if(mounted) {
        locationProvider.getCurrentPosition(context);
      }
      if(mounted) {
        videoProvider.initFcm(context);
      }
      if(mounted) {
        videoProvider.getFcm(context);
      }
      if(mounted) {
        inboxProvider.getInbox(context);
      }
      if(mounted) {
        networkProvider.checkConnection(context);
      }
    });
  }

  setUpTimeFetch() {
    Timer.periodic(const Duration(milliseconds: 1000), (_) {
      if(mounted) {
        inboxProvider.getInbox(context);
      }
    });
  }

  @override 
  void dispose() {
    // categeoryC.dispose();
    super.dispose();
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
        networkProvider = context.read<NetworkProvider>();
        navigationService = NavigationService();
        return Scaffold(
          resizeToAvoidBottomInset: false,
          key: globalKey,
          drawer: DrawerWidget(key: UniqueKey()),
          backgroundColor: ColorResources.backgroundColor,
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
                          videoProvider.getFcm(context);
                          inboxProvider.getInbox(context);
                        });
                      },
                      child: CustomScrollView(
                        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                        slivers: [
                          
                          SliverAppBar(
                            toolbarHeight: 80.0,
                            backgroundColor: ColorResources.transparent,
                            title: Image.asset('assets/images/logo.png',
                              width: 65.0,
                              height: 65.0,
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
                                          if(authProvider.isLoggedIn()!) {
                                            navigationService.pushNav(context, NotificationScreen(key: UniqueKey()));
                                          } else {
                                            navigationService.pushNav(context, SignInScreen(key: UniqueKey()));
                                          }
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
                                          if(authProvider.isLoggedIn()!) {
                                            navigationService.pushNav(context, NotificationScreen(key: UniqueKey()));
                                          } else {
                                            navigationService.pushNav(context, SignInScreen(key: UniqueKey()));
                                          }
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
                                          if(authProvider.isLoggedIn()!) {
                                            navigationService.pushNav(context, NotificationScreen(key: UniqueKey()));
                                          } else {
                                            navigationService.pushNav(context, SignInScreen(key: UniqueKey()));
                                          }
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
                              child: authProvider.isLoggedIn()! ? Column(
                                mainAxisSize: MainAxisSize.min,
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
                                    child: Text(authProvider.getUserFullname()!,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: Dimensions.fontSizeOverLarge
                                      ),
                                    ),
                                  )
                                ],
                              ) : SizedBox(),
                              preferredSize: authProvider.isLoggedIn()! 
                              ? const Size.fromHeight(60.0) 
                              : const Size.fromHeight(0.0) 
                            ),
                          ),
                        ],
                      ),
                    ),

                    if(networkProvider.connectionStatus == ConnectionStatus.offInternet) 
                      Center(
                        child: SpinKitThreeBounce(
                          size: 20.0,
                          color: Colors.black87,
                        ),
                      ),
                         
                    Consumer<LocationProvider>(
                      builder: (BuildContext context, LocationProvider lp, Widget? child) {
                        if(lp.locationStatus == LocationStatus.loading) {
                          return Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              width: double.infinity,
                              margin: EdgeInsets.only(
                                top: authProvider.isLoggedIn()!
                                ? 160.0 
                                : 80.0
                              ),
                              child: GoogleMap(
                                mapType: MapType.normal,
                                gestureRecognizers: {}..add(Factory<EagerGestureRecognizer>(() => EagerGestureRecognizer())),
                                myLocationEnabled: false,
                                initialCameraPosition: CameraPosition(
                                  target: LatLng(
                                    -6.175392, 
                                    106.827153
                                  ),
                                  zoom: 15.0,
                                ),
                                onMapCreated: (GoogleMapController controller) {
                                  mapsController.complete(controller);
                                  lp.controller = controller;
                                },
                              ),
                            )
                          );
                        }
                        if(lp.locationStatus == LocationStatus.error) {
                          return Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              width: double.infinity,
                              margin: EdgeInsets.only(
                                top: authProvider.isLoggedIn()!
                                ? 160.0 
                                : 80.0
                              ),
                              child: GoogleMap(
                                mapType: MapType.normal,
                                gestureRecognizers: {}..add(Factory<EagerGestureRecognizer>(() => EagerGestureRecognizer())),
                                myLocationEnabled: false,
                                initialCameraPosition: CameraPosition(
                                  target: LatLng(
                                    -6.175392, 
                                    106.827153
                                  ),
                                  zoom: 15.0,
                                ),
                                onMapCreated: (GoogleMapController controller) {
                                  mapsController.complete(controller);
                                  lp.controller = controller;
                                },
                              ),
                            )
                          );
                        }
                        return Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(
                              top: authProvider.isLoggedIn()! 
                              ? 160.0 
                              : 80.0
                            ),
                            child: GoogleMap(
                              mapType: MapType.normal,
                              gestureRecognizers: {}..add(Factory<EagerGestureRecognizer>(() => EagerGestureRecognizer())),
                              myLocationEnabled: false,
                              initialCameraPosition: CameraPosition(
                                target: LatLng(
                                  lp.getCurrentLat, 
                                  lp.getCurrentLng
                                ),
                                zoom: 15.0,
                              ),
                              markers: Set.from(lp.markers),
                              onMapCreated: (GoogleMapController controller) {
                                mapsController.complete(controller);
                                lp.controller = controller;
                              },
                            ),
                          )
                        );
                      },
                    ),

                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        margin: EdgeInsets.only(
                          top: authProvider.isLoggedIn()!
                          ? 175.0
                          : 100.0,
                          left: Dimensions.marginSizeDefault, 
                          right: Dimensions.marginSizeDefault
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: ColorResources.redPrimary
                        ),
                        child: InkWell(
                          onTap: () { 
                            if(authProvider.isLoggedIn()!) {
                              navigationService.pushNav(context,  CategoryScreen(key: UniqueKey()));
                            } else {
                              navigationService.pushNav(context,  SignInScreen(key: UniqueKey()));
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(getTranslated("CATEGORY", context),
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
                      child: 
                      
                      Container(
                        margin: const EdgeInsets.only(
                          bottom: 100.0,
                        ),
                        child: GestureDetector(
                          // onTapDown: (_) {
                          //   if(controller.status == AnimationStatus.completed) {
                          //     controller.reverse();
                          //   } else {
                          //     controller.forward();
                          //   }
                          // },
                          // onTapUp: (_) {
                          //   if (controller.status == AnimationStatus.forward) {
                          //     controller.reverse();
                          //   }
                          // },
                          onLongPress: () {
                            if(authProvider.isLoggedIn()!) {
                              controller.forward();
                            } else {
                              navigationService.pushNav(context, SignInScreen(key: UniqueKey()));
                            }
                          },
                          child: Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.center,
                            children: [
                              Positioned(
                                top: 0.0,
                                left: 22.0,
                                right: 22.0,
                                bottom: 0.0,
                                child: CircularProgressIndicator(
                                  value: controller.value,
                                  valueColor: AlwaysStoppedAnimation<Color>(ColorResources.redPrimary.withOpacity(0.8)),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.all(12.0),
                                child: ElevatedButton(
                                  onPressed: () {},
                                  child: Text(getTranslated("HOLD_TO_SEND_ALERT", context),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: Dimensions.fontSizeDefault,
                                      color: ColorResources.white
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    shape: CircleBorder(),
                                    padding: EdgeInsets.all(40),
                                    primary: ColorResources.redPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      //   child: ConfirmationSlider(
                      //     foregroundShape: BorderRadius.circular(10.0),
                      //     backgroundShape:BorderRadius.circular(10.0) ,
                      //     foregroundColor: ColorResources.redPrimary,
                      //     text: "Slide to Send Alert",
                      //     height: 60.0,
                      //     onConfirmation: () => openRecord()
                      //   ),
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