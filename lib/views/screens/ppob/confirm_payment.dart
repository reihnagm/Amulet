import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'package:amulet/localization/language_constraints.dart';
import 'package:amulet/providers/ppob.dart';
import 'package:amulet/utils/color_resources.dart';
import 'package:amulet/utils/dimensions.dart';
import 'package:amulet/utils/exceptions.dart';
import 'package:amulet/utils/helper.dart';
import 'package:amulet/views/basewidgets/appbar/custom_appbar.dart';
import 'package:amulet/views/basewidgets/separator/separator.dart';

class ConfirmPaymentScreen extends StatefulWidget {
  final String? productId;
  final String? transactionId;
  final String? description;
  final dynamic nominal;
  final dynamic bankFee;
  final String? provider;
  final String? accountNumber;
  final String? type;

  const ConfirmPaymentScreen({Key? key, 
    this.productId,
    this.transactionId,
    this.description,
    this.nominal,
    this.bankFee,
    this.provider,
    this.accountNumber,
    this.type
  }) : super(key: key);

  @override
  _ConfirmPaymentScreenState createState() => _ConfirmPaymentScreenState();
}

class _ConfirmPaymentScreenState extends State<ConfirmPaymentScreen> {
  bool method = false;
  bool loadingBuyBtn = false;
  String methodName = "";
  String paymentChannel = "";
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {

    Provider.of<PPOBProvider>(context, listen: false).getVA(context);

    return Scaffold(
      backgroundColor: ColorResources.bgGrey,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            CustomAppBar(title: getTranslated("CONFIRM_PAYMENT", context)),
            
            ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: Container(
                width: double.infinity,
                height: 150.0,
                margin: const EdgeInsets.only(bottom: 4.0),
                padding: const EdgeInsets.all(10.0),
                decoration: const BoxDecoration(
                  color: ColorResources.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0.0, 1.0),
                      blurRadius: 4.0,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Image.asset('assets/icons/ic-${widget.provider}.png',
                          width: 32.0,
                          height: 32.0,
                        ),
                        const SizedBox(width: 15.0),
                        Text(widget.description!.toUpperCase(),
                          style: TextStyle(
                            fontSize: Dimensions.fontSizeSmall,
                            color: ColorResources.black
                          ),
                        )
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 15.0, left: 16.0, right: 16.0),
                      child: const Divider(
                        color: Colors.grey,
                        thickness: 0.2,
                      )
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10.0, left: 12.0, right: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text(getTranslated("PAYMENT", context),
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: ColorResources.dimGrey.withOpacity(0.8)
                                )
                              ),
                              const SizedBox(height: 5.0),   
                              Stack(
                                children: [
                                  if(widget.bankFee != null)                                   
                                    Container(
                                      margin: const EdgeInsets.only(left: 18.0),
                                      child: Text(Helper.formatCurrency(double.parse(widget.nominal.toString()) + double.parse(widget.bankFee.toString())),
                                        style: TextStyle(
                                          fontSize: Dimensions.fontSizeSmall,
                                          color: ColorResources.black
                                        )
                                      ),
                                    ),
                                  if(widget.bankFee == null)      
                                    Container(
                                      margin: const EdgeInsets.only(left: 18.0),
                                      child: Text(Helper.formatCurrency(double.parse(widget.nominal.toString())),
                                        style: TextStyle(
                                          fontSize: Dimensions.fontSizeSmall,
                                          color: ColorResources.black
                                        )
                                      ),
                                    )
                                ],
                              )
                            ],
                          ),
                          InkWell(
                            onTap: () {
                              showMaterialModalBottomSheet(        
                                isDismissible: true,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
                                ),
                                context: context,
                                builder: (ctx) => SingleChildScrollView(
                                  child: SizedBox(
                                    height:  widget.bankFee != null ? 290.0 : 260.0,
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
                                                  if(widget.type == "pulsa" || widget.type == "register" || widget.type == "emoney" || widget.type == "topup")
                                                    Text(getTranslated("PHONE_NUMBER", context), style: TextStyle(
                                                      fontSize: Dimensions.fontSizeExtraSmall
                                                    )),
                                                  if(widget.type == "pln-prabayar")
                                                    Text(getTranslated("METER_NUMBER", context), style: TextStyle(
                                                      fontSize: Dimensions.fontSizeExtraSmall
                                                    )),
                                                  if(widget.type == "pln-pascabayar")
                                                    Text(getTranslated("CUSTOMER_ID", context), style: TextStyle(
                                                      fontSize: Dimensions.fontSizeExtraSmall
                                                    )),
                                                  Text(widget.accountNumber!, style: TextStyle(
                                                    fontSize: Dimensions.fontSizeExtraSmall
                                                  ))
                                                ],
                                              ),
                                              const SizedBox(height: 8.0),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(widget.description!,
                                                    style: TextStyle(
                                                      fontSize: Dimensions.fontSizeExtraSmall
                                                    ),
                                                  ),
                                                  Text(Helper.formatCurrency(double.parse(widget.nominal.toString())),
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
                                                  if(widget.type == "register")
                                                    Text(getTranslated("REGISTRATION_FEE", context), style: TextStyle(
                                                      fontSize: Dimensions.fontSizeExtraSmall
                                                    )),
                                                  if(widget.type == "pulsa" || widget.type == "emoney" || widget.type == "topup")
                                                    Text(getTranslated("VOUCHER_PRICE", context), style: TextStyle(
                                                      fontSize: Dimensions.fontSizeExtraSmall
                                                    )),
                                                  if(widget.type == "pln-prabayar")
                                                    Text(getTranslated("VOUCHER_PRICE", context), style: TextStyle(
                                                      fontSize: Dimensions.fontSizeExtraSmall
                                                    )),
                                                  if(widget.type == "pln-pascabayar")
                                                    Text(getTranslated("BILLS_TO_PAY", context), style: TextStyle(
                                                      fontSize: Dimensions.fontSizeExtraSmall
                                                    )),
                                                  Text(Helper.formatCurrency(double.parse(widget.nominal.toString())),
                                                    style: TextStyle(
                                                      fontSize: Dimensions.fontSizeExtraSmall
                                                    ),
                                                  )
                                                ],
                                              ),
                                              const SizedBox(height: 10.0),
                                              if(widget.bankFee != null)
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text("Bank Fee",
                                                      style: TextStyle(
                                                        fontSize: Dimensions.fontSizeExtraSmall
                                                      ),
                                                    ),
                                                    Text(Helper.formatCurrency(double.parse(widget.bankFee.toString())),
                                                      style: TextStyle(
                                                        fontSize: Dimensions.fontSizeExtraSmall
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              if(widget.bankFee != null)
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
                                                  if(widget.bankFee != null)
                                                    Text(Helper.formatCurrency(double.parse(widget.nominal.toString()) +  double.parse(widget.bankFee.toString())),
                                                      style: TextStyle(
                                                        fontSize: Dimensions.fontSizeExtraSmall,
                                                        fontWeight: FontWeight.bold
                                                      ),
                                                    ),
                                                  if(widget.bankFee == null)  
                                                    Text(Helper.formatCurrency(double.parse(widget.nominal.toString())),
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
                                      
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: Text(getTranslated("SEE_DETAILS", context),
                              style: TextStyle(
                                fontSize: Dimensions.fontSizeSmall,
                                color: ColorResources.primaryOrange
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ) 
              ),
            ),

          Container(
            margin: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 16.0, right: 16.0),
            child: Text(getTranslated("METHOD_PAYMENT", context),
              style: TextStyle(
                color: ColorResources.black
              )
            ),
          ),

          if(widget.type == "topup" || widget.type == "register")
            Consumer<PPOBProvider>(
              builder: (BuildContext context, PPOBProvider ppobProvider, Widget? child) {
                if(ppobProvider.vaStatus == VaStatus.loading) {
                  return Container();
                }
                return Expanded(
                  child: ListView.builder(
                    itemCount: ppobProvider.listVa.length,
                    itemBuilder: (BuildContext context, int i) {
                      return Row(
                        children: [
                        Expanded(
                          child: Container(
                          margin: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0, top: 8.0),
                          child: Card(
                            elevation: 2.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              side: const BorderSide(
                                width: 1, 
                                color: ColorResources.purpleLight
                              )
                            ),
                            color: ColorResources.white,
                            child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedIndex = i;
                                paymentChannel = ppobProvider.listVa[i].channel!;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: selectedIndex == i ? ColorResources.purpleLight : Colors.transparent,
                                borderRadius: BorderRadius.circular(4.0)
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        child: CachedNetworkImage(
                                          imageUrl: ppobProvider.listVa[i].paymentLogo!,
                                          height: 30.0,
                                          fit: BoxFit.cover,
                                          placeholder: (BuildContext context, String url) => Center(
                                            child: Shimmer.fromColors(
                                            baseColor: Colors.grey[200]!,
                                            highlightColor: Colors.grey[300]!,
                                            child: Container(
                                              color: Colors.white,
                                              height: double.infinity,
                                            ),
                                          )),
                                          errorWidget: (BuildContext context, String url, dynamic error) => Center(
                                            child: Image.asset("assets/default_image.png",
                                            height: 20.0,
                                            fit: BoxFit.cover,
                                          )),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(left: 10.0),
                                        child: Text(
                                          ppobProvider.listVa[i].name!,
                                          style: TextStyle(
                                            color: selectedIndex == i ? ColorResources.white : ColorResources.primaryOrange
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ))),
                      ],
                    );
                  }),
                );
              },
            ),
          if(widget.type != "topup" && widget.type != "register")
            Expanded(
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)
                ),
                child: Container(
                  margin: const EdgeInsets.only(left: 16.0, right: 16.0),
                  padding: const EdgeInsets.all(10.0),
                  color: ColorResources.white,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("e-Rupiah",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: ColorResources.black
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Consumer<PPOBProvider>(
                                builder: (BuildContext context, PPOBProvider ppobProvider, Widget? child) {
                                  return Text(
                                    ppobProvider.balanceStatus == BalanceStatus.loading 
                                    ? "..."
                                    : ppobProvider.balanceStatus == BalanceStatus.error 
                                    ?  "..."
                                    : Helper.formatCurrency(double.parse(ppobProvider.balance.toString())),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: Dimensions.fontSizeSmall,
                                      color: ColorResources.black
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0)
                            ),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  method = !method;
                                  methodName = method ? "wallet" : "";
                                });
                              },
                              child: method 
                              ? const Icon(
                                  Icons.check_box
                                )
                              : const Icon(
                                  Icons.check_box_outline_blank
                                ),
                            )
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),     
            ),
            Container(
              color: ColorResources.bgGrey,
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 15.0, bottom: 15.0),
              width: double.infinity,
              height: 80.0,
              child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: ColorResources.primaryOrange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)
                ),
              ),
              onPressed: () async {
                try {
                  if(widget.type != "topup" && widget.type != "register") {
                    if(methodName == "") {
                      throw CustomException("PLEASE_SELECT_METHOD_PAYMENT");
                    }
                  } else {
                    if(paymentChannel == "") {
                      throw CustomException("PLEASE_SELECT_BANK");
                    }
                  }
                  switch (widget.type) {
                    case "pulsa":
                      await Provider.of<PPOBProvider>(context, listen: false).purchasePulsa(context, widget.productId!, widget.accountNumber!);
                    break;
                    case "register": 
                      await Provider.of<PPOBProvider>(context, listen: false).payRegister(context, widget.productId!, paymentChannel, widget.transactionId!);
                    break;
                    case "emoney":
                      await Provider.of<PPOBProvider>(context, listen: false).purchaseEmoney(context, widget.productId!, widget.accountNumber!);
                    break;
                    case "pln-prabayar":
                      final getTransactionId = Provider.of<PPOBProvider>(context, listen: false).inquiryPLNPrabayarData!.transactionId;
                      await Provider.of<PPOBProvider>(context, listen: false).payPLNPrabayar(context, widget.productId!, widget.accountNumber!, getTransactionId!);
                    break;  
                    case "pln-pascabayar":
                      final getTransactionId = Provider.of<PPOBProvider>(context, listen: false).inquiryPLNPascaBayarData!.transactionId;
                      await Provider.of<PPOBProvider>(context, listen: false).payPLNPascabayar(context, widget.accountNumber!, getTransactionId!);
                    break;
                    case "topup":
                      await Provider.of<PPOBProvider>(context, listen: false).inquiryTopUp(context, widget.productId!, widget.accountNumber!);
                      final inquiryTopUpData = Provider.of<PPOBProvider>(context, listen: false).inquiryTopUpData;
                      await Provider.of<PPOBProvider>(context, listen: false).payTopUp(context, inquiryTopUpData!.productId!, paymentChannel, inquiryTopUpData.transactionId!);
                    break;
                    default:
                  }
                } on CustomException catch(e) {
                  Fluttertoast.showToast(
                    msg: getTranslated(e.toString(), context),
                    backgroundColor: ColorResources.error
                  );
                } catch(e) {
                  debugPrint(e.toString());
                }
              },
              child: Consumer<PPOBProvider>(
                builder: (BuildContext context, PPOBProvider ppobProvider, Widget? child) {
                  return ppobProvider.loadingBuyBtn ? const Center(
                    child: SizedBox(
                      width: 18.0,
                      height: 18.0,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(ColorResources.white
                      ),
                    )),
                  ) : Text(getTranslated("PAY", context),
                    style: TextStyle(
                      fontSize: Dimensions.fontSizeSmall,
                      fontWeight: FontWeight.bold,
                      color: ColorResources.white,
                    ),
                  );
                },
              ),
            ))
          ],
        ),
      ),
    );
  }
}