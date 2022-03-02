import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:amulet/localization/language_constraints.dart';
import 'package:amulet/utils/color_resources.dart';
import 'package:amulet/utils/dimensions.dart';
import 'package:amulet/utils/exceptions.dart';
import 'package:amulet/utils/helper.dart';
import 'package:amulet/views/basewidgets/separator/separator.dart';
import 'package:amulet/providers/ppob.dart';
import 'package:amulet/views/basewidgets/appbar/custom_appbar.dart';
import 'package:amulet/views/screens/ppob/confirm_payment.dart';

class DetailVoucherEmoneyScreen extends StatefulWidget {
  final String? type;

  const DetailVoucherEmoneyScreen({Key? key, 
    this.type
  }) : super(key: key);

  @override
  _DetailVoucherEmoneyScreenState createState() => _DetailVoucherEmoneyScreenState();
}

class _DetailVoucherEmoneyScreenState extends State<DetailVoucherEmoneyScreen> {
  int? selected;
  TextEditingController getController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {

    Provider.of<PPOBProvider>(context, listen: false).getListEmoney(context, widget.type!);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [

            CustomAppBar(title: widget.type!, isBackButtonExist: true),
            
            Container(
              height: 60.0,
              width: double.infinity,
              margin: const EdgeInsets.only(top: 10.0, left: 5.0, right: 5.0, bottom: 5.0),
              child: Card(
                color: ColorResources.white,
                elevation: 0.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 250.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: ColorResources.white,
                        borderRadius: BorderRadius.circular(4.0)
                      ),
                      child: TextField(
                        controller: getController,
                        style: TextStyle(
                          fontSize: Dimensions.fontSizeSmall,
                          color: ColorResources.black
                        ),
                        decoration: InputDecoration(
                          hintText: getTranslated("PHONE_NUMBER", context),
                          hintStyle: TextStyle(
                            fontSize: Dimensions.fontSizeSmall
                          ),
                          fillColor: ColorResources.white,
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding: const EdgeInsets.all(12.0)
                        ),
                        onSubmitted: (val) {
                          setState(() => getController.text);
                        },
                        keyboardType: TextInputType.number,
                      )
                    ),
                    GestureDetector(
                      onTap: () async {
                        // Contact contact = await contactPicker.selectContact();
                        // if(contact != null) {
                        //   var selectedPhoneContact;
                        //   var selectedContact = contact.phoneNumber.replaceAll(RegExp("[()+\\s-]+"), "");
                        //   if (selectedContact.startsWith('0')) {
                        //     selectedPhoneContact = '62' + selectedContact.replaceFirst(RegExp(r'0'), '');
                        //   } else {
                        //     selectedPhoneContact = selectedContact;
                        //   }
                        //   setState(() {
                        //     getController = TextEditingController(text: selectedPhoneContact);
                          // });
                        // } 
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 10.0),
                        child: const Icon(
                          Icons.contacts,
                          color: ColorResources.black,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),

            Consumer<PPOBProvider>(
              builder: (BuildContext context, PPOBProvider ppobProvider, Widget? child) {
                if(ppobProvider.listTopUpEmoneyStatus == ListTopUpEmoneyStatus.loading) {
                  return const Expanded(
                    child: Center(
                      child: SizedBox(
                        width: 18.0,
                        height: 18.0,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(ColorResources.primaryOrange,
                        )
                      )
                    )
                  ));
                }
                if(ppobProvider.listTopUpEmoneyStatus == ListTopUpEmoneyStatus.empty) {
                  return Expanded(
                    child: Center(
                      child: Text(getTranslated("DATA_NOT_FOUND", context),
                        style: TextStyle(
                          fontSize: Dimensions.fontSizeDefault
                        ),
                      ),
                    ),
                  );
                }
                if(ppobProvider.listTopUpEmoneyStatus == ListTopUpEmoneyStatus.error) {
                  return Expanded(
                    child: Center(
                      child: Text(getTranslated("THERE_WAS_PROBLEM", context),
                        style: TextStyle(
                          fontSize: Dimensions.fontSizeDefault
                        ),
                      ),
                    ),
                  );
                }
                return Expanded(
                  child: StatefulBuilder(
                    builder: (BuildContext context, Function s) {
                      return GridView.builder(
                        shrinkWrap: true,
                        itemCount: ppobProvider.listTopUpEmoney.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 0.0,
                          mainAxisSpacing: 0.0,
                          childAspectRatio: 2 / 1
                        ),
                        physics: const ScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int i) {
                          return Row(
                            children: [
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.all(5.0),
                                  height: 80.0,
                                  child: Card(
                                    elevation: 0.0,
                                    color: ColorResources.white,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        color: selected == i ? ColorResources.purpleLight : Colors.transparent,
                                        width: 0.5
                                      )
                                    ),
                                    child: GestureDetector(
                                      onTap: () async {
                                      try {
                                        if(getController.text.length <= 11) {
                                          throw CustomException(getTranslated("PHONE_NUMBER_10_REQUIRED", context));
                                        }
                                        s(() => selected = i);
                                        showMaterialModalBottomSheet(        
                                          isDismissible: false,
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
                                          ),
                                          context: context,
                                            builder: (ctx) => SingleChildScrollView(
                                              child: SizedBox(
                                                height: 340.0,
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      margin: const EdgeInsets.only(top: 30.0, left: 16.0, right: 16.0),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(getTranslated("CUSTOMER_INFORMATION", context),
                                                            softWrap: true,
                                                            style: TextStyle(
                                                              fontSize: Dimensions.fontSizeSmall,
                                                              fontWeight: FontWeight.bold
                                                            ),
                                                          ),
                                                          const SizedBox(height: 12.0),
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text(getTranslated("PHONE_NUMBER", context),
                                                                style: TextStyle(
                                                                  fontSize: Dimensions.fontSizeExtraSmall
                                                                ),
                                                              ),
                                                              Text(getController.text,
                                                                style: TextStyle(
                                                                  fontSize: Dimensions.fontSizeExtraSmall
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                          const SizedBox(height: 8.0),
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text(ppobProvider.listTopUpEmoney[i].description!,
                                                                style: TextStyle(
                                                                  fontSize: Dimensions.fontSizeExtraSmall
                                                                ),
                                                              ),
                                                              Text(Helper.formatCurrency(double.parse(ppobProvider.listTopUpEmoney[i].price.toString())),
                                                                style: TextStyle(
                                                                  fontSize: Dimensions.fontSizeExtraSmall
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(height: 20.0),
                                                    Container(
                                                      width: double.infinity,
                                                      color: Colors.blueGrey[50],
                                                      height: 8.0,
                                                    ),
                                                    const SizedBox(height: 12.0),
                                                    Container(
                                                      margin: const EdgeInsets.only(left: 16.0, right: 16.0),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          SizedBox(
                                                            child: Text(getTranslated("DETAIL_PAYMENT", context),
                                                              softWrap: true,
                                                              style: TextStyle(
                                                                fontSize: Dimensions.fontSizeSmall,
                                                                fontWeight: FontWeight.bold
                                                              ),
                                                            )
                                                          ),
                                                          const SizedBox(height: 12.0),
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text(getTranslated("VOUCHER_PRICE", context),
                                                                style: TextStyle(
                                                                  fontSize: Dimensions.fontSizeExtraSmall
                                                                ),
                                                              ),
                                                              Text(Helper.formatCurrency(double.parse(ppobProvider.listTopUpEmoney[i].price.toString())),
                                                                style: TextStyle(
                                                                  fontSize: Dimensions.fontSizeExtraSmall
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                          const SizedBox(height: 10.0),
                                                          MySeparatorDash(
                                                            color: Colors.blueGrey[50]!,
                                                            height: 3.0,
                                                          ),
                                                          const SizedBox(height: 12.0),
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text(getTranslated("TOTAL_PAYMENT", context),
                                                                style: TextStyle(
                                                                  fontSize: Dimensions.fontSizeSmall,
                                                                  fontWeight: FontWeight.bold
                                                                ),
                                                              ),
                                                              Text(Helper.formatCurrency(double.parse(ppobProvider.listTopUpEmoney[i].price.toString())),
                                                                style: TextStyle(
                                                                  fontSize: Dimensions.fontSizeExtraSmall,
                                                                  fontWeight: FontWeight.bold
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(height: 50.0),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      children: [
                                                        SizedBox(
                                                          width: 140.0,
                                                          child: TextButton(
                                                            style: TextButton.styleFrom(
                                                              elevation: 0.0,
                                                              backgroundColor: ColorResources.white,
                                                              shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(20.0),
                                                              side: BorderSide.none
                                                            ),
                                                            ),
                                                            onPressed: () {
                                                              s(() { selected = null; });
                                                              Navigator.of(ctx).pop();
                                                            },
                                                            child: Text(getTranslated("CHANGE", context),
                                                              style: TextStyle(
                                                                fontSize: Dimensions.fontSizeSmall,
                                                                color: ColorResources.purpleDark
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 140.0,
                                                          child: TextButton(
                                                            style: TextButton.styleFrom(
                                                              elevation: 0.0,
                                                              backgroundColor: ColorResources.purpleDark,
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(20.0),
                                                                side: BorderSide.none
                                                              )
                                                            ),
                                                            onPressed: () {
                                                              Navigator.push(ctx,
                                                                MaterialPageRoute(builder: (ctx) => ConfirmPaymentScreen(
                                                                  type: "emoney",
                                                                  description: ppobProvider.listTopUpEmoney[i].description,
                                                                  nominal : ppobProvider.listTopUpEmoney[i].price,
                                                                  provider: ppobProvider.listTopUpEmoney[i].category!.toLowerCase(),
                                                                  accountNumber: getController.text,
                                                                  productId: ppobProvider.listTopUpEmoney[i].productId,
                                                                )),
                                                              );
                                                            },
                                                            child: Text(getTranslated("CONFIRM", context),
                                                              style: TextStyle(
                                                                fontSize: Dimensions.fontSizeSmall,
                                                                color: ColorResources.white
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        } on CustomException catch(e) {
                                          Fluttertoast.showToast(
                                            msg: e.toString(),
                                            backgroundColor: ColorResources.error    
                                          );
                                        } catch(e) {
                                          debugPrint(e.toString());
                                        }
                                      },
                                      child: Container(
                                        width: 100.0,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius .circular(4.0)
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Center(
                                              child: Text(Helper.formatCurrency(double.parse(ppobProvider.listTopUpEmoney[i].name!)),
                                                style: TextStyle(
                                                  color: selected == i ? ColorResources.purpleDark : ColorResources.dimGrey,
                                                  fontSize: Dimensions.fontSizeSmall
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ),
                              )
                            ]
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),

          ],
        ),
      ),
    );
  }
}