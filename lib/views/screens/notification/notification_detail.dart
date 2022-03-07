
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import 'package:amulet/services/navigation.dart';
import 'package:amulet/views/screens/media/preview_file.dart';
import 'package:amulet/utils/box_shadow.dart';
import 'package:amulet/utils/dimensions.dart';
import 'package:amulet/localization/language_constraints.dart';
import 'package:amulet/providers/inbox.dart';
import 'package:amulet/utils/color_resources.dart';

class NotificationDetail extends StatefulWidget {
  final String uid;
  final String title;
  final String content;
  final String thumbnail;
  final String mediaUrl;
  final String type;
  final String createdAt;
  final PagingController pagingController;
  const NotificationDetail({ 
    required this.uid,
    required this.title,
    required this.content,
    required this.thumbnail,
    required this.mediaUrl,
    required this.type,
    required this.createdAt,
    required this.pagingController,
    Key? key 
  }) : super(key: key);

  @override
  _NotificationDetailState createState() => _NotificationDetailState();
}

class _NotificationDetailState extends State<NotificationDetail> {
  late InboxProvider inboxProvider;
  late NavigationService navigationService;

  @override 
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      if(mounted) {
        await inboxProvider.updateInbox(
          context, 
          uid: widget.uid,
        );
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
          body: CustomScrollView(
            physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()) ,
            slivers: [
              SliverAppBar(
                backgroundColor: ColorResources.white,
                centerTitle: true,
                title: Text(getTranslated("NOTIFICATION_DETAIL", context),
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
                  delegate: SliverChildListDelegate([
                    Container(
                      padding: EdgeInsets.all(Dimensions.paddingSizeLarge),
                      margin: EdgeInsets.all(Dimensions.marginSizeDefault),
                      decoration: BoxDecoration(
                        color: ColorResources.white,
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: boxShadow
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(widget.title,
                                softWrap: true,
                                style: TextStyle(
                                  color: ColorResources.black,
                                  fontWeight: FontWeight.w400,
                                  fontSize: Dimensions.fontSizeSmall,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(6.0),
                                decoration: BoxDecoration(
                                  color: widget.type == "done"
                                  ? ColorResources.success 
                                  : ColorResources.redPrimary,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Text(widget.type == "done"
                                ? getTranslated("DONE", context)
                                : getTranslated("ONGOING", context),
                                  style: TextStyle(
                                    fontSize: Dimensions.fontSizeSmall,
                                    fontWeight: FontWeight.bold,
                                    color: ColorResources.white
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6.0),
                          Text(widget.content,
                            softWrap: true,
                            style: TextStyle(
                              color: ColorResources.black,
                              fontWeight: FontWeight.w400,
                              fontSize: Dimensions.fontSizeSmall,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(widget.createdAt,
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
                                          imageUrl: widget.thumbnail.toString(),
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
                                                mediaUrl: widget.mediaUrl
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
                          )
                        ],
                      ),
                    )
                  ]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}