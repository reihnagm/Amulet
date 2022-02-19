import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:video_compress/video_compress.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:panic_button/providers/network.dart';
import 'package:panic_button/providers/auth.dart';
import 'package:panic_button/services/socket.dart';
import 'package:panic_button/services/video.dart';
import 'package:panic_button/providers/location.dart';
import 'package:panic_button/providers/videos.dart';
import 'package:panic_button/utils/box_shadow.dart';
import 'package:panic_button/utils/color_resources.dart';
import 'package:panic_button/utils/dimensions.dart';
import 'package:panic_button/views/basewidgets/button/custom.dart';
import 'package:panic_button/views/basewidgets/drawer/drawer.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({ Key? key }) : super(key: key);

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  Completer<GoogleMapController> mapsController = Completer();
  int selectedIndex = -1;

  bool isCompressed = false;
  bool loading = false;
  Uint8List? thumbnail;
  File? fileThumbnail;
  File? file;
  MediaInfo? videoCompressInfo;
  Duration? duration;
  double? progress;
  int? videoSize;

  late TextEditingController msgC;

  late AuthProvider authProvider;
  late VideoProvider videoProvider;
  late LocationProvider locationProvider;

  List<Map<String, dynamic>> categories = [
    {
      "id": 1,
      "name": "Kecelakaan",
      "image": "assets/images/accident.png"
    },
    {
      "id": 2,
      "name": "Pencurian",
      "image": "assets/images/thief.png"
    },
    {
      "id": 3,
      "name": "Kebakaran",
      "image": "assets/images/fire.png"
    },
    {
      "id": 4,
      "name": "Bencana Alam",
      "image": "assets/images/disaster.png"
    },
    {
      "id": 5,
      "name": "Perampokan",
      "image": "assets/images/rape.png"
    },
    {
      "id": 6,
      "name": "Kerusuhan",
      "image": "assets/images/noise.png"
    }
  ];

  Future<void> uploadVid(Function s) async {
    try { 
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.video,
      );
      File xfile = File(result!.files.single.path!);
      File f = File(xfile.path);
      if(mounted) {
        s(() {
          isCompressed = true;
          file = File(f.path);
        });
      }
      Uint8List thumbnailGenerated = await VideoServices.generateByteThumbnail(file!);
      int sizeVideo = await VideoServices.getVideoSize(file!);
      await GallerySaver.saveVideo(file!.path);
      MediaInfo? info = await VideoServices.compressVideo(file!);
      if(info != null) {
        if(mounted) {
          s(() {
            thumbnail = thumbnailGenerated;
            videoSize = sizeVideo;
            isCompressed = false;
            videoCompressInfo = info;
            duration = Duration(microseconds: (videoCompressInfo!.duration! * 1000).toInt());
          });
        }
        File(file!.path).deleteSync(); 
      } else {
        isCompressed = false;
        videoCompressInfo = null;
        VideoCompress.cancelCompression();
      } 
    } catch(e) {
      debugPrint(e.toString());
    }
  }
  
  @override 
  void initState() {
    super.initState();
    msgC = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(mounted) {
        SocketServices.shared.connect(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return buildUI();
  }

  Widget buildUI() {
    return Builder(
      builder: (BuildContext context) {
        authProvider = context.read<AuthProvider>();
        videoProvider = context.read<VideoProvider>();
        locationProvider = context.read<LocationProvider>();
        return Scaffold(
          resizeToAvoidBottomInset: false,
          key: globalKey,
          drawer: DrawerWidget(key: UniqueKey()),
          backgroundColor:ColorResources.white,
          body: SafeArea(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Stack(
                  fit: StackFit.expand,
                  children: [

                    RefreshIndicator(
                      backgroundColor: ColorResources.white,
                      color: ColorResources.redPrimary,
                      onRefresh: () {
                        return Future.sync(() {});
                      },
                      child: Consumer<NetworkProvider>(
                        builder: (BuildContext context, NetworkProvider networkProvider, Widget? child) {
                          return CustomScrollView(
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
                                    child: const Icon(
                                      Icons.notifications,
                                      size: 25.0,
                                      color: ColorResources.black,
                                    ),
                                  )
                                ],
                                bottom: PreferredSize(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(left: Dimensions.marginSizeDefault),
                                        alignment: Alignment.centerLeft,
                                        child: const Text("Hello",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: Dimensions.fontSizeLarge
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
                                            fontSize: Dimensions.fontSizeOverLarge
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  preferredSize: const Size.fromHeight(60.0) 
                                ),
                              ),

                            if(networkProvider.connectionStatus == ConnectionStatus.offInternet)
                              const SliverFillRemaining(
                                child: Center(
                                  child: SpinKitThreeBounce(
                                    size: 20.0,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                     
                            if(networkProvider.connectionStatus == ConnectionStatus.onInternet)
                              SliverToBoxAdapter(
                                child: Container(
                                  margin: const EdgeInsets.only(
                                    top: 40.0, 
                                    bottom: 40.0,
                                    left: Dimensions.marginSizeDefault, 
                                    right: Dimensions.marginSizeDefault
                                  ),
                                  padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: ColorResources.white,
                                    boxShadow: boxShadow
                                  ),
                                  child: GridView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                      maxCrossAxisExtent: 200,
                                      childAspectRatio: 4 / 4,
                                      crossAxisSpacing: 30,
                                      mainAxisSpacing: 35,
                                    ),
                                    itemCount: categories.length,
                                    itemBuilder: (BuildContext context, int i) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          color: selectedIndex == i 
                                          ? ColorResources.redPrimary 
                                          : ColorResources.backgroundCategory,
                                          boxShadow: boxShadow,
                                          borderRadius: BorderRadius.circular(20.0)
                                        ),
                                        child: Material(
                                          color: ColorResources.transparent,
                                          borderRadius: BorderRadius.circular(20.0),
                                          child: InkWell(
                                            borderRadius: BorderRadius.circular(20.0),
                                            onTap: () {
                                              setState(() => selectedIndex = i);
                                              showModalBottomSheet(
                                                isScrollControlled: true,
                                                isDismissible: false,
                                                context: context, 
                                                shape: const RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(20.0),
                                                    topRight: Radius.circular(20.0)
                                                  )
                                                ),
                                                builder: (BuildContext context) {
                                                  return StatefulBuilder(
                                                    builder: (BuildContext context, Function s) {
                                                      return  LayoutBuilder(
                                                        builder: (BuildContext context, BoxConstraints constraints) {
                                                          return Padding(
                                                            padding: MediaQuery.of(context).viewInsets,
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(16.0),
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                mainAxisSize: MainAxisSize.min,
                                                                children: [
                                                                  Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    mainAxisSize: MainAxisSize.min,
                                                                    children: [
                                                                      Text(categories[i]["name"],
                                                                        style: const TextStyle(
                                                                          fontWeight: FontWeight.w500,
                                                                          fontSize: Dimensions.fontSizeLarge
                                                                        ),
                                                                      ),
                                                                      const SizedBox(height: 10.0),
                                                                      Row(
                                                                        children: [
                                                                          const Expanded(
                                                                            flex: 20,
                                                                            child: Text("Tanggal",
                                                                              style: TextStyle(
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize: Dimensions.fontSizeDefault
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          const Expanded(
                                                                            flex: 6,
                                                                            child: Text(":",
                                                                              style: TextStyle(
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize: Dimensions.fontSizeDefault
                                                                              ),
                                                                            )
                                                                          ),
                                                                          Expanded(
                                                                            flex: 100,
                                                                            child: Text(DateFormat('M/d/y').format(DateTime.now()),
                                                                              style: const TextStyle(
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize: Dimensions.fontSizeDefault
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(height: 10.0),
                                                                      Row(
                                                                        children: const [
                                                                          Expanded(
                                                                            flex: 20,
                                                                            child: Text("Lokasi",
                                                                              style: TextStyle(
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize: Dimensions.fontSizeDefault
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Expanded(
                                                                            flex: 6,
                                                                            child: Text(":",
                                                                              style: TextStyle(
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize: Dimensions.fontSizeDefault
                                                                              ),
                                                                            )
                                                                          ),
                                                                          Expanded(
                                                                            flex: 100,
                                                                            child: Text("Jl. Kemang Timur No.1 RT.003/RW.002",
                                                                              style: TextStyle(
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize: Dimensions.fontSizeDefault
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      )
                                                                    ],
                                                                  ),
                                                              
                                                                  Container(
                                                                    margin: const EdgeInsets.only(top: Dimensions.marginSizeLarge),
                                                                    child: TextField(
                                                                      controller: msgC,
                                                                      cursorColor: ColorResources.black,
                                                                      style: const TextStyle(
                                                                        fontSize: Dimensions.fontSizeDefault
                                                                      ),
                                                                      decoration: const InputDecoration(
                                                                        labelText: "Pesan",
                                                                        labelStyle: TextStyle(
                                                                          fontWeight: FontWeight.w500,
                                                                          color: ColorResources.black,
                                                                          fontSize: Dimensions.fontSizeLarge
                                                                        ),
                                                                        floatingLabelBehavior: FloatingLabelBehavior.always,
                                                                        border: OutlineInputBorder(),
                                                                        focusedBorder: OutlineInputBorder(),
                                                                        errorBorder: OutlineInputBorder(),
                                                                        enabledBorder: OutlineInputBorder(),
                                                                        disabledBorder: OutlineInputBorder(),
                                                                        focusedErrorBorder: OutlineInputBorder()
                                                                      ),
                                                                      maxLines: 4,
                                                                    ),
                                                                  ),

                                                                  isCompressed ? Text("Lagi Compress") : Text(""),

                                                                  Container(
                                                                    margin: const EdgeInsets.only(top: Dimensions.marginSizeLarge),
                                                                    child: Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      mainAxisSize: MainAxisSize.max,
                                                                      children: [
                                                                        Expanded(
                                                                          flex: 6,
                                                                          child: Row(
                                                                            children: [
                                                                              Image.asset("assets/images/sound-record.png",
                                                                                width: 30.0,
                                                                                height: 30.0,
                                                                              ),
                                                                              const SizedBox(width: 14.0),
                                                                              Image.asset("assets/images/camera.png",
                                                                                width: 30.0,
                                                                                height: 30.0,
                                                                              ),
                                                                              const SizedBox(width: 14.0),
                                                                              InkWell(
                                                                                onTap: () => uploadVid(s),
                                                                                child: Image.asset("assets/images/video-record.png",
                                                                                  width: 30.0,
                                                                                  height: 30.0,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          flex: 3,
                                                                          child: Column(
                                                                            mainAxisSize: MainAxisSize.min,
                                                                            children: [
                                                                              CustomButton(
                                                                                onTap: () {
                                                                                  Navigator.of(context).pop();
                                                                                }, 
                                                                                height: 30.0,
                                                                                isBorder: false,
                                                                                isBorderRadius: false,
                                                                                isBoxShadow: true,
                                                                                btnColor: ColorResources.redPrimary,
                                                                                btnTextColor: ColorResources.white,
                                                                                btnTxt: "Batal"
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        const SizedBox(width: 15.0),
                                                                        Expanded(
                                                                          flex: 3,
                                                                          child: Column(
                                                                            mainAxisSize: MainAxisSize.min,
                                                                            children: [
                                                                              CustomButton(
                                                                                onTap: () async {
                                                                                  s(() {
                                                                                    loading = true;
                                                                                  });
                                                                                  try {
                                                                                    String? mediaUrl = await videoProvider.uploadVideo(context, file: videoCompressInfo!.file!);
                                                                                    File fileThumbnail = await VideoCompress.getFileThumbnail(videoCompressInfo!.file!.path); 
                                                                                    String? thumbnailUploaded = await videoProvider.uploadThumbnail(context, file: fileThumbnail); 
                                                                                    SocketServices.shared.sendMsg(
                                                                                      id: const Uuid().v4(),
                                                                                      content: msgC.text,
                                                                                      mediaUrl: mediaUrl!,
                                                                                      category: categories[i]["name"],
                                                                                      lat: locationProvider.getCurrentLat,
                                                                                      lng: locationProvider.getCurrentLng,
                                                                                      address: locationProvider.getCurrentNameAddress,
                                                                                      status: "sent",
                                                                                      duration: (Duration(microseconds: (videoCompressInfo!.duration! * 1000).toInt())).toString(),
                                                                                      thumbnail: thumbnailUploaded!,
                                                                                      userId: authProvider.getUserId()
                                                                                    );
                                                                                    await videoProvider.insertSos(context,
                                                                                      id: const Uuid().v4(), 
                                                                                      content: msgC.text,
                                                                                      mediaUrl: mediaUrl, 
                                                                                      category: categories[i]["name"],
                                                                                      lat: locationProvider.getCurrentLat.toString(),
                                                                                      lng: locationProvider.getCurrentLng.toString(),
                                                                                      address: locationProvider.getCurrentNameAddress,
                                                                                      status: "sent",
                                                                                      duration: (Duration(microseconds: (videoCompressInfo!.duration! * 1000).toInt())).toString(),
                                                                                      thumbnail: thumbnailUploaded,
                                                                                      userId: authProvider.getUserId(),
                                                                                    );
                                                                                    s(() {
                                                                                      loading = false;
                                                                                    });
                                                                                  } catch(e) {
                                                                                    debugPrint(e.toString());
                                                                                  }
                                                                                }, 
                                                                                height: 30.0,
                                                                                isBorder: false,
                                                                                isBorderRadius: false,
                                                                                isBoxShadow: true,
                                                                                btnColor: ColorResources.blue,
                                                                                btnTextColor: ColorResources.white,
                                                                                loadingColor: ColorResources.redPrimary,
                                                                                isLoading: loading 
                                                                                ? true 
                                                                                : false,
                                                                                btnTxt: "Kirim"
                                                                              )
                                                                            ],
                                                                          ),
                                                                        )
                                                                      ],
                                                                    )
                                                                  )
                                                              
                                                              
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      );     
                                                    },
                                                  );
                                                } 
                                              );
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  
                                                  Container(
                                                    alignment: Alignment.center,
                                                    child: Image.asset(categories[i]["image"],
                                                      width: 90.0,
                                                      height: 90.0,
                                                      alignment: Alignment.center,
                                                    ),
                                                  ),
                                                                            
                                                  Container(
                                                    margin: const EdgeInsets.only(top: Dimensions.marginSizeDefault),
                                                    alignment: Alignment.center,
                                                    child: Text(categories[i]["name"].toString(),
                                                      style: TextStyle(
                                                        color: selectedIndex == i 
                                                        ? ColorResources.white 
                                                        : ColorResources.black,
                                                        fontSize: Dimensions.fontSizeDefault,
                                                        fontWeight: FontWeight.bold
                                                      ),
                                                    ),
                                                  )
                                                                            
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    
                                    }
                                  ),
                                ),
                              ),

                            ],
                          );
                        },
                      )
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