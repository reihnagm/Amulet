import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:panic_button/providers/network.dart';
import 'package:provider/provider.dart';

import 'package:panic_button/providers/videos.dart';
import 'package:panic_button/utils/color_resources.dart';
import 'package:panic_button/utils/dimensions.dart';
import 'package:panic_button/views/basewidgets/drawer/drawer.dart';

class ListVideoScreen extends StatefulWidget {
  const ListVideoScreen({ Key? key }) : super(key: key);

  @override
  _ListVideoScreenState createState() => _ListVideoScreenState();
}

class _ListVideoScreenState extends State<ListVideoScreen> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  late VideoProvider videoProvider;
  late NetworkProvider networkProvider;

  @override 
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if(mounted) {
        networkProvider.checkConnection(context);
      }
      if(mounted) {
        videoProvider.fetchSos(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return buildUI();
  }

  Widget buildUI() {
    return Builder(
      builder:(BuildContext context) {
        videoProvider = context.read<VideoProvider>();
        networkProvider = context.read<NetworkProvider>();
        return Scaffold(
          resizeToAvoidBottomInset: false,
          key: globalKey,
          drawer: DrawerWidget(key: UniqueKey()),
          backgroundColor: ColorResources.backgroundColor,
          body: RefreshIndicator(
            backgroundColor: ColorResources.white,
            color: ColorResources.redPrimary,
            onRefresh: () {
              return Future.sync(() {
                videoProvider.fetchSos(context);
              });
            },
            child: Consumer<NetworkProvider>(
              builder: (BuildContext context, NetworkProvider networkProvider, Widget? child) {
                return Consumer<VideoProvider>(
                  builder: (BuildContext bcontext, VideoProvider videoProvider, Widget? child) {
                    return CustomScrollView(
                      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                      slivers: [
                  
                        SliverAppBar(
                          backgroundColor: ColorResources.white,
                          centerTitle: true,
                          title: Image.asset("assets/images/logo-panic-button.png",
                            width: 80.0,
                            height: 80.0,
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
                                top: 50.0,
                                left: Dimensions.marginSizeLarge,
                                right: Dimensions.marginSizeLarge,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Expanded(
                                    flex: 5,
                                    child: Text("Thumbnail",
                                      style: TextStyle(
                                        fontSize: Dimensions.fontSizeDefault,
                                        fontWeight: FontWeight.w500
                                      ),
                                    )
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: Text("Keterangan",
                                      style: TextStyle(
                                        fontSize: Dimensions.fontSizeDefault,
                                        fontWeight: FontWeight.w500
                                      ),
                                    )
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: Text("Pengirim",
                                      style: TextStyle(
                                        fontSize: Dimensions.fontSizeDefault,
                                        fontWeight: FontWeight.w500
                                      ),
                                    )
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text("Info",
                                      style: TextStyle(
                                        fontSize: Dimensions.fontSizeDefault,
                                        fontWeight: FontWeight.w500
                                      ),
                                    )
                                  ),
                                ],
                              ),
                            )
                          ),
                        if(networkProvider.connectionStatus == ConnectionStatus.onInternet)
                          if(videoProvider.listenVStatus == ListenVStatus.loading) 
                            const SliverFillRemaining(
                              child: Center(
                                child: SpinKitThreeBounce(
                                  size: 20.0,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          if(videoProvider.listenVStatus == ListenVStatus.loaded) 
                            SliverPadding(
                              padding: const EdgeInsets.only(
                                top: 20.0, 
                                bottom: 20.0
                              ),
                              sliver: SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int i) {
                                    return Container(
                                      margin: const EdgeInsets.only(
                                        left: Dimensions.marginSizeLarge, 
                                        right: Dimensions.marginSizeLarge
                                      ),
                                      padding: const EdgeInsets.all(16.0),
                                      decoration: BoxDecoration(
                                        color: i % 2 == 1 
                                        ? ColorResources.greyTable 
                                        : ColorResources.white,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Expanded(
                                            flex: 6,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Stack(
                                                  clipBehavior: Clip.none,
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius: BorderRadius.circular(10.0),
                                                      child: CachedNetworkImage(
                                                        imageUrl: videoProvider.sosData[i].thumbnail.toString(),
                                                        width: 50.0,
                                                        height: 50.0,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),

                                                    const Positioned.fill(
                                                      left: 0.0,
                                                      right: 0.0,
                                                      child: Align(
                                                        alignment: Alignment.center,
                                                        child: Icon(
                                                          Icons.arrow_circle_right_outlined,
                                                          color: ColorResources.white,
                                                        ),
                                                      )
                                                    ),
                                                  ],
                                                )
                                             
                                              ],
                                            ) 
                                          ),
                                          Expanded(
                                            flex: 6,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(videoProvider.sosData[i].category == null || videoProvider.sosData[i].category == ""
                                                ? "-" 
                                                : videoProvider.sosData[i].category.toString(),
                                                  style: const TextStyle(
                                                    color: ColorResources.black,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: Dimensions.fontSizeDefault
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 8,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(videoProvider.sosData[i].fullname.toString(),
                                                  overflow: TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    color: ColorResources.black,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: Dimensions.fontSizeDefault
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Material(
                                                  color: ColorResources.transparent,
                                                  child: InkWell(
                                                    onTap: () {
                                                      
                                                    },
                                                    child: const Padding(
                                                      padding: EdgeInsets.all(8.0),
                                                      child: Icon(Icons.info,
                                                        color: ColorResources.blue,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                  childCount: videoProvider.sosData.length          
                                )
                              ),
                            )
                      ],
                    ); 
                  },
                );
              },
            ),
          ),
        );
      }, 
    );
  }
}