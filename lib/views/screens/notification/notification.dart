import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import 'package:panic_button/services/navigation.dart';
import 'package:panic_button/views/screens/notification/notification_detail.dart';
import 'package:panic_button/localization/language_constraints.dart';
import 'package:panic_button/providers/inbox.dart';
import 'package:panic_button/utils/box_shadow.dart';
import 'package:panic_button/utils/color_resources.dart';
import 'package:panic_button/utils/dimensions.dart';

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
        inboxProvider.fetchInbox(context);
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
                      inboxProvider.fetchInbox(context);
                    });
                  },
                  child: Consumer<InboxProvider>(
                    builder: (BuildContext context, InboxProvider ip, Widget? child) {
                      if(ip.inboxStatus == InboxStatus.loading) {
                        return Center(
                          child: SpinKitThreeBounce(
                            size: 20.0,
                            color: Colors.black87,
                          ),
                        );
                      }
                      if(ip.inboxStatus == InboxStatus.empty) {
                        return Center(
                          child: Text(getTranslated("THERE_IS_NO_NOTIFICATION", context),
                            style: TextStyle(
                              color: ColorResources.black,
                              fontSize: Dimensions.fontSizeDefault
                            ),
                          )
                        );
                      }
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

                          SliverPadding(
                            padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int i) {
                                  return Container(
                                    margin: const EdgeInsets.all(Dimensions.marginSizeDefault),
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
                                                flex: 2,
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
                                                    SizedBox(
                                                      width: 200.0,
                                                      child: Text(ip.inboxes[i].content!,
                                                        softWrap: true,
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
                                                    const SizedBox(height: 12.0),
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
                                                        // const Text("15:38",
                                                        //   style: TextStyle(
                                                        //     color: ColorResources.greyDarkPrimary,
                                                        //     fontWeight: FontWeight.w300,
                                                        //     fontSize: Dimensions.fontSizeExtraSmall
                                                        //   ),
                                                        // )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              )
                                                                              
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