import 'package:amulet/data/models/inbox/inbox.dart';
import 'package:amulet/providers/network.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import 'package:amulet/services/navigation.dart';
import 'package:amulet/views/screens/notification/notification_detail.dart';
import 'package:amulet/localization/language_constraints.dart';
import 'package:amulet/providers/inbox.dart';
import 'package:amulet/utils/box_shadow.dart';
import 'package:amulet/utils/color_resources.dart';
import 'package:amulet/utils/dimensions.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({ Key? key }) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  final pagingController = PagingController<int, InboxData>(
    firstPageKey: 1,
  );

  late InboxProvider inboxProvider;
  late NetworkProvider networkProvider;
  late NavigationService navigationService;

  @override 
  void initState() {
    super.initState();

    Future.delayed(Duration.zero,() {
      if(mounted) {
        networkProvider.checkConnection(context);
      }
    });

    pagingController.addPageRequestListener((pageKey) {
      inboxProvider.getInbox(
        context, 
        pagingController: pagingController, 
        pageKey: pageKey
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
        networkProvider = context.read<NetworkProvider>();
        inboxProvider = context.read<InboxProvider>();
        navigationService = NavigationService();
        return Scaffold(
          resizeToAvoidBottomInset: false,
          key: globalKey,
          backgroundColor: ColorResources.backgroundColor,
          body: SafeArea(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Consumer<NetworkProvider>(
                  builder: (BuildContext context, NetworkProvider networkProvider, Widget? child) {
                    if(networkProvider.connectionStatus == ConnectionStatus.offInternet) 
                      return Center(
                        child: SpinKitThreeBounce(
                          size: 20.0,
                          color: Colors.black87,
                        ),
                      );
                    return RefreshIndicator(
                      backgroundColor: ColorResources.redPrimary,
                      color: ColorResources.white,
                      onRefresh: () {
                        return Future.sync((){
                          pagingController.refresh();
                        });
                      },
                      child:  CustomScrollView(
                        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                        slivers: [

                          SliverAppBar(
                            backgroundColor: ColorResources.white,
                            centerTitle: true,
                            elevation: 0.0,
                            pinned: true,
                            title: Text(getTranslated("NOTIFICATION", context),
                              style: TextStyle(
                                color: ColorResources.black,
                                fontWeight: FontWeight.w500
                              ),
                            ),
                            leading: CupertinoNavigationBarBackButton(
                              color: ColorResources.black,
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            )
                          ),

                          

                          SliverPadding(
                            padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                            sliver:  PagedSliverList.separated(
                              pagingController: pagingController,
                              separatorBuilder: (BuildContext context, int i) => const SizedBox(
                                height: 16.0,
                              ),
                              builderDelegate: PagedChildBuilderDelegate<InboxData>(
                                itemBuilder: (BuildContext context, InboxData inboxData, int i) {
                                  return  Container(
                                    margin: const EdgeInsets.only(
                                      top: Dimensions.marginSizeSmall,
                                      left: Dimensions.marginSizeDefault,
                                      right: Dimensions.marginSizeDefault,
                                      bottom: Dimensions.marginSizeExtraSmall
                                    ),
                                    decoration: BoxDecoration(
                                      color: ColorResources.white,
                                      borderRadius: BorderRadius.circular(10.0),
                                      boxShadow: boxShadow
                                    ),
                                    child: Material(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: ColorResources.transparent,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(10.0),
                                        onTap: () {
                                          navigationService.pushNav(context, NotificationDetail(
                                            uid: inboxData.uid!, 
                                            title: inboxData.title!, 
                                            content: inboxData.content!, 
                                            type: inboxData.type!,
                                            thumbnail: inboxData.thumbnail!,
                                            mediaUrl: inboxData.mediaUrl!,
                                            createdAt: inboxData.createdAt!,
                                            pagingController: pagingController,
                                          ));
                                        },  
                                        child: Padding(
                                          padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Expanded(
                                                flex: 3,
                                                child: Image.asset("assets/images/info-sos.png",
                                                  width: 35.0,
                                                  height: 35.0,
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Container()
                                              ),
                                              Expanded(
                                                flex: 16,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      mainAxisSize: MainAxisSize.max,
                                                      children: [
                                                        SizedBox(
                                                          width: 200.0,
                                                          child: Text(inboxData.title!,
                                                            overflow: TextOverflow.ellipsis,
                                                            style: TextStyle(
                                                              color: ColorResources.black,
                                                              fontWeight: inboxData.isRead == 1 
                                                              ? FontWeight.w400
                                                              : FontWeight.bold,
                                                              fontSize: Dimensions.fontSizeSmall,
                                                            ),
                                                          ),
                                                        ),
                                                        if(inboxData.type != "info")
                                                          Container(
                                                            padding: EdgeInsets.all(6.0),
                                                            decoration: BoxDecoration(
                                                              color: inboxData.type == "done"
                                                              ? ColorResources.success 
                                                              : ColorResources.redPrimary,
                                                              borderRadius: BorderRadius.circular(8.0),
                                                            ),
                                                            child: Text(inboxData.type == "done"
                                                            ? getTranslated("DONE", context)
                                                            : getTranslated("ONGOING", context),
                                                              style: TextStyle(
                                                                fontSize: Dimensions.fontSizeSmall,
                                                                fontWeight: FontWeight.bold,
                                                                color: ColorResources.white
                                                              ),
                                                            ),
                                                          )
                                                      ],
                                                    ),
                                                    const SizedBox(height: 5.0),
                                                    Text(inboxData.content!,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: ColorResources.black,
                                                        fontWeight: inboxData.isRead == 1 
                                                        ? FontWeight.w400
                                                        : FontWeight.bold,
                                                        fontSize: Dimensions.fontSizeSmall,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 8.0),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      mainAxisSize: MainAxisSize.max,
                                                      children: [
                                                        Text(inboxData.createdAt!,
                                                          style: const TextStyle(
                                                            color: ColorResources.greyDarkPrimary,
                                                            fontWeight: FontWeight.w300,
                                                            fontSize: Dimensions.fontSizeExtraSmall
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
                                                                    imageUrl: inboxData.thumbnail.toString(),
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
                                                              ],
                                                            )
                                                          ],
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),                  
                                            ],
                                          ),
                                        ),
                                      ),
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
                                    child: Text(getTranslated("THERE_IS_NO_NOTIFICATION", context),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: Dimensions.fontSizeDefault
                                      ),
                                    )
                                  ),
                                ),
                              ),
                            ),    
                          )

                        ],
                      )
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