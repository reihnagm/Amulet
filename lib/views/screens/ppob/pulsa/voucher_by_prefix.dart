import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:amulet/localization/language_constraints.dart';
import 'package:amulet/utils/color_resources.dart';
import 'package:amulet/utils/dimensions.dart';
import 'package:amulet/utils/exceptions.dart';
import 'package:amulet/utils/helper.dart';
import 'package:amulet/views/basewidgets/appbar/custom_appbar.dart';
import 'package:amulet/views/basewidgets/separator/separator.dart';
import 'package:amulet/providers/ppob.dart';
import 'package:amulet/views/screens/ppob/confirm_payment.dart';

class VoucherPulsaByPrefixScreen extends StatefulWidget {
  const VoucherPulsaByPrefixScreen({Key? key}) : super(key: key);

  @override
  _VoucherPulsaByPrefixScreenState createState() => _VoucherPulsaByPrefixScreenState();
}

class _VoucherPulsaByPrefixScreenState extends State<VoucherPulsaByPrefixScreen> {
  TextEditingController getController = TextEditingController();
  Timer? debounce;
  int? selected;
  String? phoneNumber;
  String? nominal;
  
  phoneNumberChange() {
    if(getController.text.length >= 10) {
      if (getController.text.startsWith('0')) {
        phoneNumber = '62' + getController.text.replaceFirst(RegExp(r'0'), '');
      } else {
        phoneNumber = phoneNumber;
      }
      if (debounce?.isActive ?? false) debounce!.cancel();
      debounce = Timer(const Duration(milliseconds: 500), () {
        Provider.of<PPOBProvider>(context, listen: false).getVoucherPulsaByPrefix(context, int.parse(phoneNumber!));
      });
    } else {
      Provider.of<PPOBProvider>(context, listen: false).getVoucherPulsaByPrefix(context, 0);
    }
  }

  @override 
  void dispose() {
    super.dispose();
    debounce?.cancel();
    getController.removeListener(phoneNumberChange);
    getController.dispose();
  }

  @override 
  void initState() {
    super.initState();   
    getController.addListener(phoneNumberChange);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.backgroundColor,
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            CustomAppBar(title: getTranslated("TOPUP_PULSA", context), isBackButtonExist: true),
            
            Container(
              height: 60.0,
              width: double.infinity,
              margin: const EdgeInsets.only(top: 10.0, left: 5.0, right: 5.0, bottom: 5.0),
              child: Card(
                color: Colors.white,
                elevation: 0.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 250.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
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
                          fillColor: Colors.white,
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding: const EdgeInsets.all(12.0)
                        ),
                        onSubmitted: (value) => setState(() => getController.text),
                        keyboardType: TextInputType.number,
                      )
                    ),
                    InkWell(
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
                        //     getController.addListener(phoneNumberChange);
                        //     Provider.of<PPOBProvider>(context, listen: false).getVoucherPulsaByPrefix(context, int.parse(selectedPhoneContact));
                        //   });
                        // }
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 10.0),
                        child: const Icon(
                          Icons.contacts,
                          color: ColorResources.black
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),

