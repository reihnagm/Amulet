import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import 'package:amulet/localization/language_constraints.dart';
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
      if(mounted) {
        await contactProvider.getContacts(context);
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
        return Scaffold(
          key: globalKey,
          resizeToAvoidBottomInset: false,
          backgroundColor: ColorResources.backgroundColor,
          body: Consumer<ContactProvider>(
            builder: (BuildContext context, ContactProvider cp, Widget? child) {

              if(cp.contactsStatus == ContactsStatus.loading) {
                return Center(
                  child: SpinKitThreeBounce(
                    size: 20.0,
                    color: Colors.black87,
                  )
                );
              }
              
              if(cp.contactsStatus == ContactsStatus.error) {
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
                    backgroundColor: ColorResources.redPrimary,
                    elevation: 0.0,
                    title:  cp.selectedContacts.isNotEmpty 
                    ? Text((("${getTranslated("CONTACT_EMERGENCY", context)} (${cp.selectedContacts.length})").toString()),
                        style: TextStyle(
                          fontSize: Dimensions.fontSizeDefault,
                          color: ColorResources.white
                        )
                      )
                    : Text(getTranslated("CONTACT_EMERGENCY", context),
                      style: TextStyle(
                        fontSize: Dimensions.fontSizeDefault,
                        color: ColorResources.white
                      ),
                    ),
                    actions: [
                      cp.selectedContacts.isNotEmpty 
                      ? InkWell(
                          onTap: () {
                            cp.addContact(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              margin: EdgeInsets.only(
                                top: Dimensions.marginSizeSmall,
                                left: Dimensions.marginSizeDefault, 
                                right: Dimensions.marginSizeDefault,
                                bottom: Dimensions.marginSizeSmall
                              ),
                              child: Icon(Icons.save,
                                color: ColorResources.white,
                                size: 20.0,
                              )
                          ),
                        ))
                      : const SizedBox()
                    ],
                    leading: CupertinoNavigationBarBackButton(
                      color: ColorResources.white,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
  
                  SliverPadding(
                    padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        Container(
                          margin: const EdgeInsets.only(left: Dimensions.marginSizeDefault),
                          alignment: Alignment.center,
                          child: Text(getTranslated("SELECT_UP_TO_FIVE_CONTACTS", context),
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: Dimensions.fontSizeDefault
                            ),
                          ),
                        ),
                        ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: cp.contacts.length,
                          separatorBuilder: (BuildContext context, int i) {
                            return Divider();
                          },
                          itemBuilder: (BuildContext context, int i) {
                            return Container(
                              margin: EdgeInsets.only(
                                left: Dimensions.marginSizeDefault,
                                right: Dimensions.marginSizeDefault
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: [ 
                                  
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if((cp.contacts[i].displayName == cp.contacts[i].phones![0].value))
                                        Container(),

                                      Text(cp.contacts[i].displayName!,
                                        style: TextStyle(
                                          fontSize: Dimensions.fontSizeDefault
                                        ),
                                      ),

                                      const SizedBox(height: 8.0),

                                      Text(cp.contacts[i].phones![0].value!,
                                        style: TextStyle(
                                          color: ColorResources.grey,
                                          fontSize: Dimensions.fontSizeSmall
                                        ),
                                      ),
                                    ],
                                  ),

                                  Checkbox(
                                    value: cp.selectedContacts.contains(cp.contacts[i]),
                                    onChanged: (bool? newValue) {
                                      cp.toggleContact(contacts: cp.contacts[i]);
                                    },
                                  ),
                              
                                ],
                              )
                                
                                // ListTile(
                                //   dense: true,
                                //   title: Text(contactProvider.contacts[i].displayName!,
                                //     style: TextStyle(
                                //       fontSize: Dimensions.fontSizeDefault
                                //     ),
                                //   ),
                                //   onTap: () async {
                                //     if(contactProvider.contacts[i].phones!.isNotEmpty) {
                                //       await contactProvider.addContact(context, 
                                //         identifier: contactProvider.contacts[i].displayName!,
                                //         phone: contactProvider.contacts[i].phones![0].value!
                                //       );
                                //     }
                                //   },
                                //   trailing: Icon(
                                //     Icons.add,
                                //     size: 15.0,
                                //     color: ColorResources.black,
                                //   ),
                                // ),

                              );
                            },
                          )
                        ]
                        // (BuildContext context, int i) {
                        //   if(contactProvider.contacts[i].displayName == null) {
                        //     return SizedBox();
                        //   }
                        //   return Container(
                        //     margin: EdgeInsets.only(
                        //       left: Dimensions.marginSizeDefault,
                        //       right: Dimensions.marginSizeDefault
                        //     ),
                        //     child: ListTile(
                        //       dense: true,
                        //       title: Text(contactProvider.contacts[i].displayName!,
                        //         style: TextStyle(
                        //           fontSize: Dimensions.fontSizeDefault
                        //         ),
                        //       ),
                        //       onTap: () async {
                        //         if(contactProvider.contacts[i].phones!.isNotEmpty) {
                        //           await contactProvider.addContact(context, 
                        //             identifier: contactProvider.contacts[i].displayName!,
                        //             phone: contactProvider.contacts[i].phones![0].value!
                        //           );
                        //         }
                        //       },
                        //       trailing: Icon(
                        //         Icons.add,
                        //         size: 15.0,
                        //         color: ColorResources.black,
                        //       ),
                        //     ),
                        //   );
                        // },
                        // childCount: contactProvider.contacts.length
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