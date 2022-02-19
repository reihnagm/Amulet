import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:custom_timer/custom_timer.dart';
import 'package:panic_button/providers/auth.dart';

import 'package:panic_button/providers/location.dart';
import 'package:panic_button/providers/network.dart';
import 'package:panic_button/providers/videos.dart';
import 'package:panic_button/services/socket.dart';
import 'package:panic_button/services/video.dart';
import 'package:panic_button/utils/color_resources.dart';
import 'package:panic_button/utils/dimensions.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';


class RecordScreen extends StatefulWidget {
  final String category;
  final String content;
  const RecordScreen({
    this.category = "-",
    this.content = "-",
    Key? key
  }) : super(key: key);

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> with WidgetsBindingObserver, TickerProviderStateMixin {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  late AuthProvider authProvider;
  late LocationProvider locationProvider;
  late Subscription? subscription;
  late VideoProvider videoProvider;
  late NetworkProvider networkProvider;

  final double _minAvailableZoom = 1.0;
  final double _maxAvailableZoom = 1.0;

  Timer? timer;

  dynamic currentBackPressTime;
  bool isLoading = false;
  bool isCompressed = false;
  Uint8List? thumbnail;
  File? fileThumbnail;
  File? file;
  MediaInfo? videoCompressInfo;
  Duration? duration;
  double? progress;
  int? videoSize;
  CameraController? controller;
  XFile? videoFile;
  VideoPlayerController? videoController;

  double _baseScale = 1.0;
  double _currentScale = 1.0;

  int _pointers = 0;

  Future<void> onInitCamera() async {
    if (controller != null) {
      await controller!.dispose();
    }

    CameraController cameraController = CameraController(
      const CameraDescription(
        name: "0", 
        lensDirection: CameraLensDirection.back, 
        sensorOrientation: 90,
      ),
      kIsWeb ? ResolutionPreset.max : ResolutionPreset.medium,
      enableAudio: true,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    controller = cameraController;

    cameraController.addListener(() {
      if (mounted) setState(() {});
      if (cameraController.value.hasError) {
        showInSnackBar('Camera error ${cameraController.value.errorDescription}');
      }
    });

    try {
      await cameraController.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }
    if (mounted) {
      setState(() {});
    }
  }

  void showInSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void onViewFinderTap(TapDownDetails details, BoxConstraints constraints) {
    if (controller == null) {
      return;
    }

    CameraController cameraController = controller!;

    Offset offset = Offset(
      details.localPosition.dx / constraints.maxWidth,
      details.localPosition.dy / constraints.maxHeight,
    );
    cameraController.setExposurePoint(offset);
    cameraController.setFocusPoint(offset);
  }

  Future<XFile?> onStopButtonPressed(BuildContext ctx) async {
    try {
      XFile? xfile = await stopVideoRecording();
      if (xfile != null) {
        File f = File(xfile.path);
        if(mounted) {
          setState(() {
            isCompressed = true;
            file = File(f.path);
          });
        }
        File fileThumbnail = await VideoCompress.getFileThumbnail(f.path); 
        String? thumbnailUploaded = await videoProvider.uploadThumbnail(context, file: fileThumbnail);
        Uint8List thumbnailGenerate = await VideoServices.generateByteThumbnail(file!);
        int sizeVideo = await VideoServices.getVideoSize(file!);
        await GallerySaver.saveVideo(file!.path);
        MediaInfo? info = await VideoServices.compressVideo(file!);
        if(info != null) {
          String? mediaUrl = await videoProvider.uploadVideo(context, file: info.file!);
          SocketServices.shared.sendMsg(
            id: const Uuid().v4(),
            content: widget.content,
            mediaUrl: mediaUrl!,
            category: widget.category,
            lat: locationProvider.getCurrentLat,
            lng: locationProvider.getCurrentLng,
            address: locationProvider.getCurrentNameAddress,
            status: "sent",
            duration: (Duration(microseconds: (info.duration! * 1000).toInt())).toString(),
            thumbnail: thumbnailUploaded!,
            userId: authProvider.getUserId()
          );
          await videoProvider.insertSos(context,
            id: const Uuid().v4(), 
            content: widget.content,
            mediaUrl: mediaUrl, 
            category: widget.category,
            lat: locationProvider.getCurrentLat.toString(),
            lng: locationProvider.getCurrentLng.toString(),
            address: locationProvider.getCurrentNameAddress,
            status: "sent",
            duration: (Duration(microseconds: (info.duration! * 1000).toInt())).toString(),
            thumbnail: thumbnailUploaded,
            userId: authProvider.getUserId(),
          );
          if(mounted) {
            setState(() {
              thumbnail = thumbnailGenerate;
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
      }
    } catch(e) {
      debugPrint(e.toString());
      isCompressed = false;
      videoCompressInfo = null;
      VideoCompress.cancelCompression();
    }
    return null;
  }

  Future<void> startVideoRecording() async {
    CameraController? cameraController = controller!;

    try {
      await cameraController.startVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      return;
    }
  }
  
  Future<XFile?> stopVideoRecording() async {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isRecordingVideo) {
      return null;
    }

    try {
      return cameraController.stopVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
  }

  void _handleScaleStart(ScaleStartDetails details) {
    _baseScale = _currentScale;
  }

  Future<void> _handleScaleUpdate(ScaleUpdateDetails details) async {
    if (controller == null || _pointers != 2) {
      return;
    }
    _currentScale = (_baseScale * details.scale).clamp(_minAvailableZoom, _maxAvailableZoom);
    await controller!.setZoomLevel(_currentScale);
  }

  void _showCameraException(CameraException e) {
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }

  Widget cameraPreviewWidget() {
    if (controller == null || !controller!.value.isInitialized) {
      return Container();
    } else {
      return Listener(
        onPointerDown: (_) => _pointers++,
        onPointerUp: (_) => _pointers--,
        child: CameraPreview(
          controller!,
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onScaleStart: _handleScaleStart,
              onScaleUpdate: _handleScaleUpdate,
              onTapDown: (details) => onViewFinderTap(details, constraints),
            );
          }),
        ),
      );
    }
  }
  
  @override 
  void initState() {
    super.initState();  
            
    subscription = VideoCompress.compressProgress$.subscribe((event) {
      setState(() {
        progress = event;
      }); 
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await onInitCamera();
      await startVideoRecording();

      timer = Timer.periodic(const Duration(seconds: 15), (timer) {
        onStopButtonPressed(context);
        timer.cancel();
      });

      if(mounted) {
        networkProvider.checkConnection(context);
      }
      if(mounted) {
        SocketServices.shared.connect(context);
      }
    });
  }

  @override 
  void dispose() {
    controller!.dispose();
    subscription!.unsubscribe();
    SocketServices.shared.dispose();
    VideoCompress.cancelCompression();
    VideoCompress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildUI();
  }

  Widget buildUI() {
    return Builder(
      builder: (BuildContext context) {
        int progressBar = progress == null ? 0 : (progress!).toInt(); 
        authProvider = context.read<AuthProvider>();
        networkProvider = context.read<NetworkProvider>();
        locationProvider = context.read<LocationProvider>();
        videoProvider = context.read<VideoProvider>();
        return  WillPopScope(
          onWillPop: () async {
            await stopVideoRecording();
            timer!.cancel();
            return Future.value(true);
          },
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            key: globalKey,
            backgroundColor: ColorResources.backgroundColor,
            body: SafeArea(
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return Consumer<NetworkProvider>(
                    builder: (BuildContext context, NetworkProvider networkProvider, Widget? child) {
                      if(networkProvider.connectionStatus == ConnectionStatus.offInternet) {
                        return const Center(
                          child: SpinKitThreeBounce(
                            size: 20.0,
                            color: Colors.black87,
                          ),
                        );
                      }
                      return isCompressed 
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SpinKitThreeBounce(
                                size: 20.0,
                                color: Colors.black87,
                              ),
                              const SizedBox(height: 10.0),
                              Text("${progressBar.toString()} %",
                                style: const TextStyle(
                                  fontSize: Dimensions.fontSizeDefault
                                ),
                              )
                            ]
                          ),
                        )
                      : Stack(
                        clipBehavior: Clip.none,
                        children: [
                                                                
                          Container(
                            padding: const EdgeInsets.all(1.0),
                            width: double.infinity,
                            height: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              border: Border.all(
                                color: controller != null && controller!.value.isRecordingVideo
                                ? ColorResources.redPrimary
                                : Colors.grey,
                                width: 3.0,
                              ),
                            ),
                            child: cameraPreviewWidget()
                          ),

                          Container(
                            margin: const EdgeInsets.only(bottom: 150.0),
                            child: Align(
                              alignment: Alignment.center,
                              child: CustomTimer(
                                controller: CustomTimerController(initialState: CustomTimerState.counting),
                                begin: const Duration(seconds: 15),
                                end: const Duration(),
                                builder: (time) {
                                  return Text(
                                    time.seconds,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 50.0
                                    )
                                  );
                                },
                                stateBuilder: (time, state) {
                                  return null;
                                },
                                animationBuilder: (Widget child) {
                                  return AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 250),
                                    child: child,
                                  );
                                },
                                onChangeState: (state) { }
                              ),
                            ),
                          ),
                          
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              padding: const EdgeInsets.all(5.0),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.stop),
                                color: ColorResources.redPrimary,
                                onPressed: controller != null &&
                                controller!.value.isInitialized &&
                                controller!.value.isRecordingVideo
                                ? () => onStopButtonPressed(context)
                                : null,
                              ),
                            ),
                          ),
                                                                
                        ],
                      );
                    },   
                  );
                },
              ),
            )
            
          ),
        );
      }, 
    );
  }
}
