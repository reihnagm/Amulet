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
      if(mounted) {
        await contactProvider.saveContact(context);
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
        contactProvider = context.read<ContactProvider>();
        navigationService = NavigationService();
        return Scaffold(
          key: globalKey,
          resizeToAvoidBottomInset: false,
          backgroundColor: ColorResources.backgroundColor,
          floatingActionButton: Consumer<ContactProvider>(
            builder: (BuildContext context, ContactProvider cp, Widget? child) {
              return FloatingActionButton(
                onPressed: () {
                  if(cp.selectedContacsDelete.isNotEmpty) {
                    cp.removeContact(context);
                  } else {
                    navigationService.pushNav(context, ContactsListScreen(key: UniqueKey()));
                  }
                },
                backgroundColor: ColorResources.redPrimary,
                child: Icon(
                  cp.selectedContacsDelete.isNotEmpty  
                  ? Icons.remove_circle
                  : Icons.person_add,
                  size: 20.0,
                ),
              );
            },
          ),
          body: Consumer<ContactProvider>(
            builder: (BuildContext context, ContactProvider cp, Widget? child) {
              return RefreshIndicator(
                backgroundColor: ColorResources.redPrimary,
                color: ColorResources.white,
                onRefresh: () {
                  return Future.sync(() {
                    contactProvider.saveContact(context);
                  });
                },
                child: CustomScrollView(
                  physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                  slivers: [
              
                    SliverAppBar(
                      centerTitle: true,
                      pinned: true,
                      backgroundColor: ColorResources.backgroundColor,
                      elevation: 0.0,
                      title: cp.selectedContacsDelete.isNotEmpty 
                      ? Text((("${getTranslated("CONTACT_EMERGENCY", context)} (${cp.selectedContacsDelete.length})").toString()),
                          style: TextStyle(
                            fontSize: Dimensions.fontSizeDefault,
                            color: ColorResources.black
                          )
                        )
                      : Text(getTranslated("CONTACT_EMERGENCY", context),
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
                        // Container(
                        //   margin: EdgeInsets.only(
                        //     top: 8.0,
                        //     left: Dimensions.marginSizeSmall,
                        //     right: Dimensions.marginSizeSmall,
                        //   ),
                        //   child: InkWell(
                        //     onTap: () async {
                        //       if(cp.selectedContacsDelete.isNotEmpty) {
                        //         await cp.removeContact(context);
                        //       } else {
                        //         navigationService.pushNav(context, ContactsListScreen(key: UniqueKey()));
                        //       }
                        //     },
                        //     child: Padding(
                        //       padding: const EdgeInsets.all(8.0),
                        //       child: cp.selectedContacsDelete.isNotEmpty 
                        //       ? Text("Hapus",
                        //           style: TextStyle(
                        //             fontSize: Dimensions.fontSizeDefault,
                        //             color: ColorResources.black
                        //           ),
                        //         ) 
                        //       : Icon(
                        //           Icons.person_add,
                        //           size: 20.0,
                        //           color: ColorResources.black,
                        //         ),
                        //     ),
                        //   ),
                        // )
                      ],
                      bottom: PreferredSize(
                        child:  Container(
                          margin: EdgeInsets.only(
                            top: Dimensions.marginSizeSmall, 
                            left: Dimensions.marginSizeDefault, 
                            right: Dimensions.marginSizeDefault
                          ),
                          child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              onChanged: (val) {
                                cp.runFilter(enteredKeyword: val);
                              },
                              cursorColor: ColorResources.black,
                              decoration: InputDecoration(
                                labelText: getTranslated("SEARCH", context),
                                labelStyle: TextStyle(
                                  fontSize: Dimensions.fontSizeDefault,
                                  color: ColorResources.black
                                ),
                                floatingLabelBehavior: FloatingLabelBehavior.auto,
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(),
                                errorBorder: OutlineInputBorder(),
                                enabledBorder: OutlineInputBorder()
                              ),
                            )
                          ],
                        ),
                      ),
                        preferredSize: const Size.fromHeight(60.0) 
                      ),
                    ),
              
                    if(cp.saveContactsStatus == SaveContactsStatus.loading)
                      SliverFillRemaining(
                        child: Center(
                          child: SpinKitThreeBounce(
                            size: 20.0,
                            color: Colors.black87,
                          )
                        ),
                      ),
              
                    if(cp.saveContactsStatus == SaveContactsStatus.empty)
                      SliverFillRemaining(
                        child: Center(
                          child: Text(getTranslated("THERE_IS_NO_CONTACTS", context),
                            style: TextStyle(
                              fontSize: Dimensions.fontSizeDefault,
                              color: ColorResources.black
                            ),
                          ),
                        ),
                      ),
              
                    SliverPadding(
                      padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          cp.saveContactsResults.isNotEmpty 
                          ? ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              itemCount: cp.saveContactsResults.length,
                              itemBuilder: (BuildContext context, int i) {
                                return Container(
                                  margin: EdgeInsets.only(
                                    left: Dimensions.marginSizeDefault,
                                    right: Dimensions.marginSizeDefault
                                  ),
                                  child: ListTile(
                                    dense: true,
                                    title: Text(cp.saveContactsResults[i].name!,
                                      style: TextStyle(
                                        fontSize: Dimensions.fontSizeDefault
                                      ),
                                    ),
                                    subtitle: Text(cp.saveContactsResults[i].identifier!,
                                      style: TextStyle(
                                        fontSize: Dimensions.fontSizeSmall
                                      ),
                                    ),
                                    onTap: () { },  
                                    trailing: IconButton(
                                      onPressed: () {
                                        cp.removeContactPerId(context, contactId: cp.saveContacts[i].uid!);
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        size: 20.0,  
                                      ),
                                      color: ColorResources.redPrimary,
                                    )
                                  ),  
                                );
                              }
                            )
                          : ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              itemCount: cp.saveContacts.length,
                              itemBuilder: (BuildContext context, int i) {
                              return Container(
                                margin: EdgeInsets.only(
                                  left: Dimensions.marginSizeDefault,
                                  right: Dimensions.marginSizeDefault
                                ),
                                child: ListTile(
                                  dense: true,
                                  title: Text(cp.saveContacts[i].name!,
                                    style: TextStyle(
                                      fontSize: Dimensions.fontSizeDefault
                                    ),
                                  ),
                                  subtitle: Text(cp.saveContacts[i].identifier!,
                                    style: TextStyle(
                                      fontSize: Dimensions.fontSizeSmall
                                    ),
                                  ),
                                  onTap: () { },
                                  trailing: IconButton(
                                    onPressed: () {
                                      cp.removeContactPerId(context, contactId: cp.saveContacts[i].uid!);
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      size: 20.0,  
                                    ),
                                    color: ColorResources.redPrimary,
                                  )
                                  
                                  // Checkbox(
                                  //   value: cp.selectedContacsDelete.contains(cp.saveContacts[i]),
                                  //   onChanged: (bool? n) {
                                  //     cp.toggleContactRemove(contacts: cp.saveContacts[i]);
                                  //   },
                                  // ),
                                ),
                              );
                            }
                          )
                        ]),
                        // delegate: SliverChildBuilderDelegate(
                        //   (BuildContext context, int i) {
                        //     return Container(
                        //       margin: EdgeInsets.only(
                        //         left: Dimensions.marginSizeDefault,
                        //         right: Dimensions.marginSizeDefault
                        //       ),
                        //       child: ListTile(
                        //         dense: true,
                        //         title: Text(contactProvider.saveContacts[i]["identifier"]!,
                        //           style: TextStyle(
                        //             fontSize: Dimensions.fontSizeDefault
                        //           ),
                        //         ),
                        //         onTap: () {
                                 
                        //         },
                        //       ),
                        //     );
                        //   },
                        //   childCount: contactProvider.saveContacts.length
                        // )
                      ),
                    )
              
                  ],
                ),
              );
            },
          )
        );
      },
    );
  }
}