import 'package:amulet/localization/language_constraints.dart';
import 'package:amulet/providers/ppob.dart';
import 'package:amulet/utils/color_resources.dart';
import 'package:amulet/utils/dimensions.dart';
import 'package:amulet/utils/helper.dart';
import 'package:amulet/views/basewidgets/appbar/custom_appbar.dart';
import 'package:amulet/views/basewidgets/loader/circular.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';


class HistoryTopUpTransaksiListScreen extends StatelessWidget {

  final String? startDate;
  final String? endDate;

  const HistoryTopUpTransaksiListScreen({Key? key, 
    this.startDate,
    this.endDate
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

    Provider.of<PPOBProvider>(context, listen: false).getHistoryBalance(context, startDate!, endDate!);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [

            CustomAppBar(title: getTranslated("HISTORY_BALANCE", context), isBackButtonExist: true),

            Consumer<PPOBProvider>(
              builder: (BuildContext context, PPOBProvider ppobProvider, Widget? child) {
                
                if(ppobProvider.historyBalanceStatus == HistoryBalanceStatus.loading) {
                  return Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Loader(
                          color: ColorResources.primaryOrange
                        )
                      ],
                    ),
                  );
                }
                if(ppobProvider.historyBalanceStatus == HistoryBalanceStatus.empty) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                          LottieBuilder.asset(
                            "assets/lottie/empty_transaction.json",
                            height: 200,
                            width: 200,
                          ),
                          const SizedBox(height: 20.0),
                          Text("Wah, Anda belum memiliki history",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: Dimensions.fontSizeDefault,
                              color: Colors.black,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          Text("Yuk, isi history anda dengan melakukan transaksi",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: Dimensions.fontSizeDefault, 
                              color: Colors.white
                            ),
                          ),
                        ]
                      )
                    ),
                  );
                }
                
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 16.0, right: 16.0),
                    child: ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemCount: ppobProvider.historyBalanceData.length,
                      itemBuilder: (BuildContext context, int i) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0, top: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(ppobProvider.historyBalanceData[i].type!,
                                    style: TextStyle(
                                      color: ColorResources.black, 
                                      fontSize: 16.0
                                    )
                                  ),
                                  Text(Helper.formatCurrency(double.parse(ppobProvider.historyBalanceData[i].amount.toString())).toString(),
                                  style: TextStyle(
                                    color: ppobProvider.historyBalanceData[i].type != "CREDIT" ? ColorResources.error : ColorResources.success, fontSize: 16.0)
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 2.0,
                              ),
                              Text(ppobProvider.historyBalanceData[i].description!,
                                style: TextStyle(
                                  color: ColorResources.black, 
                                  fontSize: ppobProvider.historyBalanceData[i].type != "CREDIT" ? 14.0 : 16.0 
                                )
                              ),
                              const SizedBox(
                                height: 14.0,
                              ),
                              Text(Helper.formatDate(DateTime.parse(ppobProvider.historyBalanceData[i].created!)),
                                style: TextStyle(
                                  color: ColorResources.black, 
                                  fontSize: 14.0
                                )
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int i) {
                        return const Divider(
                          thickness: 1.0,
                        );
                      },
                    ),
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