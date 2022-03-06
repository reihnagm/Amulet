import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:amulet/data/models/sos/agent.dart';
import 'package:amulet/views/screens/media/preview_file.dart';
import 'package:amulet/localization/language_constraints.dart';
import 'package:amulet/utils/box_shadow.dart';
import 'package:amulet/utils/color_resources.dart';
import 'package:amulet/utils/dimensions.dart';
import 'package:amulet/providers/auth.dart';
import 'package:amulet/providers/network.dart';
import 'package:amulet/providers/videos.dart';
import 'package:amulet/services/navigation.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({ Key? key }) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {  
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  final pagingController = PagingController<int, SosAgentData>(
    firstPageKey: 1,
  );

  late AuthProvider authProvider;
  late VideoProvider videoProvider;
  late NetworkProvider networkProvider;
  late NavigationService navigationService;

  @override 
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      if(mounted) {
        videoProvider.initFcm(context);
      }
      if(mounted) {
        networkProvider.checkConnection(context);
      }
    });
    pagingController.addPageRequestListener((pageKey) {
      videoProvider.getHistorySos(context, 
        isConfirm: '1',
        pageKey: pageKey,
        pagingController: pagingController
      );
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
      builder: (BuildContext context) {
        authProvider = context.read<AuthProvider>();
        videoProvider = context.read<VideoProvider>();
        networkProvider = context.read<NetworkProvider>();
        navigationService = NavigationService();
        return Scaffold(
          key: globalKey,
          resizeToAvoidBottomInset: false,
          backgroundColor: ColorResources.backgroundColor,
          body: SafeArea(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Consumer<NetworkProvider>( 
                  builder: (BuildContext context, NetworkProvider networkProvider, Widget? child) {
                    return RefreshIndicator(
                      backgroundColor: ColorResources.white,
                      color: ColorResources.redPrimary,
                      onRefresh: () {
                        return Future.sync(() {
                          pagingController.refresh();
                        });
                      },
                      child: CustomScrollView(
                        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                        slivers: [
                    
                          SliverAppBar(
                            backgroundColor: ColorResources.backgroundColor,
                            pinned: true,
                            centerTitle: true,
                            elevation: 0.0,
                            title: Text(getTranslated("HISTORY", context),
                              style: TextStyle(
                                fontSize: Dimensions.fontSizeDefault,
                                color: ColorResources.black
                              ),
                            ),
                            automaticallyImplyLeading: false,
                            leading: CupertinoNavigationBarBackButton(
                              color: ColorResources.black,
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ),

                          SliverPadding(
                            padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                            sliver: PagedSliverList.separated(
                              pagingController: pagingController,
                              separatorBuilder: (BuildContext context, int i) => const SizedBox(
                                height: 16.0,
                              ),
                              builderDelegate: PagedChildBuilderDelegate<SosAgentData>(
                                itemBuilder: (BuildContext context, SosAgentData sosAgentDataHistory, int i) {
                                  
                                  DateTime date = sosAgentDataHistory.createdAt!;
                                  
                                  return Container(
                                    margin: EdgeInsets.only(
                                      left: Dimensions.marginSizeDefault, 
                                      right: Dimensions.marginSizeDefault
                                    ),
                                    child: Container(
                                      margin: EdgeInsets.only(
                                        top: Dimensions.marginSizeSmall,
                                        bottom: Dimensions.marginSizeSmall
                                      ),
                                      decoration: BoxDecoration(
                                        color: ColorResources.white,
                                        boxShadow: boxShadow,
                                        borderRadius: BorderRadius.circular(8.0)
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Expanded(
                                                  flex: 12,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        mainAxisSize: MainAxisSize.max,
                                                        children: [
                                                          Text("${getTranslated("CASE", context)} #${sosAgentDataHistory.signId} ${sosAgentDataHistory.category! == "-" ? "" : sosAgentDataHistory.category!}",
                                                            style: TextStyle(
                                                              fontSize: Dimensions.fontSizeLarge,
                                                              fontWeight: FontWeight.w500
                                                            ),
                                                          ),
                                                          Container(
                                                            padding: EdgeInsets.all(6.0),
                                                            decoration: BoxDecoration(
                                                              color: sosAgentDataHistory.isConfirm == 2 
                                                              ? ColorResources.success 
                                                              : ColorResources.redPrimary,
                                                              borderRadius: BorderRadius.circular(8.0),
                                                            ),
                                                            child: Text(sosAgentDataHistory.isConfirm == 2 
                                                            ? getTranslated("DONE", context)
                                                            : sosAgentDataHistory.isConfirm == 1 && date.hour > DateTime.now().hour 
                                                            ? getTranslated("CASE_EXPIRED", context)
                                                            : getTranslated("ONGOING", context),
                                                              style: TextStyle(
                                                                fontSize: Dimensions.fontSizeSmall,
                                                                fontWeight: FontWeight.bold,
                                                                color: ColorResources.white
                                                              ),
                                                            ),
                                                          )
                                                        ]
                                                      ),
                                                      const SizedBox(height: 5.0),
                                                      Text("${sosAgentDataHistory.isConfirm == 2 
                                                      ? getTranslated("CASE_SOLVED", context)
                                                      : sosAgentDataHistory.isConfirm == 1 && date.hour > DateTime.now().hour 
                                                      ? getTranslated("CASE_EXPIRED", context)
                                                      : getTranslated("CASE_ONGOING", context)}",
                                                        style: TextStyle(
                                                          color: ColorResources.success,
                                                          fontSize: Dimensions.fontSizeSmall
                                                        ),
                                                      ),
                                                      const SizedBox(height: 5.0),
                                                      Text("${sosAgentDataHistory.asName} ${sosAgentDataHistory.acceptName}",
                                                        style: TextStyle(
                                                          color: ColorResources.success,
                                                          fontSize: Dimensions.fontSizeSmall
                                                        ),
                                                      ),
                                                      const SizedBox(height: 8.0),
                                                      Row(
                                                        mainAxisSize: MainAxisSize.max,
                                                        children: [
                                                          Text(DateFormat("dd/MM/yyyy").format(sosAgentDataHistory.createdAt!.toLocal()),
                                                            style: TextStyle(
                                                              fontSize: Dimensions.fontSizeSmall,
                                                              fontWeight: FontWeight.w400,
                                                              color: ColorResources.dimGrey
                                                            ),
                                                          ),
                                                          const SizedBox(width: 8.0),
                                                          Text("|",
                                                            style: TextStyle(
                                                              fontSize: Dimensions.fontSizeSmall,
                                                              fontWeight: FontWeight.w400,
                                                              color: ColorResources.dimGrey
                                                            ),
                                                          ),
                                                          const SizedBox(width: 8.0),
                                                          Text(DateFormat("HH:mm").format(sosAgentDataHistory.createdAt!.toLocal()),
                                                            style: TextStyle(
                                                              fontSize: Dimensions.fontSizeSmall,
                                                              fontWeight: FontWeight.w400,
                                                              color: ColorResources.dimGrey
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Row(
                                                  mainAxisSize: MainAxisSize.max,
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(sosAgentDataHistory.address!,
                                                      textAlign: TextAlign.justify,
                                                      style: TextStyle(
                                                        height: 1.8,
                                                        fontWeight: FontWeight.w400,
                                                        fontSize: Dimensions.fontSizeSmall
                                                      ),
                                                    ),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Stack(
                                                          clipBehavior: Clip.none,
                                                          children: [
                                                            ClipRRect(
                                                              borderRadius: BorderRadius.circular(10.0),
                                                              child: CachedNetworkImage(
                                                                imageUrl: sosAgentDataHistory.thumbnail!,
                                                                width: 50.0,
                                                                height: 50.0,
                                                                fit: BoxFit.cover,
                                                                placeholder: (BuildContext context, String url) {
                                                                  return Center(
                                                                    child: SpinKitThreeBounce(
                                                                      size: 20.0,
                                                                      color: Colors.black87,
                                                                    ),
                                                                  );              
                                                                },
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
                                                                      mediaUrl: sosAgentDataHistory.mediaUrlPhone!
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
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
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
                                    child: Text(getTranslated("THERE_IS_NO_CASE", context),
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
                );
              },
            ),
          )
        );
      },
    );
  }
}