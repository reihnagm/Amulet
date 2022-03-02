import 'package:flutter/material.dart';

import 'package:amulet/utils/helper.dart';
import 'package:amulet/views/screens/ppob/confirm_payment.dart';
import 'package:amulet/views/basewidgets/appbar/custom_appbar.dart';
import 'package:amulet/localization/language_constraints.dart';
import 'package:amulet/utils/color_resources.dart';
import 'package:amulet/utils/dimensions.dart';

class VerifyScreen extends StatelessWidget {

  final String? accountName;
  final String? accountNumber;
  final dynamic bankFee;
  final dynamic productPrice;
  final String? productId;
  final String? transactionId;

  const VerifyScreen({Key? key, 
    this.accountName,
    this.accountNumber,
    this.bankFee,
    this.productPrice,
    this.productId,
    this.transactionId
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorResources.backgroundColor,
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
             
            CustomAppBar(
              title: getTranslated("ACTIVATE_YOUR_ACCOUNT", context), 
              isBackButtonExist: true
            ),

            Expanded(
              child: ListView(
                children: [
                  
                  Container(
                    margin: const EdgeInsets.only(top: 60.0, bottom: 55.0, left: 16.0, right: 16.0),
                    child: Image.asset('assets/images/logo/logo.png',
                      width: 120.0,
                      height: 120.0,
                    ),
                  ),

                  Container(
                    margin: const EdgeInsets.only(
                      left: Dimensions.marginSizeDefault, 
                      right: Dimensions.marginSizeDefault, 
                      bottom: 16.0
                    ),
                    width: double.infinity,
                    child: Center(
                      child: Text(getTranslated("PLEASE_ACTIVATE_YOUR_ACCOUNT", context),
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: Dimensions.fontSizeSmall,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),

                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(left: 16.0, right: 16.0),
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey[600]!,
                          width: 1.0
                        )
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                               SizedBox(
                                width: 150.0,
                                child: Text(getTranslated("NAME", context),
                                  style: TextStyle(
                                    fontSize: Dimensions.fontSizeSmall
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 8.0,
                                child: Text(
                                  ":",
                                  style: TextStyle(
                                    fontSize: Dimensions.fontSizeSmall
                                  ),
                                ),
                              ),
                              Expanded(
                                child: SizedBox(
                                  child: Text(accountName!,
                                    style: TextStyle(
                                      fontSize: Dimensions.fontSizeSmall
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 14.0),
                          
                          Row(
                            children: [
                              SizedBox(
                                width: 150.0,
                                child: Text(getTranslated("PHONE_NUMBER", context),
                                  style: TextStyle(
                                    fontSize: Dimensions.fontSizeSmall
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 8.0,
                                child: Text(
                                  ":",
                                  style: TextStyle(
                                    fontSize: Dimensions.fontSizeSmall
                                  ),
                                ),
                              ),
                              Expanded(
                                child: SizedBox(
                                  child: Text(accountNumber!,
                                    style: TextStyle(
                                      fontSize:  Dimensions.fontSizeSmall
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 14.0),

                          Row(
                            children: [
                              SizedBox(
                                width: 150.0,
                                child: Text(getTranslated("REGISTRATION_FEE", context),
                                  style: TextStyle(
                                    fontSize: Dimensions.fontSizeSmall
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 8.0,
                                child: Text(
                                  ":",
                                  style: TextStyle(
                                    fontSize: Dimensions.fontSizeSmall
                                  ),
                                ),
                              ),

                              Expanded(
                                child: SizedBox(
                                  child: bankFee == null 
                                  ? Text(Helper.formatCurrency(
                                      double.parse(productPrice.toString()))
                                    ) 
                                  : Text(Helper.formatCurrency(
                                      double.parse(productPrice.toString()) + double.parse(bankFee.toString())
                                    ),
                                    style: TextStyle(
                                      fontSize: Dimensions.fontSizeSmall
                                    ),
                                  ),
                                ),
                              ),
                              
                            ],
                          ),

                          const SizedBox(height: 30.0),

                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: ColorResources.primaryOrange,
                              borderRadius: BorderRadius.circular(8.0)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                const Icon(
                                  Icons.info,
                                  size: 40.0,
                                  color: ColorResources.white,
                                ),
                                SizedBox(
                                  width: 250.0,
                                  child: Text(getTranslated("PLEASE_PAY_ACCOUNT", context),
                                    style: TextStyle(
                                      color: ColorResources.white,
                                      fontSize: Dimensions.fontSizeSmall,
                                      height: 1.5
                                    ),
                                  ),
                                ),
                              ],
                            )
                          )

                        ]
                      ),
                    ),
                  ),

                  const SizedBox(height: 30.0),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: ColorResources.white,
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(
                            color: ColorResources.primaryOrange,
                            width: 1.0
                          )
                        ),
                        child: Material(
                          color: Colors.transparent,                
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10.0),
                            splashColor: ColorResources.primaryOrange,
                            onTap: () => Navigator.of(context).pop(),
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0)
                              ),
                              width: 150.0,
                              height: 32.0,
                              child: Text(getTranslated("BACK", context),
                                style: TextStyle(
                                  fontSize: Dimensions.fontSizeSmall,
                                  color: ColorResources.black
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 20.0),

                       Container(
                        decoration: BoxDecoration(
                          color: ColorResources.white,
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(
                            color: ColorResources.primaryOrange,
                            width: 1.0
                          )
                        ),
                        child: Material(
                          color: Colors.transparent,                
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10.0),
                            splashColor: ColorResources.primaryOrange,
                            onTap: () { 
                              Navigator.push(context,
                                MaterialPageRoute(builder: (context) => ConfirmPaymentScreen(
                                  type: "register",
                                  description: "REGISTER",
                                  nominal: productPrice,
                                  bankFee: bankFee,
                                  transactionId: transactionId!,
                                  provider: "register",
                                  accountNumber: accountNumber!,
                                  productId: productId!,
                                )),
                              );
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0)
                              ),
                              width: 150.0,
                              height: 32.0,
                              child: Text(getTranslated("SELECT_PAYMENT", context),
                                style: TextStyle(
                                  fontSize: Dimensions.fontSizeSmall,
                                  color: ColorResources.black
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                    ],
                  )

                ],
              ),
            )

          ],
        ),
      ),
    );
  }
}