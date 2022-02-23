import 'package:amulet/localization/language_constraints.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import 'package:amulet/utils/color_resources.dart';
import 'package:amulet/utils/dimensions.dart';
import 'package:amulet/providers/contact.dart';

class ContactsListScreen extends StatefulWidget {
  const ContactsListScreen({ Key? key }) : super(key: key);

  @override
  State<ContactsListScreen> createState() => _ContactsListScreenState();
}

class _ContactsListScreenState extends State<ContactsListScreen> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  late ContactProvider contactProvider;
  
  @override 
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await contactProvider.getContacts(context);
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
        return Scaffold(
          key: globalKey,
          resizeToAvoidBottomInset: false,
          backgroundColor: ColorResources.backgroundColor,
          body: Consumer<ContactProvider>(
            builder: (BuildContext context, ContactProvider contactProvider, Widget? child) {

              if(contactProvider.contactsStatus == ContactsStatus.loading) {
                return Center(
                  child: SpinKitThreeBounce(
                    size: 20.0,
                    color: Colors.black87,
                  )
                );
              }
              
              if(contactProvider.contactsStatus == ContactsStatus.error) {
                return Center(
                  child: SpinKitThreeBounce(
                    size: 20.0,
                    color: Colors.black87,
                  )
                );
              } 

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
                  ),
  
                  SliverPadding(
                    padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int i) {
                          if(contactProvider.contacts[i].displayName == null) {
                            return SizedBox();
                          }
                          return Container(
                            margin: EdgeInsets.only(
                              left: Dimensions.marginSizeDefault,
                              right: Dimensions.marginSizeDefault
                            ),
                            child: ListTile(
                              dense: true,
                              title: Text(contactProvider.contacts[i].displayName!,
                                style: TextStyle(
                                  fontSize: Dimensions.fontSizeDefault
                                ),
                              ),
                              onTap: () async {
                                await contactProvider.addContact(context, identifier: contactProvider.contacts[i].displayName!);
                              },
                              trailing: Icon(
                                Icons.add,
                                size: 15.0,
                                color: ColorResources.black,
                              ),
                            ),
                          );
                        },
                        childCount: contactProvider.contacts.length
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