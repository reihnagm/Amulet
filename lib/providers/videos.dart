import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:amulet/data/models/upload/upload.dart';
import 'package:amulet/providers/inbox.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

import 'package:amulet/providers/firebase.dart';
import 'package:amulet/services/notification.dart';
import 'package:amulet/utils/helper.dart';
import 'package:amulet/data/models/fcm/fcm.dart';
import 'package:amulet/providers/auth.dart';
import 'package:amulet/providers/location.dart';
import 'package:amulet/data/models/sos/sos.dart';
import 'package:amulet/views/basewidgets/button/custom.dart';
import 'package:amulet/utils/color_resources.dart';
import 'package:amulet/utils/dimensions.dart';
import 'package:amulet/views/basewidgets/dialog/animated/animated.dart';
import 'package:amulet/views/basewidgets/snackbar/snackbar.dart';
import 'package:amulet/utils/constant.dart';

enum FcmStatus { idle, loading, loaded, empty, error }
enum ListenVStatus { idle, loading, loaded, empty, error }

class VideoProvider with ChangeNotifier {
  final AuthProvider authProvider;
  final LocationProvider locationProvider;
  final SharedPreferences sharedPreferences;
  final NotificationService notificationService;
  VideoProvider({
    required this.authProvider,
    required this.locationProvider,
    required this.sharedPreferences,
    required this.notificationService
  });

  ListenVStatus _listenVStatus = ListenVStatus.idle;
  ListenVStatus get listenVStatus => _listenVStatus;

  FcmStatus _fcmStatus = FcmStatus.idle;
  FcmStatus get fcmStatus => _fcmStatus;

