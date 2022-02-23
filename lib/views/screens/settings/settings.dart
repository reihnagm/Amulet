import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import 'package:amulet/localization/language_constraints.dart';
import 'package:amulet/providers/localization.dart';
import 'package:amulet/utils/color_resources.dart';
import 'package:amulet/utils/dimensions.dart';
import 'package:provider/provider.dart';
import 'package:flutter_switch/flutter_switch.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({ Key? key }) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return buildUI();
  }

  Widget buildUI() {
    return Builder(
      builder: (BuildContext context) {
        return Scaffold(
          key: globalKey,
          backgroundColor: ColorResources.backgroundColor,
          body: SafeArea(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return CustomScrollView(
                  physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                  slivers: [
              
                    SliverAppBar(
                      backgroundColor: ColorResources.white,
                      elevation: 0.0,
                      centerTitle: true,
                      automaticallyImplyLeading: false,
                      title: Text(getTranslated("SETTINGS", context),
                        style: const TextStyle(
                          color: ColorResources.black,
                          fontSize: Dimensions.fontSizeDefault
                        ),
                      ),
                      leading: CupertinoNavigationBarBackButton(
                        color: ColorResources.black,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ),

                    SliverList(
                      delegate: SliverChildListDelegate([

                          Container(
                            margin: const EdgeInsets.only(top: Dimensions.marginSizeSmall, left: Dimensions.marginSizeSmall, right: Dimensions.marginSizeSmall),
                            child: ExpandableNotifier(
                            initialExpanded: false,
                            child: Card(
                              clipBehavior: Clip.antiAlias,
                              elevation: 1.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)
                              ),
                              child: ScrollOnExpand(
                                scrollOnExpand: true,
                                scrollOnCollapse: false,
                                child: ExpandablePanel(
                                  theme: const ExpandableThemeData(
                                    headerAlignment: ExpandablePanelHeaderAlignment.center,
                                    tapBodyToCollapse: true,
                                    iconColor: ColorResources.secondaryV3Background,
                                    iconPadding: EdgeInsets.all(Dimensions.paddingSizeDefault)
                                  ),
                                  header: Container(
                                    padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                                    child: Text(getTranslated("SETTINGS_LANGUAGE", context),
                                      style: TextStyle(
                                        color: ColorResources.secondaryV3Background,
                                        fontSize: constraints.maxWidth < 400 ? Dimensions.fontSizeDefault : Dimensions.fontSizeDefault
                                      )
                                    )
                                  ),
                                  collapsed: const SizedBox(),
                                  expanded: Container(
                                    padding: const EdgeInsets.only(
                                      left: Dimensions.paddingSizeLarge, 
                                      right: Dimensions.paddingSizeLarge,
                                      bottom: Dimensions.paddingSizeDefault
                                    ),
                                    decoration: BoxDecoration(
                                      color: ColorResources.transparent,
                                      borderRadius: BorderRadius.circular(8.0)
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(getTranslated("INDONESIAN", context),
                                              style: const TextStyle(
                                                color: ColorResources.secondaryV3Background,
                                                fontSize: Dimensions.fontSizeSmall
                                              ),
                                            ),
                                            Consumer<LocalizationProvider>(
                                              builder: (BuildContext context, LocalizationProvider localizationProvider, Widget? child) {
                                                return FlutterSwitch(
                                                  showOnOff: false,
                                                  width: 80.0,
                                                  height: 35.0,
                                                  valueFontSize: 20.0,
                                                  toggleSize: 30.0,
                                                  borderRadius: 30.0,
                                                  padding: 5.0,
                                                  value: localizationProvider.isIndonesian,
                                                  activeColor: ColorResources.backgroundGreenLightPrimary,
                                                  onToggle: (val) {
                                                    localizationProvider.toggleLanguage();
                                                  },
                                                );
                                              },
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 20.0),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(getTranslated("ENGLISH", context),
                                              style: const TextStyle(
                                                color: ColorResources.secondaryV3Background,
                                                fontSize: Dimensions.fontSizeSmall
                                              ),
                                            ),
                                            Consumer<LocalizationProvider>(
                                              builder: (BuildContext context, LocalizationProvider localizationProvider, Widget? child) {
                                                return FlutterSwitch(
                                                  showOnOff: false,
                                                  width: 80.0,
                                                  height: 35.0,
                                                  valueFontSize: 20.0,
                                                  toggleSize: 30.0,
                                                  borderRadius: 30.0,
                                                  padding: 5.0,
                                                  value: localizationProvider.isIEnglish,
                                                  activeColor: ColorResources.backgroundGreenLightPrimary,
                                                  onToggle: (val) {
                                                    localizationProvider.toggleLanguage();
                                                  },
                                                );
                                              },
                                            )
                                          ],
                                        )
                                      ],
                                    )
                                  ),
                                  builder: (BuildContext context, Widget collapsed, Widget expanded) {
                                    return Expandable(
                                      collapsed: collapsed,
                                      expanded: expanded,
                                      theme: const ExpandableThemeData(
                                        crossFadePoint: 0
                                      ),
                                    );
                                  },
                                ),
                              ),
                            )
                          ),
                        ),

                      ])
                    )

                  ],
                );
              },
            )
          )
        );
      },
    );
  }
}