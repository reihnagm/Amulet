import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:video_player/video_player.dart';

import 'package:amulet/utils/color_resources.dart';

class PreviewFileScreen extends StatefulWidget {
  final String mediaUrl;
  const PreviewFileScreen({
    Key? key,
    required this.mediaUrl 
  }) : super(key: key);

  @override
  State<PreviewFileScreen> createState() => _PreviewFileScreenState();
}

class _PreviewFileScreenState extends State<PreviewFileScreen> with WidgetsBindingObserver {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
 
  late VideoPlayerController videoPlayerController;

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
    }
    if(state == AppLifecycleState.inactive) {
      debugPrint("=== APP INACTIVE ===");
      videoPlayerController.pause();
    }
    if(state == AppLifecycleState.paused) {
      debugPrint("=== APP PAUSED ===");
      videoPlayerController.pause();
    }
    if(state == AppLifecycleState.detached) {
      debugPrint("=== APP CLOSED ===");
      videoPlayerController.pause();
    }
  }

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController
    .network(widget.mediaUrl)
    ..addListener(() { setState(() {}); })
    ..setLooping(false)
    ..initialize().then((_) => videoPlayerController.pause());;
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        videoPlayerController.pause();
        return Future.value(true);
      },
      child: Scaffold(
        key: globalKey,
        backgroundColor: ColorResources.backgroundColor,
        appBar: AppBar(
          backgroundColor: ColorResources.white,
          centerTitle: true,
          elevation: 0.0,
          iconTheme: const IconThemeData(
            color: ColorResources.black
          ),
          leading: CupertinoNavigationBarBackButton(
            color: ColorResources.black,
            onPressed: () {
              videoPlayerController.pause();
              Navigator.of(context).pop();
            },
          )
        ),
        body: SafeArea(
          child: videoPlayerController.value.isInitialized
          ? Align(
            alignment: Alignment.center,
            child: Stack(
              children: [
                AspectRatio(
                  aspectRatio: videoPlayerController.value.aspectRatio,
                  child: VideoPlayer(videoPlayerController),
                ),
                Positioned.fill(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      if( videoPlayerController.value.isPlaying) {
                        videoPlayerController.pause();
                      } else {
                        videoPlayerController.play();
                      }
                    },
                    child: Stack(
                      children: [
                        videoPlayerController.value.isPlaying
                        ? Container() 
                        : Container(
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                              size: 80
                            ),
                          ),
                        Positioned(
                          bottom: 0.0,
                          left: 0.0,
                          right: 0.0,
                          child: VideoProgressIndicator(
                            videoPlayerController,
                            allowScrubbing: true,
                          )
                        ),
                      ],
                    ),
                  )
                )
              ],
            ),
          )
          : const Center(
            child: SpinKitThreeBounce(
              size: 20.0,
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}