  void setStateListenVStatus(ListenVStatus listenVStatus) {
    _listenVStatus = listenVStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateFcmStatus(FcmStatus fcmStatus) {
    _fcmStatus = fcmStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  int page = 1;

  late VideoPlayerController vid;

  late BitmapDescriptor myCurrentPosition;

  List<Marker> markers = [];

  List<SosData> _sosData = [];
  List<SosData> get sosData => [..._sosData];

  List<FcmData> _fcmData = [];
  List<FcmData> get fcmData => [..._fcmData];

  String _videoUrl = "";
  String get videoUrl => _videoUrl;

  String _thumbnailUrl = "";
  String get thumbnailUrl => _thumbnailUrl;

  void appendSos(dynamic data) {
    _sosData.add(
      SosData(
        uid: data["id"],
        category: data["category"],
        address: data["address"],
        content: data["content"],
        mediaUrl: data["mediaUrl"],
        mediaUrlPhone: data["mediaUrlPhone"],
        duration: data["duration"],
        fullname: data["fullname"],
        lat: data["lat"],
        lng: data["lng"],
        status: data["status"],
        thumbnail: data["thumbnail"],
        userId: data["user_id"],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now()
      )
    );
    setStateListenVStatus(ListenVStatus.loaded);
  }

  Future<void> scrollNextPage(int limit) async {
    page += limit;
    notifyListeners();
  }

  Future<void> getSos(BuildContext context) async {
    try {
      Dio dio = Dio();
      Response res = await dio.get("${AppConstants.baseUrl}/get-sos/${authProvider.getUserId()}?page=$page");
      Map<String, dynamic> resData = res.data;
      SosModel sosModel = SosModel.fromJson(resData);
      _sosData = [];
      List<SosData> sosData = sosModel.data!;
      List<SosData> sosDataAssign = [];
      for (SosData sos in sosData) {
        sosDataAssign.add(SosData(
          address: sos.address,
          category: sos.category,
          content: sos.content,
          createdAt: sos.createdAt,
          duration: sos.duration,
          fullname: sos.fullname,
          lat: sos.lat,
          lng: sos.lng,
          mediaUrl: sos.mediaUrl,
          mediaUrlPhone: sos.mediaUrlPhone,
          status: sos.status,
          thumbnail: sos.thumbnail,
          uid: sos.uid,
          updatedAt: sos.updatedAt,
          userId: sos.userId
        ));
      }
      _sosData = sosDataAssign;
      setStateListenVStatus(ListenVStatus.loaded);
      if(_sosData.isEmpty) {
        setStateListenVStatus(ListenVStatus.empty);
      }
    } on DioError catch(e) {
      if(
        e.response!.statusCode == 400
        || e.response!.statusCode == 401
        || e.response!.statusCode == 402 
        || e.response!.statusCode == 403
        || e.response!.statusCode == 404 
        || e.response!.statusCode == 405 
        || e.response!.statusCode == 500 
        || e.response!.statusCode == 501
        || e.response!.statusCode == 502
        || e.response!.statusCode == 503
        || e.response!.statusCode == 504
        || e.response!.statusCode == 505
      ) {
        ShowSnackbar.snackbar(context, "(${e.response!.statusCode.toString()}) : Internal Server Error", "", ColorResources.error);
      }
      setStateListenVStatus(ListenVStatus.error);
    } catch(e) {
      debugPrint(e.toString());
      setStateListenVStatus(ListenVStatus.error);
    }
  }

  Future<void> getFcm(BuildContext context) async {
    setStateFcmStatus(FcmStatus.loading);
    try {
      Dio dio = Dio();
      Response res = await dio.get('${AppConstants.baseUrl}/get-fcm');
      Map<String, dynamic> data = res.data;
      FcmModel fcmModel = FcmModel.fromJson(data);
      _fcmData = [];
      markers = [];
      List<FcmData> fcmData = fcmModel.data!;
      _fcmData.addAll(fcmData);
      setStateFcmStatus(FcmStatus.loaded);
      for (FcmData fcm in fcmData) {
        markers.add(
          Marker(
            markerId: MarkerId(fcm.uid!),
            position: LatLng(double.parse(fcm.lat!), double.parse(fcm.lng!)),
            infoWindow: InfoWindow(
              title: fcm.fullname
            ),
            icon: fcm.uid == authProvider.getUserId() 
            ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange) 
            : BitmapDescriptor.defaultMarker,
          )
        );
      } 
      if(_fcmData.isEmpty) {
        markers = [];
        setStateFcmStatus(FcmStatus.empty);
      }
    } on DioError catch(e) {
      if(
        e.response!.statusCode == 400
        || e.response!.statusCode == 401
        || e.response!.statusCode == 402 
        || e.response!.statusCode == 403
        || e.response!.statusCode == 404 
        || e.response!.statusCode == 405 
        || e.response!.statusCode == 500 
        || e.response!.statusCode == 501
        || e.response!.statusCode == 502
        || e.response!.statusCode == 503
        || e.response!.statusCode == 504
        || e.response!.statusCode == 505
      ) {
        ShowSnackbar.snackbar(context, "(${e.response!.statusCode.toString()}) : Internal Server Error", "", ColorResources.error);
      }
      setStateFcmStatus(FcmStatus.error);
    } catch(e) {
      debugPrint(e.toString());
      setStateFcmStatus(FcmStatus.error);
    }
  }

  Future<void> initFcm(BuildContext context) async {
    try {
      Dio dio = Dio();
      await dio.post('${AppConstants.baseUrl}/init-fcm',
         data: {  
           "user_id": authProvider.getUserId(),
           "lat": locationProvider.getCurrentLat,
           "lng": locationProvider.getCurrentLng,
           "fcm_secret": await FirebaseMessaging.instance.getToken()
         }
      );
    } on DioError catch(e) {
      if(
        e.response!.statusCode == 400
        || e.response!.statusCode == 401
        || e.response!.statusCode == 402 
        || e.response!.statusCode == 403
        || e.response!.statusCode == 404 
        || e.response!.statusCode == 405 
        || e.response!.statusCode == 500 
        || e.response!.statusCode == 501
        || e.response!.statusCode == 502
        || e.response!.statusCode == 503
        || e.response!.statusCode == 504
        || e.response!.statusCode == 505
      ) {
        ShowSnackbar.snackbar(context, "(${e.response!.statusCode.toString()}) : Internal Server Error", "", ColorResources.error);
      }
    } catch(e) {
      debugPrint(e.toString());
    }
  }

  Future<String?> uploadVideo(BuildContext context, {required File file}) async {
    try {
      Dio dio = Dio();
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          file.path, 
          filename: basename(file.path)
        ),
      });
      Response res = await dio.post("${AppConstants.baseUrlAmulet}/api-amulet/v1/media/upload", data: formData);
      Map<String, dynamic> resData = res.data;
      UploadMediaModel uploadMediaModel = UploadMediaModel.fromJson(resData);
      UploadMediaData uploadMediaData = uploadMediaModel.data!;
      String url = uploadMediaData.path!;
      _videoUrl = url;
      return _videoUrl;
    } on DioError catch(e) {
      if(
        e.response!.statusCode == 400
        || e.response!.statusCode == 401
        || e.response!.statusCode == 402 
        || e.response!.statusCode == 403
        || e.response!.statusCode == 404 
        || e.response!.statusCode == 405 
        || e.response!.statusCode == 500 
        || e.response!.statusCode == 501
        || e.response!.statusCode == 502
        || e.response!.statusCode == 503
        || e.response!.statusCode == 504
        || e.response!.statusCode == 505
      ) {
        ShowSnackbar.snackbar(context, "(${e.response!.statusCode.toString()}) : Internal Server Error", "", ColorResources.error);
      }
    } catch(e) {
      debugPrint(e.toString());
    } 
    return videoUrl;
  }

  Future<String?> uploadVideoPhone(BuildContext context, {required File file}) async {
    try {
      Dio dio = Dio();
      FormData formData = FormData.fromMap({
        "video": await MultipartFile.fromFile(
          file.path, 
          filename: basename(file.path)
        ),
      });
      Response res = await dio.post("${AppConstants.baseUrl}/upload", data: formData);
      String url = res.data["url"]!;
      return url;
    } on DioError catch(e) {
      if(
        e.response!.statusCode == 400
        || e.response!.statusCode == 401
        || e.response!.statusCode == 402 
        || e.response!.statusCode == 403
        || e.response!.statusCode == 404 
        || e.response!.statusCode == 405 
        || e.response!.statusCode == 500 
        || e.response!.statusCode == 501
        || e.response!.statusCode == 502
        || e.response!.statusCode == 503
        || e.response!.statusCode == 504
        || e.response!.statusCode == 505
      ) {
        ShowSnackbar.snackbar(context, "(${e.response!.statusCode.toString()}) : Internal Server Error", "", ColorResources.error);
      }
    } catch(e) {
      debugPrint(e.toString());
    } 
    return videoUrl;
  }

  Future<String?> uploadThumbnail(BuildContext context, {required File file}) async {
    try {
      Dio dio = Dio();
      FormData formData = FormData.fromMap({
        "thumbnail": await MultipartFile.fromFile(
          file.path, 
          filename: basename(file.path)
        ),
      });
      Response res = await dio.post("${AppConstants.baseUrl}/upload-thumbnail", data: formData);
      Map<String, dynamic> resData = res.data;
      String url = resData["url"];
      _thumbnailUrl = url;
      return _thumbnailUrl;
    } on DioError catch(e) {
      if(
        e.response!.statusCode == 400
        || e.response!.statusCode == 401
        || e.response!.statusCode == 402 
        || e.response!.statusCode == 403
        || e.response!.statusCode == 404 
        || e.response!.statusCode == 405 
        || e.response!.statusCode == 500 
        || e.response!.statusCode == 501
        || e.response!.statusCode == 502
        || e.response!.statusCode == 503
        || e.response!.statusCode == 504
        || e.response!.statusCode == 505
      ) {
        ShowSnackbar.snackbar(context, "(${e.response!.statusCode.toString()}) : Internal Server Error", "", ColorResources.error);
      }
    } catch(e) {
      debugPrint(e.toString());
    } 
    return thumbnailUrl;
  }

  Future<void> storeSos(BuildContext context, 
    {
      required String id,
      required String category,
      required String mediaUrl, 
      required String mediaUrlPhone,
      required String content,
      required String lat,
      required String lng,
      required String address,
      required String status,
      required String duration,
      required String thumbnail,
      required String userId,
    }
  ) async {
    try {
      Dio dio = Dio();
      await dio.post('${AppConstants.baseUrl}/store-sos', 
        data: {
          "id": id,
          "category": category,
          "media_url": mediaUrl,
          "media_url_phone": mediaUrlPhone,
          "desc": content,
          "lat": lat,
          "lng": lng,
          "address": address,
          "status": status,
          "duration": duration,
          "thumbnail": thumbnail,
          "user_id": userId,
          "username": authProvider.getUserFullname()
        }
      );

      // List<String> tokens = [];

      // for (FcmData fcm in fcmData) {
      //   if(authProvider.getUserId() != fcm.uid) {
      //     tokens.add(fcm.fcmSecret!);
      //   }
      // }

      // await context.read<FirebaseProvider>().sendNotification(
      //   context, 
      //   title: "Info", 
      //   body:"- Laporan baru telah masuk -",  
      //   tokens: tokens
      // );

      NotificationService.showNotification(
        id: Helper.createUniqueId(),
        title: "Info",
        body: "Rekaman Anda berhasil terkirim kepada Public Service dan Emergency Contact",
        payload: {},
      );

      await context.read<InboxProvider>().insertInbox(context, 
        title: "Info",
        mediaUrl: mediaUrlPhone,
        thumbnail: thumbnailUrl,
        content: "Rekaman Anda berhasil terkirim kepada Public Service dan Emergency Contact",
        type: "info",
        userId: authProvider.getUserId(),
      );
      
      Navigator.of(context).pop();
      
      /* Using Dialog */
      // Navigator.of(context, rootNavigator: false).pop();

      showAnimatedDialog(
        context,
        Builder(
          builder: (ctx) {
            return Stack(
              clipBehavior: Clip.none,
              children: [

                Dialog(
                  backgroundColor: ColorResources.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(70.0),
                      topRight: Radius.circular(70.0)
                    )
                  ),
                  alignment: Alignment.center,
                  child: SizedBox(
                    height: 150.0,
                    child: Container(
                      margin: const EdgeInsets.only(
                        top: Dimensions.marginSizeLarge,
                        left: Dimensions.marginSizeSmall, 
                        right: Dimensions.marginSizeSmall
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Rekaman Anda berhasil terkirim kepada Public Service dan Emergency Contact",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              height: 1.5,
                              fontWeight: FontWeight.w400,
                              fontSize: Dimensions.fontSizeLarge
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: Dimensions.marginSizeDefault),
                            child: CustomButton(
                              onTap: () {
                                Navigator.of(ctx, rootNavigator: true).pop();
                              },
                              height: 30.0,
                              btnColor: ColorResources.redPrimary,
                              btnTextColor: ColorResources.white,
                              isBoxShadow: true,
                              isBorder: false,
                              isBorderRadius: false, 
                              btnTxt: "Ok"
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ),


                Positioned(
                  bottom: 460.0,
                  left: 0.0,
                  right: 0.0,
                  child: Align(
                    alignment: Alignment.center,
                    child: Image.asset('assets/images/amulet-icon-logo.png',
                      width: 100.0,
                      height: 100.0,
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                ),

              ]
            );
          },
        ),
        dismissible: false
      );
    } on DioError catch(e) {
      if(
        e.response!.statusCode == 400
        || e.response!.statusCode == 401
        || e.response!.statusCode == 402 
        || e.response!.statusCode == 403
        || e.response!.statusCode == 404 
        || e.response!.statusCode == 405 
        || e.response!.statusCode == 500 
        || e.response!.statusCode == 501
        || e.response!.statusCode == 502
        || e.response!.statusCode == 503
        || e.response!.statusCode == 504
        || e.response!.statusCode == 505
      ) {
        ShowSnackbar.snackbar(context, "(${e.response!.statusCode.toString()}) : Internal Server Error", "", ColorResources.error);
      }
    } catch(e) {
      debugPrint(e.toString());
    }
  }

}