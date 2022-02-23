import 'package:amulet/services/navigation.dart';
import 'package:amulet/views/screens/contacts/list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import 'package:amulet/localization/language_constraints.dart';
import 'package:amulet/providers/contact.dart';
import 'package:amulet/utils/color_resources.dart';
import 'package:amulet/utils/dimensions.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({ Key? key }) : super(key: key);

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  late ContactProvider contactProvider;
  late NavigationService navigationService;

  @override 
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await contactProvider.getContacts(context);
      await contactProvider.saveContact(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return buildUI();
  }

  Widget buildUI() {
    return Builder(
      builder: (BuildContext context) {
        contactProvider = context.read<ContactProvider>();
        navigationService = NavigationService();
        return Scaffold(
          key: globalKey,
          resizeToAvoidBottomInset: false,
          backgroundColor: ColorResources.backgroundColor,
          body: Consumer<ContactProvider>(
            builder: (BuildContext context, ContactProvider contactProvider, Widget? child) {
              return CustomScrollView(
                physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                slivers: [

                  SliverAppBar(
                    centerTitle: true,
                    pinned: true,
                    backgroundColor: ColorResources.backgroundColor,
                    elevation: 0.0,
                    title: Text(getTranslated("CONTACT_EMERGENCY", context),
                      style: TextStyle(
                        fontSize: Dimensions.fontSizeDefault,
                        color: ColorResources.black
                      ),
                    ),
                    leading: CupertinoNavigationBarBackButton(
                      color: ColorResources.black,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    actions: [
                      Container(
                        margin: EdgeInsets.only(right: Dimensions.marginSizeDefault),
                        child: InkWell(
                          onTap: () {
                            navigationService.pushNav(context, ContactsListScreen(key: UniqueKey()));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.person_add,
                              size: 20.0,
                              color: ColorResources.black,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),

                  if(contactProvider.saveContacts.isEmpty)
                    SliverFillRemaining(
                      child: Center(
                        child: Text("Belum ada kontak",
                          style: TextStyle(
                            fontSize: Dimensions.fontSizeSmall,
                            color: ColorResources.black
                          ),
                        ),
                      ),
                    ),
  
                  SliverPadding(
                    padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int i) {
                          return Container(
                            margin: EdgeInsets.only(
                              left: Dimensions.marginSizeDefault,
                              right: Dimensions.marginSizeDefault
                            ),
                            child: ListTile(
                              dense: true,
                              title: Text(contactProvider.saveContacts[i]["identifier"]!,
                                style: TextStyle(
                                  fontSize: Dimensions.fontSizeDefault
                                ),
                              ),
                              onTap: () {
                               
                              },
                            ),
                          );
                        },
                        childCount: contactProvider.saveContacts.length
                      )
                    ),
                  )

                ],
              );
            },
          )
        );
      },
    );
  }
}