            Expanded(
              child: ListView(
                children: [
                  Consumer<PPOBProvider>(
                    builder: (BuildContext context, PPOBProvider ppobProvider, Widget? child) {
                      if(ppobProvider.listVoucherPulsaByPrefixStatus == ListVoucherPulsaByPrefixStatus.loading) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height / 1.5,
                          child: const Center(
                            child: SizedBox(
                              width: 18.0,
                              height: 18.0,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(ColorResources.primaryOrange),
                              )
                            )
                          ),
                        );
                      }
                      if(ppobProvider.listVoucherPulsaByPrefixStatus == ListVoucherPulsaByPrefixStatus.empty) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height / 1.5,
                          child: Center(
                            child: Text(getTranslated("DATA_NOT_FOUND", context),
                              style: TextStyle(
                                color: ColorResources.black
                              ),
                            ),
                          ),
                        );
                      }
                      if(ppobProvider.listVoucherPulsaByPrefixStatus == ListVoucherPulsaByPrefixStatus.error) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height / 1.5,
                          child: Center(
                            child: Text(getTranslated("THERE_WAS_PROBLEM", context),
                              style: TextStyle(
                                color: ColorResources.black
                              ),
                            ),
                          ),
                        );
                      }
                      return GridView.builder(
                        shrinkWrap: true,
                        itemCount: ppobProvider.listVoucherPulsaByPrefixData.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
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
                                  child: Card(
                                    color: Colors.white,
                                    elevation: 0.0,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        width: 0.5,
                                        color: selected == i ? ColorResources.purpleDark : Colors.transparent
                                      )
                                    ),
                                    child: GestureDetector(
                                      onTap: () async {
                                        try {
                                          if(getController.text.length <= 11) {
                                            throw CustomException("PHONE_NUMBER_10_REQUIRED");
                                          }
                                          setState(() => selected = i);
                                          getController.removeListener(phoneNumberChange);
                                          showMaterialModalBottomSheet(        
                                            isDismissible: false,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
                                            ),
                                            context: context,
                                            builder: (ctx) => SingleChildScrollView(
                                              child: SizedBox(
                                                height: 300.0,
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      margin: const EdgeInsets.only(top: 30.0, left: 16.0, right: 16.0),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(getTranslated("CUSTOMER_INFORMATION", context),
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
                                                              Text(ppobProvider.listVoucherPulsaByPrefixData[i].description!,
                                                                style: TextStyle(
                                                                  fontSize: Dimensions.fontSizeExtraSmall
                                                                ),
                                                              ),
                                                              Text(Helper.formatCurrency(double.parse(ppobProvider.listVoucherPulsaByPrefixData[i].price.toString())),
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
                                                          Text(getTranslated("DETAIL_PAYMENT", context),
                                                            style: TextStyle(
                                                              fontSize: Dimensions.fontSizeSmall,
                                                              fontWeight: FontWeight.bold
                                                            ),
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
                                                              Text(Helper.formatCurrency(ppobProvider.listVoucherPulsaByPrefixData[i].price),
                                                                style: TextStyle(
                                                                  fontSize: Dimensions.fontSizeExtraSmall
                                                                )
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
                                                              Text(Helper.formatCurrency(ppobProvider.listVoucherPulsaByPrefixData[i].price),
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
                                                    const SizedBox(height: 12.0),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      children: [
                                                        SizedBox(
                                                          width: 140.0,
                                                          child:TextButton(
                                                            style: TextButton.styleFrom(
                                                              elevation: 0.0,
                                                              backgroundColor: ColorResources.white,
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(20.0),
                                                                side: BorderSide.none
                                                              ),
                                                            ),
                                                            onPressed: () {
                                                              Future.delayed(const Duration(seconds: 1), () {
                                                                getController.addListener(phoneNumberChange);
                                                              });
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
                                                              Navigator.push(context,
                                                                MaterialPageRoute(builder: (context) => ConfirmPaymentScreen(
                                                                  type: "pulsa",
                                                                  description: ppobProvider.listVoucherPulsaByPrefixData[i].description,
                                                                  nominal : ppobProvider.listVoucherPulsaByPrefixData[i].price,
                                                                  provider: ppobProvider.listVoucherPulsaByPrefixData[i].category!.toLowerCase(),
                                                                  accountNumber: getController.text,
                                                                  productId: ppobProvider.listVoucherPulsaByPrefixData[i].productId,
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
                                            msg: getTranslated(e.toString(), context),
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
                                        child: Center(
                                          child: Text(Helper.formatCurrency(double.parse(ppobProvider.listVoucherPulsaByPrefixData[i].name!)),
                                            style: TextStyle(
                                              color: selected == i ? ColorResources.purpleDark : ColorResources.dimGrey,
                                              fontSize: Dimensions.fontSizeExtraSmall
                                            ),
                                          ),
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
                  )
                ],
              ),
            ),

          ]
        ),
      )
    );
  }
}