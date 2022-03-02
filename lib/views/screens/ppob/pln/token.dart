import 'dart:async';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:amulet/localization/language_constraints.dart';
import 'package:amulet/utils/color_resources.dart';
import 'package:amulet/utils/dimensions.dart';
import 'package:amulet/views/basewidgets/appbar/custom_appbar.dart';
import 'package:amulet/providers/ppob.dart';

class TokenListrikScreen extends StatefulWidget {
  const TokenListrikScreen({Key? key}) : super(key: key);

  @override
  _TokenListrikScreenState createState() => _TokenListrikScreenState();
}

class _TokenListrikScreenState extends State<TokenListrikScreen> {

  int? selected;
  bool error = false;
  Timer? debounce;
  late TextEditingController noMeterController;
  FocusNode focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  noMeterPelangganListener() {
    if(noMeterController.text.length <= 9) {
      if(debounce?.isActive ?? false) debounce!.cancel();
      debounce = Timer(const Duration(milliseconds: 500), () {
        Provider.of<PPOBProvider>(context, listen: false).getListPricePLNPrabayar(context);
      });
    } 
  }

  @override
  void initState() {
    super.initState();
    noMeterController = TextEditingController();  
    noMeterController.addListener(noMeterPelangganListener);
  }

  @override
  void dispose() {
    debounce?.cancel();
    noMeterController.removeListener(noMeterPelangganListener);
    noMeterController.dispose();
    super.dispose();
  }

  Future postInquiryPLNPrabayarStatus(String productId) async {
    try { 
      if(noMeterController.text.length <= 9) {
        throw Exception();
      } else {
        setState(() => error = false);
      }
      await Provider.of<PPOBProvider>(context, listen: false).postInquiryPLNPrabayarStatus(context, productId, noMeterController.text, "WALLET");
    } on Exception catch(_) {
      setState(() => error = true);
    } catch(e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: ColorResources.bgGrey,
      body: SafeArea(
        child: Column(
          children: [

            const CustomAppBar(title: "Token Listrik", isBackButtonExist: true),

            Container(
              color: ColorResources.white,
              padding: const EdgeInsets.all(10.0),
              width: double.infinity,
              height: 140.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Container(
                    margin: const EdgeInsets.only(top: 10.0, left: 14.0),
                    child: Text(getTranslated("METER_NUMBER", context),
                      style: TextStyle(
                        color: ColorResources.black,
                        fontSize: Dimensions.fontSizeSmall
                      ),
                    ),
                  ),

                  Form(
                    key: formKey,
                    child: Container(
                      margin: const EdgeInsets.only(top: 8.0, left: 10.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(10.0)
                      ),
                      child: TextFormField(
                        controller: noMeterController,
                        focusNode: focusNode,
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          fontSize: Dimensions.fontSizeSmall,
                          color: error ? ColorResources.white : ColorResources.hintColor
                        ),
                        decoration: InputDecoration(
                          errorMaxLines: 1,
                          hintText: "Contoh 1234567890",
                          hintStyle: TextStyle(
                            fontSize: Dimensions.fontSizeSmall,
                            color: error ? ColorResources.white : ColorResources.hintColor
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16.0, 
                            horizontal: 22.0
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                            style: BorderStyle.none, width: 0),
                          ),
                          fillColor: error ? ColorResources.error : ColorResources.transparent,
                          filled: true,
                          isDense: true
                        ),
                      ),
                    ),
                  ), 

                  error 
                  ? Container(
                      margin: const EdgeInsets.only(left: 14.0, top: 10.0),
                      child: Text(getTranslated("METER_NUMBER_MINIMUM_10", context),
                        style: TextStyle(
                          fontSize: Dimensions.fontSizeSmall,
                          color: ColorResources.error
                        ),
                      ),
                    ) 
                  : Container()

                ],
              ),
            ),
            
            Consumer<PPOBProvider>(
              builder: (BuildContext context, PPOBProvider ppobProvider, Widget? child) {
                if(ppobProvider.listPricePLNPrabayarStatus == ListPricePLNPrabayarStatus.loading) {
                  return const Expanded(
                    child: Center(
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
                if(ppobProvider.listPricePLNPrabayarStatus == ListPricePLNPrabayarStatus.empty) {
                  return Container();
                }
                return Expanded(
                  child: GridView.builder(
                    itemCount: ppobProvider.listPricePLNPrabayarData.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1/1,
                      crossAxisSpacing: 0.0,
                      mainAxisSpacing: 0.0,
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
                                  borderRadius: BorderRadius.circular(10.0),
                                  side: BorderSide(
                                    width: 0.5,
                                    color: selected == i 
                                    ? ColorResources.purpleDark 
                                    : Colors.transparent
                                  )
                                ),
                                child: GestureDetector(
                                  onTap: () async {
                                    setState(() => selected = i);
                                    setState(() {
                                      error = false;
                                    });
                                    if(error == true) {
                                      focusNode.requestFocus();
                                    } else {
                                      await postInquiryPLNPrabayarStatus(ppobProvider.listPricePLNPrabayarData[i].productId!);
                                    }
                                  },
                                  child: Container(
                                    width: 100.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6.0)
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Center(
                                          child: Text(NumberFormat("###,000", "id_ID").format(ppobProvider.listPricePLNPrabayarData[i].price),
                                            style: TextStyle(
                                              color: selected == i 
                                              ? ColorResources.purpleDark 
                                              : ColorResources.dimGrey.withOpacity(0.8),
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
                  ),
                );
              },
            ), 

            Consumer<PPOBProvider>(
              builder: (BuildContext context, PPOBProvider ppobProvider, Widget? child) {
                return ppobProvider.btnNextBuyPLNPrabayar 
                ? Container(
                    width: double.infinity,
                    color: ColorResources.white,
                    height: 60.0,
                    padding: const EdgeInsets.all(8.0),
                    child: const Center(
                      child: SizedBox(
                        width: 18.0,
                        height: 18.0,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(ColorResources.hintColor),
                        ),
                      ),
                    ),
                  )  
                : const SizedBox();
              },
            )

          ],
        ),
      ),
    );
  }
}