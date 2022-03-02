import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'package:amulet/localization/language_constraints.dart';
import 'package:amulet/providers/ppob.dart';
import 'package:amulet/utils/color_resources.dart';
import 'package:amulet/utils/dimensions.dart';
import 'package:amulet/utils/helper.dart';
import 'package:amulet/views/basewidgets/appbar/custom_appbar.dart';
import 'package:amulet/views/basewidgets/loader/circular.dart';

class CashoutScreen extends StatefulWidget {
  const CashoutScreen({Key? key}) : super(key: key);

  @override
  _CashoutScreenState createState() => _CashoutScreenState();
}

class _CashoutScreenState extends State<CashoutScreen> {

  int? selected;
  int price = 0; 
  String priceDisplay = "Rp 0";

  Future inquiryDisbursement() async {
    int amount = price;
    if(amount == 0) {
      Fluttertoast.showToast(
        msg: getTranslated("PLEASE_SELECT_AMOUNT", context),
        backgroundColor: ColorResources.error,
        toastLength: Toast.LENGTH_LONG,
        textColor: ColorResources.white
      );
      return;
    }
    await Provider.of<PPOBProvider>(context, listen: false).inquiryDisbursement(context, amount, price);
  }

  @override
  Widget build(BuildContext context) {

    Provider.of<PPOBProvider>(context, listen: false).getBankDisbursement(context);
    Provider.of<PPOBProvider>(context, listen: false).getEmoneyDisbursement(context);
    Provider.of<PPOBProvider>(context, listen: false).getDenomDisbursement(context);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [

            const CustomAppBar(title: "Cash Out", isBackButtonExist: true),

              StatefulBuilder(
                builder: (BuildContext context, Function s) {
                return Container(
                  margin: const EdgeInsets.only(top: 65.0, bottom: 20.0, left: 16.0, right: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [    

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(getTranslated("AMOUNT", context),
                                style: TextStyle(
                                  fontSize: Dimensions.fontSizeSmall,
                                  color: Colors.grey
                                )
                              ),
                              const SizedBox(height: 2.0),
                              Text(priceDisplay,
                                style: TextStyle(
                                  fontSize: Dimensions.fontSizeSmall,
                                  fontWeight: FontWeight.bold
                                ),
                              )
                            ],
                          ),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(getTranslated("YOUR_BALANCE", context),
                                style: TextStyle(
                                  fontSize: Dimensions.fontSizeSmall,
                                  color: Colors.grey
                                ),
                              ),
                              Consumer<PPOBProvider>(
                                builder: (BuildContext context, PPOBProvider ppobProvider, Widget? child) {
                                  return  Text(ppobProvider.balanceStatus == BalanceStatus.loading 
                                    ? "Rp ..." 
                                    : ppobProvider.balanceStatus == BalanceStatus.error 
                                    ? getTranslated("THERE_WAS_PROBLEM", context)
                                    : Helper.formatCurrency(double.parse(ppobProvider.balance.toString())),
                                    softWrap: true,
                                    style: TextStyle(
                                      fontSize: Dimensions.fontSizeSmall,
                                      fontWeight: FontWeight.bold
                                    ) 
                                  );      
                                },
                              ),
                            ],
                          )

                        ]
                      ),

                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(top: 40.0, bottom: 20.0),
                          child: Consumer<PPOBProvider>(
                            builder: (BuildContext context, PPOBProvider ppobProvider, Widget? child) {
                              
                              if(ppobProvider.denomDisbursementStatus == DenomDisbursementStatus.loading) {
                                return const Loader(
                                  color: ColorResources.primaryOrange
                                );
                              }  
                              
                              if(ppobProvider.denomDisbursementStatus == DenomDisbursementStatus.loading) {
                                return const Loader(
                                  color: ColorResources.primaryOrange
                                );
                              }  
                                return GridView.builder(
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 10.0,
                                    mainAxisSpacing: 10.0,
                                    childAspectRatio: 3 / 1
                                  ),
                                  itemCount: ppobProvider.denomDisbursement.length,
                                  itemBuilder: (BuildContext context, int i) {
                                    return InkWell(
                                      customBorder: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(10.0))
                                      ),
                                      onTap: () {
                                        s(() { 
                                          selected = i;
                                          price = int.parse(ppobProvider.denomDisbursement[i].code!);
                                          priceDisplay = Helper.formatCurrency(double.parse(ppobProvider.denomDisbursement[i].code!));
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(15.0),
                                        width: 240.0,
                                        height: 90.0,
                                        decoration: BoxDecoration(
                                          border: Border.all(color: selected == i ? ColorResources.green : Colors.grey),
                                          borderRadius: BorderRadius.circular(10.0)
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            Expanded(
                                              child:Text(Helper.formatCurrency(double.parse(ppobProvider.denomDisbursement[i].code!)),
                                                style: TextStyle(
                                                  fontSize: Dimensions.fontSizeSmall
                                                )
                                              )
                                            ),
                                            Container(
                                              width: 25.0,
                                              height: 25.0,
                                              decoration: BoxDecoration(
                                                color: Colors.transparent,
                                                border: Border.all(color: selected == i ? ColorResources.green : Colors.grey),
                                                shape: BoxShape.circle
                                              ),
                                              child: Container(
                                              margin: const EdgeInsets.all(5.0),
                                              width: 5.0,
                                              height: 5.0,
                                              decoration: BoxDecoration(
                                                color: selected == i ? ColorResources.green : Colors.transparent,
                                                border: Border.all(color: Colors.transparent),
                                                shape: BoxShape.circle
                                              )
                                              ),
                                            )
                                          ],
                                        ) 
                                      ),
                                    );
                                  },
                                );
                              
                            },
                          )
                        ),
                      )
                    
                    ]
                  ),
                );
              },
            ),

          
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                color: Colors.transparent,
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 16.0, right: 16.0),
                child: ElevatedButton(
                  onPressed: inquiryDisbursement,
                  style: ButtonStyle(
                  elevation: MaterialStateProperty.resolveWith<double>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.disabled)) {
                        return 0;
                      }
                      return 0;
                    },
                  ),
                   backgroundColor: MaterialStateProperty.all(ColorResources.primaryOrange),
                   shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      )
                    )
                  ),
                  child: Consumer<PPOBProvider>(
                    builder: (BuildContext context, PPOBProvider ppobProvider, Widget? child) {
                      return ppobProvider.disbursementStatus == InquiryDisbursementStatus.loading 
                      ? const SizedBox(
                          width: 18.0,
                          height: 18.0,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(ColorResources.white),
                          ),
                        )
                      : Text(getTranslated("CONTINUE", context),
                        style: TextStyle(
                          color: ColorResources.white
                        ),
                      );
                    },
                  )
                ),
              ),
            )

          ],
        ),
      ),
    );
  }
}