import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import 'package:amulet/localization/language_constraints.dart';
import 'package:amulet/providers/auth.dart';
import 'package:amulet/utils/color_resources.dart';
import 'package:amulet/utils/dimensions.dart';
import 'package:amulet/utils/helper.dart';
import 'package:amulet/views/basewidgets/loader/circular.dart';
import 'package:amulet/views/basewidgets/separator/separator.dart';
import 'package:amulet/views/basewidgets/appbar/custom_appbar.dart';
import 'package:amulet/providers/ppob.dart';
import 'package:amulet/views/screens/ppob/confirm_payment.dart';

class TopUpScreen extends StatefulWidget {
  const TopUpScreen({Key? key}) : super(key: key);

  @override
  _TopUpScreenState createState() => _TopUpScreenState();
}

class _TopUpScreenState extends State<TopUpScreen> {
  int selected = -1;

  @override
  Widget build(BuildContext context) {

    Provider.of<PPOBProvider>(context, listen: false).getListEmoney(context, "CX_WALLET");
   
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [

            CustomAppBar(title: getTranslated("TOPUP", context), isBackButtonExist: true),

            Consumer<PPOBProvider>(
              builder: (BuildContext context, PPOBProvider ppobProvider, Widget? child) {
                if(ppobProvider.listTopUpEmoneyStatus == ListTopUpEmoneyStatus.loading) {
                  return const Expanded(
                      child: Loader(
                      color: ColorResources.primaryOrange,
                    ),
                  );
                }
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(top: 10.0),
                    child: StatefulBuilder(
                      builder: (BuildContext context, s) {
                        return GridView.builder(
                          itemCount: ppobProvider.listTopUpEmoney.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 1.0,
                          ),
                          physics: const ScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemBuilder: (BuildContext ctx, int i) {
                            return Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.all(5.0),
                                    child: Card(
                                      elevation: 0.0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15.0),
                                        side: const BorderSide(
                                          width: 1.0,
                                          color: ColorResources.primaryOrange
                                        )
                                      ),
                                      color: selected == i 
                                      ? ColorResources.primaryOrange 
                                      : ColorResources.white,
                                      child: GestureDetector(
                                        onTap: () {
                                          s(() => selected = i);
                                          showMaterialModalBottomSheet(        
                                            isDismissible: false,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(20.0), 
                                                topRight: Radius.circular(20.0)
                                              ),
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
                                                                Text(context.read<AuthProvider>().getUserPhone()!,
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
                                                                  )
                                                                ),
                                                                Text(
                                                                  Helper.formatCurrency(double.parse(ppobProvider.listTopUpEmoney[i].price.toString())),
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
                                                                    fontSize: Dimensions.fontSizeExtraSmall,
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
                                                      const SizedBox(height: 12.0),
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
                                                                )
                                                              ),
                                                              onPressed: () {
                                                                Navigator.of(ctx).pop();
                                                              },
                                                              child: Text(getTranslated("CHANGE", context),
                                                                style: TextStyle(
                                                                  fontSize: Dimensions.fontSizeSmall,
                                                                  color: ColorResources.primaryOrange
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 140.0,
                                                            child: TextButton(
                                                              style: TextButton.styleFrom(
                                                                elevation: 0.0,
                                                                backgroundColor: ColorResources.primaryOrange,
                                                                shape: RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.circular(20.0),
                                                                  side: BorderSide.none
                                                                )
                                                              ),
                                                              onPressed: () {
                                                                Navigator.push(ctx,
                                                                  MaterialPageRoute(builder: (ctx) => ConfirmPaymentScreen(
                                                                    type: "topup",
                                                                    description: ppobProvider.listTopUpEmoney[i].description,
                                                                    nominal: ppobProvider.listTopUpEmoney[i].price,
                                                                    provider: ppobProvider.listTopUpEmoney[i].category!.toLowerCase(),
                                                                    accountNumber: Provider.of<AuthProvider>(context, listen: false).getUserPhone(),
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
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.only(top: 10.0),
                                          width: 100.0,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius .circular(10.0)
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Center(
                                                child: Text(NumberFormat("###,000", "id_ID").format(ppobProvider.listTopUpEmoney[i].price),
                                                  style: TextStyle(
                                                    color: selected == i ? ColorResources.white : ColorResources.primaryOrange,
                                                    fontSize: Dimensions.fontSizeSmall
                                                  ),
                                                )
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
                  ));
                },
              )
            ],
          ),
        ),
      );
    }

  }
