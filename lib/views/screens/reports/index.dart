import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import 'package:amulet/data/models/sos/sos.dart';
import 'package:amulet/localization/language_constraints.dart';
import 'package:amulet/services/navigation.dart';
import 'package:amulet/views/screens/media/preview_file.dart';
import 'package:amulet/providers/network.dart';
import 'package:amulet/providers/videos.dart';
import 'package:amulet/utils/color_resources.dart';
import 'package:amulet/utils/dimensions.dart';
import 'package:amulet/views/basewidgets/drawer/drawer.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({ Key? key }) : super(key: key);

  @override
  _ReportsScreenState createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  final pagingController = PagingController<int, SosData>(
    firstPageKey: 1,
  );

  late NavigationService navigationService;
  late VideoProvider videoProvider;
  late NetworkProvider networkProvider;

  @override 
  void initState() {
    super.initState();
    Future.delayed((Duration.zero), () {
      if(mounted) {
        networkProvider.checkConnection(context);
      }
    });
    pagingController.addPageRequestListener((pageKey) {
      videoProvider.getSos(context, pagingController: pagingController, pageKey: pageKey);
    });
  }

  @override 
  void dispose() {
    pagingController.dispose();
    super.dispose();
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
        navigationService = NavigationService();
        return Scaffold(
          resizeToAvoidBottomInset: false,
          key: globalKey,
          drawer: DrawerWidget(key: UniqueKey()),
          backgroundColor: ColorResources.backgroundColor,
          body: Consumer<NetworkProvider>(
            builder: (BuildContext context, NetworkProvider networkProvider, Widget? child) {
              if(networkProvider.connectionStatus == ConnectionStatus.offInternet) 
                return Center(
                  child: SpinKitThreeBounce(
                    size: 20.0,
                    color: Colors.black87,
                  ),
                );
              return RefreshIndicator(
                backgroundColor: ColorResources.white,
                color: ColorResources.redPrimary,
                onRefresh: () {
                  return Future.sync(() {
                    pagingController.refresh();
                  });
                },
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                  slivers: [
                              
                    SliverAppBar(
                      backgroundColor: ColorResources.white,
                      centerTitle: true,
                      title: Image.asset("assets/images/amulet-icon-logo.png",
                        width: 50.0,
                        height: 50.0,
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
                          children: [
                            Expanded(
                              flex: 6,
                              child: Text(getTranslated("FILE", context),
                                style: const TextStyle(
                                  fontSize: Dimensions.fontSizeDefault,
                                  fontWeight: FontWeight.w500
                                ),
                              )
                            ),
                            Expanded(
                              flex: 6,
                              child: Text("ID",
                                style: const TextStyle(
                                  fontSize: Dimensions.fontSizeDefault,
                                  fontWeight: FontWeight.w500
                                ),
                              )
                            ),
                            Expanded(
                              flex: 6,
                              child: Text(getTranslated("CASE", context),
                                style: const TextStyle(
                                  fontSize: Dimensions.fontSizeDefault,
                                  fontWeight: FontWeight.w500
                                ),
                              )
                            ),
                            Expanded(
                              flex: 6,
                              child: Text(getTranslated("SENDER", context),
                                style: const TextStyle(
                                  fontSize: Dimensions.fontSizeDefault,
                                  fontWeight: FontWeight.w500
                                ),
                              )
                            ),
                            const Expanded(
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
              
                    SliverPadding(
                      padding: const EdgeInsets.only(
                        top: 20.0, 
                        bottom: 20.0
                      ),
                      sliver: PagedSliverList.separated(
                        pagingController: pagingController,
                        separatorBuilder: (BuildContext context, int i) => const SizedBox(
                          height: 16.0,
                        ),
                        builderDelegate: PagedChildBuilderDelegate<SosData>(
                          itemBuilder: (BuildContext context, SosData sosData, int i) {
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
                                                imageUrl: sosData.thumbnail.toString(),
                                                width: 50.0,
                                                height: 50.0,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            Positioned.fill(
                                              left: 0.0,
                                              right: 0.0,
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: InkWell(
                                                  onTap: () {
                                                    navigationService.pushNav(context, PreviewFileScreen(
                                                      mediaUrl: sosData.mediaUrlPhone
                                                    ));
                                                  },
                                                  child: const Icon(
                                                    Icons.play_arrow,
                                                    color: ColorResources.white,
                                                  ),
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
                                        Text(sosData.signId!,
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
                                        Text(sosData.category == null || sosData.category == ""
                                        ? "-" 
                                        : sosData.category.toString(),
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
                                        Text(sosData.fullname.toString(),
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
                                              showModalBottomSheet(
                                                isDismissible: false,
                                                isScrollControlled: true,
                                                context: context, 
                                                builder: (BuildContext context) {
                                                  return Container(
                                                    margin: const EdgeInsets.only(
                                                      left: Dimensions.marginSizeDefault, 
                                                      right: Dimensions.marginSizeDefault
                                                    ),
                                                    padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                                                    child: SingleChildScrollView(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [ 
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.end,
                                                            children: [
                                                              InkWell(
                                                                onTap: () {
                                                                  Navigator.of(context).pop();
                                                                },
                                                                child: const Padding(
                                                                  padding: EdgeInsets.all(8.0),
                                                                  child: Icon(
                                                                    Icons.close,
                                                                    color: ColorResources.redPrimary,
                                                                    size: 30.0,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(height: 15.0),
                                                          ClipRRect(
                                                            borderRadius: BorderRadius.circular(20.0),
                                                            child: CachedNetworkImage(
                                                              width: double.infinity,
                                                              height: 300.0,
                                                              fit: BoxFit.fitWidth,
                                                              imageUrl: sosData.thumbnail!,
                                                            ),
                                                          ),
                                                          const SizedBox(height: 30.0),
                                                          Container(
                                                            margin: const EdgeInsets.only(
                                                              left: Dimensions.marginSizeDefault,
                                                              right: Dimensions.marginSizeDefault
                                                            ),
                                                            child: Row(
                                                              mainAxisSize: MainAxisSize.max,
                                                              children: [
                                                                Expanded(
                                                                  flex: 4,
                                                                  child: Text(getTranslated("CASE", context),
                                                                    style: const TextStyle(
                                                                      fontWeight: FontWeight.w500,
                                                                      fontSize: Dimensions.fontSizeDefault
                                                                    ),
                                                                  ),
                                                                ),
                                                                const Expanded(
                                                                  flex: 1,
                                                                  child: Text(":",
                                                                    style: TextStyle(
                                                                      fontWeight: FontWeight.w500,
                                                                      fontSize: Dimensions.fontSizeDefault
                                                                    ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  flex: 11,
                                                                  child: Text(sosData.category.toString().split(".")[0],
                                                                    style: const TextStyle(
                                                                      fontWeight: FontWeight.w500,
                                                                      fontSize: Dimensions.fontSizeDefault
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          const SizedBox(height: 15.0),
                                                          Container(
                                                            margin: const EdgeInsets.only(
                                                              left: Dimensions.marginSizeDefault,
                                                              right: Dimensions.marginSizeDefault
                                                            ),
                                                            child: Row(
                                                              mainAxisSize: MainAxisSize.max,
                                                              children: [
                                                                Expanded(
                                                                  flex: 4,
                                                                  child: Text(getTranslated("MESSAGE", context),
                                                                    style: const TextStyle(
                                                                      fontWeight: FontWeight.w500,
                                                                      fontSize: Dimensions.fontSizeDefault
                                                                    ),
                                                                  ),
                                                                ),
                                                                const Expanded(
                                                                  flex: 1,
                                                                  child: Text(":",
                                                                    style: TextStyle(
                                                                      fontWeight: FontWeight.w500,
                                                                      fontSize: Dimensions.fontSizeDefault
                                                                    ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  flex: 11,
                                                                  child: Text(sosData.content.toString().split(".")[0],
                                                                    style: const TextStyle(
                                                                      fontWeight: FontWeight.w500,
                                                                      fontSize: Dimensions.fontSizeDefault
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          const SizedBox(height: 15.0),
                                                          Container(
                                                            margin: const EdgeInsets.only(
                                                              left: Dimensions.marginSizeDefault,
                                                              right: Dimensions.marginSizeDefault
                                                            ),
                                                            child: Row(
                                                              mainAxisSize: MainAxisSize.max,
                                                              children: [
                                                                Expanded(
                                                                  flex: 4,
                                                                  child: Text(getTranslated("DURATION", context),
                                                                    style: const TextStyle(
                                                                      fontWeight: FontWeight.w500,
                                                                      fontSize: Dimensions.fontSizeDefault
                                                                    ),
                                                                  ),
                                                                ),
                                                                const Expanded(
                                                                  flex: 1,
                                                                  child: Text(":",
                                                                    style: TextStyle(
                                                                      fontWeight: FontWeight.w500,
                                                                      fontSize: Dimensions.fontSizeDefault
                                                                    ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  flex: 11,
                                                                  child: Text(sosData.duration.toString().split(".")[0],
                                                                    style: const TextStyle(
                                                                      fontWeight: FontWeight.w500,
                                                                      fontSize: Dimensions.fontSizeDefault
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          const SizedBox(height: 15.0),
                                                          Container(
                                                            margin: const EdgeInsets.only(
                                                              left: Dimensions.marginSizeDefault,
                                                              right: Dimensions.marginSizeDefault
                                                            ),
                                                            child: Row(
                                                              mainAxisSize: MainAxisSize.max,
                                                              children: [
                                                                Expanded(
                                                                  flex: 4,
                                                                  child: Text(getTranslated("ADDRESS", context),
                                                                    style: const TextStyle(
                                                                      fontWeight: FontWeight.w500,
                                                                      fontSize: Dimensions.fontSizeDefault
                                                                    ),
                                                                  ),
                                                                ),
                                                                const Expanded(
                                                                  flex: 1,
                                                                  child: Text(":",
                                                                    style: TextStyle(
                                                                      fontWeight: FontWeight.w500,
                                                                      fontSize: Dimensions.fontSizeDefault
                                                                    ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  flex: 11,
                                                                  child: Text(sosData.address.toString(),
                                                                    style: const TextStyle(
                                                                      fontWeight: FontWeight.w500,
                                                                      fontSize: Dimensions.fontSizeDefault
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          const SizedBox(height: 15.0),
                                                          Container(
                                                            margin: const EdgeInsets.only(
                                                              left: Dimensions.marginSizeDefault,
                                                              right: Dimensions.marginSizeDefault
                                                            ),
                                                            child: Row(
                                                              mainAxisSize: MainAxisSize.max,
                                                              children: [
                                                                const Expanded(
                                                                  flex: 4,
                                                                  child: Text("Lat",
                                                                    style: TextStyle(
                                                                      fontWeight: FontWeight.w500,
                                                                      fontSize: Dimensions.fontSizeDefault
                                                                    ),
                                                                  ),
                                                                ),
                                                                const Expanded(
                                                                  flex: 1,
                                                                  child: Text(":",
                                                                    style: TextStyle(
                                                                      fontWeight: FontWeight.w500,
                                                                      fontSize: Dimensions.fontSizeDefault
                                                                    ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  flex: 11,
                                                                  child: Text(sosData.lat.toString(),
                                                                    style: const TextStyle(
                                                                      fontWeight: FontWeight.w500,
                                                                      fontSize: Dimensions.fontSizeDefault
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          const SizedBox(height: 15.0),
                                                          Container(
                                                            margin: const EdgeInsets.only(
                                                              left: Dimensions.marginSizeDefault,
                                                              right: Dimensions.marginSizeDefault
                                                            ),
                                                            child: Row(
                                                              mainAxisSize: MainAxisSize.max,
                                                              children: [
                                                                const Expanded(
                                                                  flex: 4,
                                                                  child: Text("Lng",
                                                                    style: TextStyle(
                                                                      fontWeight: FontWeight.w500,
                                                                      fontSize: Dimensions.fontSizeDefault
                                                                    ),
                                                                  ),
                                                                ),
                                                                const Expanded(
                                                                  flex: 1,
                                                                  child: Text(":",
                                                                    style: TextStyle(
                                                                      fontWeight: FontWeight.w500,
                                                                      fontSize: Dimensions.fontSizeDefault
                                                                    ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  flex: 11,
                                                                  child: Text(sosData.lng.toString(),
                                                                    style: const TextStyle(
                                                                      fontWeight: FontWeight.w500,
                                                                      fontSize: Dimensions.fontSizeDefault
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          const SizedBox(height: 15.0),
                                                          Container(
                                                            margin: const EdgeInsets.only(
                                                              left: Dimensions.marginSizeDefault,
                                                              right: Dimensions.marginSizeDefault
                                                            ),
                                                            child: Row(
                                                              mainAxisSize: MainAxisSize.max,
                                                              children: [
                                                                Expanded(
                                                                  flex: 4,
                                                                  child: Text(getTranslated("SENDER", context),
                                                                    style: const TextStyle(
                                                                      fontWeight: FontWeight.w500,
                                                                      fontSize: Dimensions.fontSizeDefault
                                                                    ),
                                                                  ),
                                                                ),
                                                                const Expanded(
                                                                  flex: 1,
                                                                  child: Text(":",
                                                                    style: TextStyle(
                                                                      fontWeight: FontWeight.w500,
                                                                      fontSize: Dimensions.fontSizeDefault
                                                                    ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  flex: 11,
                                                                  child: Text(sosData.fullname.toString(),
                                                                    style: const TextStyle(
                                                                      fontWeight: FontWeight.w500,
                                                                      fontSize: Dimensions.fontSizeDefault
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          const SizedBox(height: 15.0),
                                                          Container(
                                                            margin: const EdgeInsets.only(
                                                              left: Dimensions.marginSizeDefault,
                                                              right: Dimensions.marginSizeDefault
                                                            ),
                                                            child: Row(
                                                              mainAxisSize: MainAxisSize.max,
                                                              children: [
                                                                Expanded(
                                                                  flex: 4,
                                                                  child: Text(getTranslated("DATE", context),
                                                                    style: const TextStyle(
                                                                      fontWeight: FontWeight.w500,
                                                                      fontSize: Dimensions.fontSizeDefault
                                                                    ),
                                                                  ),
                                                                ),
                                                                const Expanded(
                                                                  flex: 1,
                                                                  child: Text(":",
                                                                    style: TextStyle(
                                                                      fontWeight: FontWeight.w500,
                                                                      fontSize: Dimensions.fontSizeDefault
                                                                    ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  flex: 11,
                                                                  child: Text(sosData.createdAt.toString(),
                                                                    style: const TextStyle(
                                                                      fontWeight: FontWeight.w500,
                                                                      fontSize: Dimensions.fontSizeDefault
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          const SizedBox(height: 30.0),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                }
                                              );
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
                          animateTransitions: true,
                          firstPageProgressIndicatorBuilder: (BuildContext context) {
                            return const SpinKitChasingDots(
                              size: 16.0,
                              color: Colors.black
                            );
                          },
                          firstPageErrorIndicatorBuilder: (BuildContext context) => Container(
                            height: MediaQuery.of(context).size.height,
                            child: Center(
                              child: Text(getTranslated("THERE_WAS_PROBLEM", context),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w500
                                ),
                              ),
                            ),
                          ),
                          newPageProgressIndicatorBuilder: (BuildContext context) {
                            return const SpinKitChasingDots(
                              size: 16.0,
                              color: Colors.black
                            );
                          },
                          noItemsFoundIndicatorBuilder: (BuildContext context) =>  Container(
                            height: MediaQuery.of(context).size.height,
                            child: Center(
                              child: Text(getTranslated("THERE_IS_NO_DATA", context),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: Dimensions.fontSizeDefault
                                ),
                              )
                            ),
                          ),
                        ),
                      )
                    )
                  ],
                ),
              );
            },
          ),
        );
      }, 
    );
  }
}