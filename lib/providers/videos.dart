import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:panic_button/data/models/sos/sos.dart';
import 'package:panic_button/views/basewidgets/button/custom.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:panic_button/utils/color_resources.dart';
import 'package:panic_button/utils/dimensions.dart';
import 'package:panic_button/views/basewidgets/dialog/animated/animated.dart';
import 'package:panic_button/views/basewidgets/snackbar/snackbar.dart';
import 'package:panic_button/utils/constant.dart';

enum ListenVStatus { idle, loading, loaded, empty, error }

class VideoProvider with ChangeNotifier {
  final SharedPreferences sharedPreferences;
  VideoProvider({
    required this.sharedPreferences
  });

  ListenVStatus _listenVStatus = ListenVStatus.idle;
  ListenVStatus get listenVStatus => _listenVStatus;

  void setStateListenVStatus(ListenVStatus listenVStatus) {
    _listenVStatus = listenVStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  int page = 1;

  List<SosData> _sosData = [];
  List<SosData> get sosData => [..._sosData];

  String _videoUrl = "";
  String get videoUrl => _videoUrl;

  String _thumbnailUrl = "";
  String get thumbnailUrl => _thumbnailUrl;

  String _fcm = "";
  String get fcm => _fcm;

  Future<void> fetchSos(BuildContext context) async {
    setStateListenVStatus(ListenVStatus.loading);
    try {
      Dio dio = Dio();
      Response res = await dio.get("${AppConstants.baseUrl}/fetch-sos?page=$page");
      setStateListenVStatus(ListenVStatus.loaded);
      Map<String, dynamic> resData = res.data;
      SosModel sosModel = SosModel.fromJson(resData);
      List<SosData> sosData = sosModel.data!;
      _sosData = sosData;
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

  Future<String?> fetchFcm(BuildContext context) async {
    try {
      Dio dio = Dio();
      Response res = await dio.get('${AppConstants.baseUrl}/fetch-fcm');
      Map<String, dynamic> data = res.data;
      String f = data["fcm_secret"];
      _fcm  = f;
      return _fcm;
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
    return fcm;
  }

  Future<String?> uploadVideo(BuildContext context, {required File file}) async {
    try {
      Dio dio = Dio();
      FormData formData = FormData.fromMap({
        "video": await MultipartFile.fromFile(
          file.path, 
          filename: basename(file.path)
        ),
      });
      Response res = await dio.post("${AppConstants.baseUrl}/upload", data: formData);
      Map<String, dynamic> resData = res.data;
      String url = resData["url"];
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

  Future<void> insertSos(BuildContext context, 
    {
      required String id,
      required String category,
      required String mediaUrl, 
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
      await dio.post('${AppConstants.baseUrl}/insert-sos', 
        data: {
          "id": id,
          "category": category,
          "media_url": mediaUrl,
          "desc": content,
          "lat": lat,
          "lng": lng,
          "address": address,
          "status": status,
          "duration": duration,
          "thumbnail": thumbnail,
          "user_id": userId
        }
      );
      
      Navigator.of(context).pop();

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
                          const Text("Rekaman berhasil terkirim kepada Public Service dan Emergency Contact",
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