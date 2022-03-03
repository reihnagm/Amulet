import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
  late InboxProvider inboxProvider;
  late NavigationService navigationService;

  @override 
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      if(mounted) {
        inboxProvider.getInbox(context);
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
        inboxProvider = context.read<InboxProvider>();
        navigationService = NavigationService();
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: ColorResources.backgroundColor,
          body: SafeArea(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return RefreshIndicator(
                  backgroundColor: ColorResources.redPrimary,
                  color: ColorResources.white,
                  onRefresh: () {
                    return Future.sync((){
                      inboxProvider.getInbox(context);
                    });
                  },
                  child: Consumer<InboxProvider>(
                    builder: (BuildContext context, InboxProvider ip, Widget? child) {
                     
                      return CustomScrollView(
                        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                        slivers: [

                          SliverAppBar(
                            backgroundColor: ColorResources.white,
                            centerTitle: true,
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

                          if(ip.inboxStatus == InboxStatus.loading) 
                            SliverFillRemaining(
                              child: Center(
                                child: SpinKitThreeBounce(
                                  size: 20.0,
                                  color: Colors.black87,
                                ),
                              ),
                            ),

                          if(ip.inboxStatus == InboxStatus.empty) 
                            SliverFillRemaining(
                              child: Center(
                                child: Text(getTranslated("THERE_IS_NO_NOTIFICATION", context),
                                  style: TextStyle(
                                    color: ColorResources.black,
                                    fontSize: Dimensions.fontSizeDefault
                                  ),
                                )
                              ),
                            ),
                          

                          SliverPadding(
                            padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int i) {
                                  return Container(
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
                                            uid: ip.inboxes[i].uid!, 
                                            title: ip.inboxes[i].title!, 
                                            content: ip.inboxes[i].content!, 
                                            type: ip.inboxes[i].type!,
                                            thumbnail: ip.inboxes[i].thumbnail!,
                                            mediaUrl: ip.inboxes[i].mediaUrl!,
                                            createdAt: ip.inboxes[i].createdAt!
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
                                                          child: Text(ip.inboxes[i].title!,
                                                            overflow: TextOverflow.ellipsis,
                                                            style: TextStyle(
                                                              color: ColorResources.black,
                                                              fontWeight: ip.inboxes[i].isRead == 1 
                                                              ? FontWeight.w400
                                                              : FontWeight.bold,
                                                              fontSize: Dimensions.fontSizeSmall,
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          padding: EdgeInsets.all(6.0),
                                                          decoration: BoxDecoration(
                                                            color: ip.inboxes[i].type == "done"
                                                            ? ColorResources.success 
                                                            : ColorResources.redPrimary,
                                                            borderRadius: BorderRadius.circular(8.0),
                                                          ),
                                                          child: Text(ip.inboxes[i].type == "done"
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
                                                    Text(ip.inboxes[i].content!,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: ColorResources.black,
                                                        fontWeight: ip.inboxes[i].isRead == 1 
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
                                                        Text(ip.inboxes[i].createdAt!,
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
                                                                    imageUrl: ip.inboxes[i].thumbnail.toString(),
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
                                childCount: ip.inboxes.length
                              )
                            ),
                          )

                        ],
                      );
                    },
                  )
                );
              },  
            ),
          ),
        );  
      },
    );
  }
}